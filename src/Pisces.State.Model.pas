unit Pisces.State.Model;

interface

uses
  System.SysUtils,
  System.Rtti,
  System.TypInfo,
  System.JSON,
  System.IOUtils,
  System.Generics.Collections;

type
  /// <summary>
  /// Marks a field to be excluded from JSON serialization.
  /// </summary>
  JsonIgnoreAttribute = class(TCustomAttribute)
  end;

  /// <summary>
  /// Specifies a custom JSON key name for a field.
  /// </summary>
  JsonNameAttribute = class(TCustomAttribute)
  private
    FName: String;
  public
    constructor Create(const AName: String);
    property Name: String read FName;
  end;

  /// <summary>
  /// Base class for state models with automatic JSON persistence.
  /// Inherit from this class to define your app's state structure.
  /// </summary>
  TPscStateModel = class
  private
    class var FStatePaths: TDictionary<String, String>;
    class constructor Create;
    class destructor Destroy;
    class function ObjectToJson(Obj: TObject): TJSONObject;
    class function JsonToObject<T: class, constructor>(JsonObj: TJSONObject): T;
    class procedure JsonToObjectInstance(Obj: TObject; JsonObj: TJSONObject);
    class function ValueToJsonValue(const Value: TValue; RttiType: TRttiType): TJSONValue;
    class function JsonValueToValue(JsonVal: TJSONValue; RttiType: TRttiType): TValue;
    class function GetFieldJsonName(Field: TRttiField): String;
    class function IsFieldIgnored(Field: TRttiField): Boolean;
    class function GetDynArrayElType(ArrType: TRttiType): TRttiType;
  public
    /// <summary>
    /// Sets custom file path for this model type.
    /// </summary>
    class procedure SetStatePath(const APath: String);

    /// <summary>
    /// Gets the file path (defaults to Documents/{ClassName}.json).
    /// </summary>
    class function GetStatePath: String;

    /// <summary>
    /// Saves this model instance to JSON file.
    /// </summary>
    procedure Save;

    /// <summary>
    /// Loads model from JSON file. Creates new instance if file doesn't exist.
    /// </summary>
    class function Load<T: TPscStateModel, constructor>: T;

    /// <summary>
    /// Converts this model to JSON string.
    /// </summary>
    function ToJson: String;

    /// <summary>
    /// Creates model instance from JSON string.
    /// </summary>
    class function FromJson<T: TPscStateModel, constructor>(const JsonString: String): T;
  end;

implementation

uses
  Pisces.Logger,
  Pisces.Types;

{ JsonNameAttribute }

constructor JsonNameAttribute.Create(const AName: String);
begin
  inherited Create;
  FName := AName;
end;

{ TPscStateModel }

class constructor TPscStateModel.Create;
begin
  FStatePaths := TDictionary<String, String>.Create;
end;

class destructor TPscStateModel.Destroy;
begin
  FStatePaths.Free;
end;

class procedure TPscStateModel.SetStatePath(const APath: String);
begin
  FStatePaths.AddOrSetValue(ClassName, APath);
end;

class function TPscStateModel.GetStatePath: String;
begin
  if not FStatePaths.TryGetValue(ClassName, Result) then
    Result := TPath.Combine(TPath.GetDocumentsPath, ClassName + '.json');
end;

class function TPscStateModel.GetFieldJsonName(Field: TRttiField): String;
var
  Attr: TCustomAttribute;
begin
  Result := Field.Name;
  for Attr in Field.GetAttributes do begin
    if Attr is JsonNameAttribute then begin
      Result := JsonNameAttribute(Attr).Name;
      Break;
    end;
  end;
end;

class function TPscStateModel.IsFieldIgnored(Field: TRttiField): Boolean;
var
  Attr: TCustomAttribute;
begin
  Result := False;
  for Attr in Field.GetAttributes do begin
    if Attr is JsonIgnoreAttribute then begin
      Result := True;
      Break;
    end;
  end;
end;

class function TPscStateModel.GetDynArrayElType(ArrType: TRttiType): TRttiType;
var
  RttiContext: TRttiContext;
  DynArrType: TRttiDynamicArrayType;
begin
  Result := nil;
  RttiContext := TRttiContext.Create;
  try
    if ArrType is TRttiDynamicArrayType then begin
      DynArrType := TRttiDynamicArrayType(ArrType);
      Result := DynArrType.ElementType;
    end;
  finally
    RttiContext.Free;
  end;
end;

