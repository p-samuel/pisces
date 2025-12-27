unit Pisces.State;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  System.Rtti,
  System.JSON,
  System.IOUtils;

type
  /// <summary>
  /// Singleton state management with JSON persistence.
  /// All state (local and global) maps to the same data store.
  /// </summary>
  TPscState = class
  private
    class var FInstance: TPscState;
    class var FData: TDictionary<String, TValue>;
    class var FStatePath: String;
    class constructor Create;
    class destructor Destroy;
    class function ValueToJson(const Value: TValue): TJSONValue;
    class function JsonToValue(const JsonVal: TJSONValue): TValue;
  public
    class function Instance: TPscState;
    // Instance methods (convenience accessors to singleton)
    function Get<T>(const Key: String): T; overload;
    function Get<T>(const Key: String; const Default: T): T; overload;
    function Put(const Key: String; const Value: TValue): TPscState; overload;
    function Put(const Key: String; const Value: String): TPscState; overload;
    function Put(const Key: String; const Value: Integer): TPscState; overload;
    function Put(const Key: String; const Value: Boolean): TPscState; overload;
    function Put(const Key: String; const Value: Double): TPscState; overload;
    function Has(const Key: String): Boolean;
    procedure Remove(const Key: String);
    procedure Clear;

    // Class methods (direct singleton access)
    class function GetValue<T>(const Key: String): T; overload;
    class function GetValue<T>(const Key: String; const Default: T): T; overload;
    class procedure SetValue(const Key: String; const Value: TValue); overload;
    class procedure SetValue(const Key: String; const Value: String); overload;
    class procedure SetValue(const Key: String; const Value: Integer); overload;
    class procedure SetValue(const Key: String; const Value: Boolean); overload;
    class procedure SetValue(const Key: String; const Value: Double); overload;
    class function HasKey(const Key: String): Boolean;
    class procedure RemoveKey(const Key: String);
    class procedure ClearAll;

    // JSON persistence
    class procedure SetStatePath(const APath: String);
    class function GetStatePath: String;
    class procedure Save;
    class procedure Load;
  end;

implementation

uses
  System.TypInfo,
  Pisces.Logger,
  Pisces.Types;

{ TPscState }

class constructor TPscState.Create;
begin
  FData := TDictionary<String, TValue>.Create;
  FStatePath := '';
  FInstance := TPscState.Create;
end;

class destructor TPscState.Destroy;
begin
  FInstance.Free;
  FData.Free;
end;

class function TPscState.Instance: TPscState;
begin
  Result := FInstance;
end;

// Instance methods - delegate to class methods

function TPscState.Get<T>(const Key: String): T;
begin
  Result := GetValue<T>(Key);
end;

function TPscState.Get<T>(const Key: String; const Default: T): T;
begin
  Result := GetValue<T>(Key, Default);
end;

function TPscState.Put(const Key: String; const Value: TValue): TPscState;
begin
  SetValue(Key, Value);
  Result := Self;
end;

function TPscState.Put(const Key: String; const Value: String): TPscState;
begin
  SetValue(Key, Value);
  Result := Self;
end;

function TPscState.Put(const Key: String; const Value: Integer): TPscState;
begin
  SetValue(Key, Value);
  Result := Self;
end;

function TPscState.Put(const Key: String; const Value: Boolean): TPscState;
begin
  SetValue(Key, Value);
  Result := Self;
end;

function TPscState.Put(const Key: String; const Value: Double): TPscState;
begin
  SetValue(Key, Value);
  Result := Self;
end;

function TPscState.Has(const Key: String): Boolean;
begin
  Result := HasKey(Key);
end;

procedure TPscState.Remove(const Key: String);
begin
  RemoveKey(Key);
end;

procedure TPscState.Clear;
begin
  ClearAll;
end;

// Class methods - actual implementation

class function TPscState.GetValue<T>(const Key: String): T;
var
  Value: TValue;
  TypeInfo: PTypeInfo;
