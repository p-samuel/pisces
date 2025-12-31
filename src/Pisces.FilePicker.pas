unit Pisces.FilePicker;

interface

uses
  System.SysUtils,
  System.Classes,
  System.Messaging,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net;

type
  TPscFilePicker = class
  private
    class var FOnUriSuccess: TProc<Jnet_Uri>;
    class var FOnStreamSuccess: TProc<TMemoryStream>;
    class var FOnCancel: TProc;
    class var FCurrentRequestCode: Integer;
    class var FReturnStream: Boolean;

    class procedure HandleActivityResult(const Sender: TObject; const M: TMessage);
    class procedure StartPickerIntent(const MimeType: string; RequestCode: Integer);
  public
    // Pick methods - return Uri
    class procedure PickImage(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickVideo(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickAudio(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickDocument(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickFile(const MimeType: string; const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);

    // Pick methods - return Stream (raw bytes)
    class procedure PickImageAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc = nil);
    class procedure PickVideoAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc = nil);
    class procedure PickAudioAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc = nil);
    class procedure PickDocumentAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc = nil);
    class procedure PickFileAsStream(const MimeType: string; const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc = nil);

    // Converters
    class function UriToStream(const Uri: Jnet_Uri): TMemoryStream;
    class function UriToBitmap(const Uri: Jnet_Uri): JBitmap;
  end;

implementation

uses
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNIBridge;

const
  REQUEST_PICK_IMAGE    = 9001;
  REQUEST_PICK_VIDEO    = 9002;
  REQUEST_PICK_AUDIO    = 9003;
  REQUEST_PICK_DOCUMENT = 9004;
  REQUEST_PICK_FILE     = 9005;

{ Helper to start a content picker intent }
class procedure TPscFilePicker.StartPickerIntent(const MimeType: string; RequestCode: Integer);
var
  Intent: JIntent;
begin
  FCurrentRequestCode := RequestCode;

  TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, HandleActivityResult);

  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_GET_CONTENT);
  Intent.setType(StringToJString(MimeType));
  Intent.addCategory(TJIntent.JavaClass.CATEGORY_OPENABLE);
  TAndroidHelper.Activity.startActivityForResult(Intent, RequestCode);
end;