class function TPscStateModel.ValueToJsonValue(const Value: TValue; RttiType: TRttiType): TJSONValue;
var
  Obj: TObject;
  JsonArr: TJSONArray;
  ElType: TRttiType;
  I, ArrLen: Integer;
begin
  case RttiType.TypeKind of
    tkInteger:
      Result := TJSONNumber.Create(Value.AsInteger);
    tkInt64:
      Result := TJSONNumber.Create(Value.AsInt64);
    tkFloat:
      if RttiType.Handle = TypeInfo(TDateTime) then
        Result := TJSONString.Create(DateTimeToStr(Value.AsType<TDateTime>))
      else if RttiType.Handle = TypeInfo(TDate) then
        Result := TJSONString.Create(DateToStr(Value.AsType<TDate>))
      else if RttiType.Handle = TypeInfo(TTime) then
        Result := TJSONString.Create(TimeToStr(Value.AsType<TTime>))
      else
        Result := TJSONNumber.Create(Value.AsExtended);
    tkString, tkLString, tkWString, tkUString:
      Result := TJSONString.Create(Value.AsString);
    tkEnumeration:
      if RttiType.Handle = TypeInfo(Boolean) then
        Result := TJSONBool.Create(Value.AsBoolean)
      else
        Result := TJSONNumber.Create(Value.AsOrdinal);
    tkClass:
      begin
        Obj := Value.AsObject;
        if Obj <> nil then
          Result := ObjectToJson(Obj)
        else
          Result := TJSONNull.Create;
      end;
    tkDynArray:
      begin
        JsonArr := TJSONArray.Create;
        ElType := GetDynArrayElType(RttiType);
        if ElType <> nil then begin
          ArrLen := Value.GetArrayLength;
          for I := 0 to ArrLen - 1 do
            JsonArr.AddElement(ValueToJsonValue(Value.GetArrayElement(I), ElType));
        end;
        Result := JsonArr;
      end;
  else
    Result := TJSONNull.Create;
  end;
end;

class function TPscStateModel.JsonValueToValue(JsonVal: TJSONValue; RttiType: TRttiType): TValue;
var
  NestedObj: TObject;
  RttiContext: TRttiContext;
  InstanceType: TRttiInstanceType;
  JsonArr: TJSONArray;
  ElType: TRttiType;
  I: Integer;
  ArrLen: NativeInt;
  ArrPtr: Pointer;
  ElValue: TValue;
  DynArrType: TRttiDynamicArrayType;
begin
  if (JsonVal = nil) or (JsonVal is TJSONNull) then begin
    Result := TValue.Empty;
    Exit;
  end;

  case RttiType.TypeKind of
    tkInteger:
      Result := TValue.From<Integer>(TJSONNumber(JsonVal).AsInt);
    tkInt64:
      Result := TValue.From<Int64>(TJSONNumber(JsonVal).AsInt64);
    tkFloat:
      if RttiType.Handle = TypeInfo(TDateTime) then
        Result := TValue.From<TDateTime>(StrToDateTimeDef(TJSONString(JsonVal).Value, 0))
      else if RttiType.Handle = TypeInfo(TDate) then
        Result := TValue.From<TDate>(StrToDateDef(TJSONString(JsonVal).Value, 0))
      else if RttiType.Handle = TypeInfo(TTime) then
        Result := TValue.From<TTime>(StrToTimeDef(TJSONString(JsonVal).Value, 0))
      else
        Result := TValue.From<Double>(TJSONNumber(JsonVal).AsDouble);
    tkString, tkLString, tkWString, tkUString:
      Result := TValue.From<String>(TJSONString(JsonVal).Value);
    tkEnumeration:
      if RttiType.Handle = TypeInfo(Boolean) then
        Result := TValue.From<Boolean>(TJSONBool(JsonVal).AsBoolean)
      else
        Result := TValue.FromOrdinal(RttiType.Handle, TJSONNumber(JsonVal).AsInt);
    tkClass:
      begin
        if JsonVal is TJSONObject then begin
          RttiContext := TRttiContext.Create;
          try
            InstanceType := RttiContext.GetType(RttiType.Handle) as TRttiInstanceType;
            NestedObj := InstanceType.MetaclassType.Create;
            JsonToObjectInstance(NestedObj, TJSONObject(JsonVal));
            Result := TValue.From<TObject>(NestedObj);
          finally
            RttiContext.Free;
          end;
        end else
          Result := TValue.Empty;
      end;
    tkDynArray:
      begin
        if JsonVal is TJSONArray then begin
          JsonArr := TJSONArray(JsonVal);
          ElType := GetDynArrayElType(RttiType);
          if ElType <> nil then begin
            DynArrType := RttiType as TRttiDynamicArrayType;
            ArrLen := JsonArr.Count;
            ArrPtr := nil;
            DynArraySetLength(ArrPtr, DynArrType.Handle, 1, @ArrLen);
            TValue.Make(@ArrPtr, RttiType.Handle, Result);
            for I := 0 to ArrLen - 1 do begin
              ElValue := JsonValueToValue(JsonArr.Items[I], ElType);
              if not ElValue.IsEmpty then
                Result.SetArrayElement(I, ElValue);
            end;
          end else
            Result := TValue.Empty;
        end else
          Result := TValue.Empty;
      end;
  else
    Result := TValue.Empty;
  end;