begin
  TPscLogger.Log('GetValue<T> key=' + Key, 'GetValue', TLogger.Info, 'TPscState');
  if FData.TryGetValue(Key, Value) then begin
    TypeInfo := System.TypeInfo(T);
    TPscLogger.Log('Found key, TypeInfo.Kind=' + IntToStr(Ord(TypeInfo^.Kind)) + ', Value.Kind=' + IntToStr(Ord(Value.Kind)), 'GetValue', TLogger.Info, 'TPscState');

    // Handle numeric type conversions (JSON stores all numbers as Double)
    if (TypeInfo^.Kind = tkInteger) and (Value.Kind = tkFloat) then begin
      TPscLogger.Log('Converting Float to Integer', 'GetValue', TLogger.Info, 'TPscState');
      Exit(TValue.From<Integer>(Trunc(Value.AsExtended)).AsType<T>);
    end
    else if (TypeInfo^.Kind = tkInt64) and (Value.Kind = tkFloat) then begin
      TPscLogger.Log('Converting Float to Int64', 'GetValue', TLogger.Info, 'TPscState');
      Exit(TValue.From<Int64>(Trunc(Value.AsExtended)).AsType<T>);
    end
    else begin
      TPscLogger.Log('Direct AsType conversion', 'GetValue', TLogger.Info, 'TPscState');
      Exit(Value.AsType<T>);
    end;
  end;
  raise Exception.CreateFmt('State key not found: %s', [Key]);
end;

class function TPscState.GetValue<T>(const Key: String; const Default: T): T;
var
  Value: TValue;
  TypeInfo: PTypeInfo;
begin
  TPscLogger.Log('GetValue<T> with default, key=' + Key, 'GetValue', TLogger.Info, 'TPscState');
  if FData.TryGetValue(Key, Value) then begin
    TypeInfo := System.TypeInfo(T);
    TPscLogger.Log('Found key, TypeInfo.Kind=' + IntToStr(Ord(TypeInfo^.Kind)) + ', Value.Kind=' + IntToStr(Ord(Value.Kind)), 'GetValue', TLogger.Info, 'TPscState');

    // Handle numeric type conversions (JSON stores all numbers as Double)
    if (TypeInfo^.Kind = tkInteger) and (Value.Kind = tkFloat) then begin
      TPscLogger.Log('Converting Float to Integer', 'GetValue', TLogger.Info, 'TPscState');
      Exit(TValue.From<Integer>(Trunc(Value.AsExtended)).AsType<T>);
    end
    else if (TypeInfo^.Kind = tkInt64) and (Value.Kind = tkFloat) then begin
      TPscLogger.Log('Converting Float to Int64', 'GetValue', TLogger.Info, 'TPscState');
      Exit(TValue.From<Int64>(Trunc(Value.AsExtended)).AsType<T>);
    end
    else begin
      TPscLogger.Log('Direct AsType conversion', 'GetValue', TLogger.Info, 'TPscState');
      Exit(Value.AsType<T>);
    end;
  end;
  TPscLogger.Log('Key not found, returning default', 'GetValue', TLogger.Info, 'TPscState');
  Result := Default;
end;

class procedure TPscState.SetValue(const Key: String; const Value: TValue);
begin
  FData.AddOrSetValue(Key, Value);
end;

class procedure TPscState.SetValue(const Key: String; const Value: String);
begin
  SetValue(Key, TValue.From<String>(Value));
end;

class procedure TPscState.SetValue(const Key: String; const Value: Integer);
begin
  SetValue(Key, TValue.From<Integer>(Value));
end;

class procedure TPscState.SetValue(const Key: String; const Value: Boolean);
begin
  SetValue(Key, TValue.From<Boolean>(Value));
end;

class procedure TPscState.SetValue(const Key: String; const Value: Double);
begin
  SetValue(Key, TValue.From<Double>(Value));
end;

class function TPscState.HasKey(const Key: String): Boolean;
begin
  Result := FData.ContainsKey(Key);
end;

class procedure TPscState.RemoveKey(const Key: String);
begin
  FData.Remove(Key);
end;

class procedure TPscState.ClearAll;
begin
  FData.Clear;
end;

class procedure TPscState.SetStatePath(const APath: String);
begin
  FStatePath := APath;
end;