{ Pick Image - returns Uri }
class procedure TPscFilePicker.PickImage(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnUriSuccess := OnSuccess;
  FOnStreamSuccess := nil;
  FOnCancel := OnCancel;
  FReturnStream := False;
  StartPickerIntent('image/*', REQUEST_PICK_IMAGE);
end;

{ Pick Video - returns Uri }
class procedure TPscFilePicker.PickVideo(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnUriSuccess := OnSuccess;
  FOnStreamSuccess := nil;
  FOnCancel := OnCancel;
  FReturnStream := False;
  StartPickerIntent('video/*', REQUEST_PICK_VIDEO);
end;

{ Pick Audio - returns Uri }
class procedure TPscFilePicker.PickAudio(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnUriSuccess := OnSuccess;
  FOnStreamSuccess := nil;
  FOnCancel := OnCancel;
  FReturnStream := False;
  StartPickerIntent('audio/*', REQUEST_PICK_AUDIO);
end;

{ Pick Document - returns Uri }
class procedure TPscFilePicker.PickDocument(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnUriSuccess := OnSuccess;
  FOnStreamSuccess := nil;
  FOnCancel := OnCancel;
  FReturnStream := False;
  StartPickerIntent('application/*', REQUEST_PICK_DOCUMENT);
end;

{ Pick File with custom MIME type - returns Uri }
class procedure TPscFilePicker.PickFile(const MimeType: string; const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnUriSuccess := OnSuccess;
  FOnStreamSuccess := nil;
  FOnCancel := OnCancel;
  FReturnStream := False;
  StartPickerIntent(MimeType, REQUEST_PICK_FILE);
end;

{ Pick Image - returns Stream }
class procedure TPscFilePicker.PickImageAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc);
begin
  FOnUriSuccess := nil;
  FOnStreamSuccess := OnSuccess;
  FOnCancel := OnCancel;
  FReturnStream := True;
  StartPickerIntent('image/*', REQUEST_PICK_IMAGE);
end;

{ Pick Video - returns Stream }
class procedure TPscFilePicker.PickVideoAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc);
begin
  FOnUriSuccess := nil;
  FOnStreamSuccess := OnSuccess;
  FOnCancel := OnCancel;
  FReturnStream := True;
  StartPickerIntent('video/*', REQUEST_PICK_VIDEO);
end;

{ Pick Audio - returns Stream }
class procedure TPscFilePicker.PickAudioAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc);
begin
  FOnUriSuccess := nil;
  FOnStreamSuccess := OnSuccess;
  FOnCancel := OnCancel;
  FReturnStream := True;
  StartPickerIntent('audio/*', REQUEST_PICK_AUDIO);
end;

{ Pick Document - returns Stream }
class procedure TPscFilePicker.PickDocumentAsStream(const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc);
begin
  FOnUriSuccess := nil;
  FOnStreamSuccess := OnSuccess;
  FOnCancel := OnCancel;
  FReturnStream := True;
  StartPickerIntent('application/*', REQUEST_PICK_DOCUMENT);
end;

{ Pick File with custom MIME type - returns Stream }
class procedure TPscFilePicker.PickFileAsStream(const MimeType: string; const OnSuccess: TProc<TMemoryStream>; const OnCancel: TProc);
begin
  FOnUriSuccess := nil;
  FOnStreamSuccess := OnSuccess;
  FOnCancel := OnCancel;
  FReturnStream := True;
  StartPickerIntent(MimeType, REQUEST_PICK_FILE);
end;

{ Handle activity results }
class procedure TPscFilePicker.HandleActivityResult(const Sender: TObject; const M: TMessage);
var
  Msg: TMessageResultNotification;
  Uri: Jnet_Uri;
  Stream: TMemoryStream;
begin
  Msg := TMessageResultNotification(M);

  if Msg.RequestCode <> FCurrentRequestCode then
    Exit;

  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, HandleActivityResult);

  if Msg.ResultCode = TJActivity.JavaClass.RESULT_OK then
  begin
    if Msg.Value <> nil then
    begin
      Uri := Msg.Value.getData;
      if Uri <> nil then
      begin
        if FReturnStream then
        begin
          Stream := UriToStream(Uri);
          if Assigned(FOnStreamSuccess) and (Stream <> nil) then
            FOnStreamSuccess(Stream);
        end
        else
        begin
          if Assigned(FOnUriSuccess) then
            FOnUriSuccess(Uri);
        end;
      end;
    end;
  end
  else
  begin
    if Assigned(FOnCancel) then
      FOnCancel();
  end;

  FOnUriSuccess := nil;
  FOnStreamSuccess := nil;
  FOnCancel := nil;
end;

{ Convert Uri to Bitmap }
class function TPscFilePicker.UriToBitmap(const Uri: Jnet_Uri): JBitmap;
var
  ContentResolver: JContentResolver;
  InputStream: JInputStream;
begin
  Result := nil;
  try
    ContentResolver := TAndroidHelper.Context.getContentResolver;
    InputStream := ContentResolver.openInputStream(Uri);
    if InputStream <> nil then
    try
      Result := TJBitmapFactory.JavaClass.decodeStream(InputStream);
    finally
      InputStream.close;
    end;
  except
    Result := nil;
  end;
end;

{ Convert Uri to Stream }
class function TPscFilePicker.UriToStream(const Uri: Jnet_Uri): TMemoryStream;
var
  ContentResolver: JContentResolver;
  InputStream: JInputStream;
  Buffer: TJavaArray<Byte>;
  BytesRead: Integer;
  DelphiBuffer: TBytes;
  I: Integer;
begin
  Result := TMemoryStream.Create;
  try
    ContentResolver := TAndroidHelper.Context.getContentResolver;
    InputStream := ContentResolver.openInputStream(Uri);
    if InputStream <> nil then
    try
      Buffer := TJavaArray<Byte>.Create(8192);
      try
        BytesRead := InputStream.read(Buffer);
        while BytesRead > 0 do
        begin
          SetLength(DelphiBuffer, BytesRead);
          for I := 0 to BytesRead - 1 do
            DelphiBuffer[I] := Buffer.Items[I];
          Result.WriteBuffer(DelphiBuffer[0], BytesRead);
          BytesRead := InputStream.read(Buffer);
        end;
      finally
        Buffer.Free;
      end;
      Result.Position := 0;
    finally
      InputStream.close;
    end;
  except
    FreeAndNil(Result);
  end;
end;

end.