end;

class function TPscStateModel.ObjectToJson(Obj: TObject): TJSONObject;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Field: TRttiField;
  FieldValue: TValue;
  JsonName: String;
begin
  Result := TJSONObject.Create;
  if Obj = nil then Exit;

  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Obj.ClassType);
    for Field in RttiType.GetFields do begin
      if IsFieldIgnored(Field) then Continue;
      if Field.Visibility < mvPublic then Continue;

      JsonName := GetFieldJsonName(Field);
      FieldValue := Field.GetValue(Obj);
      Result.AddPair(JsonName, ValueToJsonValue(FieldValue, Field.FieldType));
    end;
  finally
    RttiContext.Free;
  end;
end;

class procedure TPscStateModel.JsonToObjectInstance(Obj: TObject; JsonObj: TJSONObject);
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Field: TRttiField;
  JsonName: String;
  JsonValue: TJSONValue;
  FieldValue: TValue;
begin
  if (Obj = nil) or (JsonObj = nil) then Exit;

  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Obj.ClassType);
    for Field in RttiType.GetFields do begin
      if IsFieldIgnored(Field) then Continue;
      if Field.Visibility < mvPublic then Continue;

      JsonName := GetFieldJsonName(Field);
      JsonValue := JsonObj.GetValue(JsonName);
      if JsonValue <> nil then begin
        FieldValue := JsonValueToValue(JsonValue, Field.FieldType);
        if not FieldValue.IsEmpty then
          Field.SetValue(Obj, FieldValue);
      end;
    end;
  finally
    RttiContext.Free;
  end;
end;

class function TPscStateModel.JsonToObject<T>(JsonObj: TJSONObject): T;
begin
  Result := T.Create;
  JsonToObjectInstance(Result, JsonObj);
end;

function TPscStateModel.ToJson: String;
var
  JsonObj: TJSONObject;
begin
  JsonObj := ObjectToJson(Self);
  try
    Result := JsonObj.ToJSON;
  finally
    JsonObj.Free;
  end;
end;

class function TPscStateModel.FromJson<T>(const JsonString: String): T;
var
  JsonObj: TJSONObject;
begin
  JsonObj := TJSONObject.ParseJSONValue(JsonString) as TJSONObject;
  if JsonObj = nil then begin
    Result := T.Create;
    Exit;
  end;

  try
    Result := JsonToObject<T>(JsonObj);
  finally
    JsonObj.Free;
  end;
end;

procedure TPscStateModel.Save;
var
  FilePath: String;
begin
  FilePath := GetStatePath;
  TFile.WriteAllText(FilePath, ToJson);
  TPscLogger.Log('State model saved to: ' + FilePath, 'Save', TLogger.Info, 'TPscStateModel');
end;

class function TPscStateModel.Load<T>: T;
var
  FilePath: String;
  JsonContent: String;
begin
  FilePath := GetStatePath;
  if not TFile.Exists(FilePath) then begin
    TPscLogger.Log('No state file found, creating new: ' + FilePath, 'Load', TLogger.Info, 'TPscStateModel');
    Result := T.Create;
    Exit;
  end;

  try
    JsonContent := TFile.ReadAllText(FilePath);
    Result := FromJson<T>(JsonContent);
    TPscLogger.Log('State model loaded from: ' + FilePath, 'Load', TLogger.Info, 'TPscStateModel');
  except
    on E: Exception do begin
      TPscLogger.Log('Failed to load state model: ' + E.Message, 'Load', TLogger.Error, 'TPscStateModel');
      Result := T.Create;
    end;
  end;
end;

end.