class function TPscState.GetStatePath: String;
begin
  if FStatePath <> '' then
    Result := FStatePath
  else
    Result := TPath.Combine(TPath.GetDocumentsPath, 'state.json');
end;

class function TPscState.ValueToJson(const Value: TValue): TJSONValue;
begin
  case Value.Kind of
    tkInteger:
      Result := TJSONNumber.Create(Value.AsInteger);
    tkInt64:
      Result := TJSONNumber.Create(Value.AsInt64);
    tkFloat:
      Result := TJSONNumber.Create(Value.AsExtended);
    tkString, tkLString, tkWString, tkUString:
      Result := TJSONString.Create(Value.AsString);
    tkEnumeration:
      if Value.TypeInfo = TypeInfo(Boolean) then
        Result := TJSONBool.Create(Value.AsBoolean)
      else
        Result := TJSONNumber.Create(Value.AsOrdinal);
  else
    Result := TJSONNull.Create;
  end;
end;

class function TPscState.JsonToValue(const JsonVal: TJSONValue): TValue;
begin
  // Check TJSONNumber BEFORE TJSONString (TJSONNumber inherits from TJSONString in some versions)
  if JsonVal is TJSONNumber then
    Result := TValue.From<Double>(TJSONNumber(JsonVal).AsDouble)
  else if JsonVal is TJSONTrue then
    Result := TValue.From<Boolean>(True)
  else if JsonVal is TJSONFalse then
    Result := TValue.From<Boolean>(False)
  else if JsonVal is TJSONString then
    Result := TValue.From<String>(TJSONString(JsonVal).Value)
  else
    Result := TValue.Empty;
end;

class procedure TPscState.Save;
var
  JsonObj: TJSONObject;
  Pair: TPair<String, TValue>;
  FilePath: String;
begin
  JsonObj := TJSONObject.Create;
  try
    for Pair in FData do begin
      if not Pair.Value.IsObject then
        JsonObj.AddPair(Pair.Key, ValueToJson(Pair.Value));
    end;

    FilePath := GetStatePath;
    TFile.WriteAllText(FilePath, JsonObj.ToJSON);
    TPscLogger.Log('State saved to: ' + FilePath, 'Save', TLogger.Info, 'TPscState');
  finally
    JsonObj.Free;
  end;
end;

class procedure TPscState.Load;
var
  JsonObj: TJSONObject;
  Pair: TJSONPair;
  FilePath: String;
  JsonContent: String;
  LoadedValue: TValue;
begin
  TPscLogger.Log('Load called', 'Load', TLogger.Info, 'TPscState');
  FilePath := GetStatePath;
  if not TFile.Exists(FilePath) then begin
    TPscLogger.Log('No state file found: ' + FilePath, 'Load', TLogger.Info, 'TPscState');
    Exit;
  end;

  try
    JsonContent := TFile.ReadAllText(FilePath);
    TPscLogger.Log('JSON content: ' + JsonContent, 'Load', TLogger.Info, 'TPscState');
    JsonObj := TJSONObject.ParseJSONValue(JsonContent) as TJSONObject;
    if JsonObj = nil then begin
      TPscLogger.Log('Failed to parse JSON', 'Load', TLogger.Error, 'TPscState');
      Exit;
    end;

    try
      for Pair in JsonObj do begin
        TPscLogger.Log('Loading key: ' + Pair.JsonString.Value + ', JsonValue type: ' + Pair.JsonValue.ClassName, 'Load', TLogger.Info, 'TPscState');
        LoadedValue := JsonToValue(Pair.JsonValue);
        TPscLogger.Log('Converted to TValue, Kind=' + IntToStr(Ord(LoadedValue.Kind)), 'Load', TLogger.Info, 'TPscState');
        FData.AddOrSetValue(Pair.JsonString.Value, LoadedValue);
      end;

      TPscLogger.Log('State loaded from: ' + FilePath, 'Load', TLogger.Info, 'TPscState');
    finally
      JsonObj.Free;
    end;
  except
    on E: Exception do
      TPscLogger.Log('Failed to load state: ' + E.Message, 'Load', TLogger.Error, 'TPscState');
  end;
end;

end.
