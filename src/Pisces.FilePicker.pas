unit Pisces.FilePicker;

interface

uses
  System.SysUtils,
  System.Messaging,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Net, System.Classes;

type
  TPscFilePicker = class
  private
    // Callbacks for different result types
    class var FOnBitmapSuccess: TProc<JBitmap>;
    class var FOnUriSuccess: TProc<Jnet_Uri>;
    class var FOnCancel: TProc;
    class var FCurrentRequestCode: Integer;
    class var FCameraOutputUri: Jnet_Uri;

    class procedure HandleActivityResult(const Sender: TObject; const M: TMessage);
    class function LoadBitmapFromUri(const Uri: Jnet_Uri): JBitmap;
    class procedure StartPickerIntent(const MimeType: string; RequestCode: Integer);
  public
    // Image picking - returns JBitmap
    class procedure PickImage(const OnSuccess: TProc<JBitmap>; const OnCancel: TProc = nil);

    // Media picking - returns Uri for flexibility
    class procedure PickVideo(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickAudio(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickDocument(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);
    class procedure PickFile(const MimeType: string; const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);

    // Camera actions
    class procedure TakePhoto(const OnSuccess: TProc<JBitmap>; const OnCancel: TProc = nil);
    class procedure TakeVideo(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc = nil);

    // Sharing (no callbacks needed - fire and forget)
    class procedure ShareText(const Text: string; const Title: string = 'Share');
    class procedure ShareImage(const ImageUri: Jnet_Uri; const Title: string = 'Share Image');
    class procedure ShareImageBitmap(const Bitmap: JBitmap; const Title: string = 'Share Image');

    // Utility
    class function LoadBitmap(const Uri: Jnet_Uri): JBitmap;
    class function ReadFileToStream(const Uri: Jnet_Uri): TMemoryStream;
  end;

implementation

uses
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Os,
  Androidapi.JNI.Provider, Androidapi.JNIBridge;

const
  REQUEST_PICK_IMAGE    = 9001;
  REQUEST_PICK_VIDEO    = 9002;
  REQUEST_PICK_AUDIO    = 9003;
  REQUEST_PICK_DOCUMENT = 9004;
  REQUEST_PICK_FILE     = 9005;
  REQUEST_TAKE_PHOTO    = 9006;
  REQUEST_TAKE_VIDEO    = 9007;

{ Helper to start a content picker intent }
class procedure TPscFilePicker.StartPickerIntent(const MimeType: string; RequestCode: Integer);
var
  Intent: JIntent;
begin
  FCurrentRequestCode := RequestCode;

  // Subscribe to activity result message
  TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, HandleActivityResult);

  // Launch picker
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_GET_CONTENT);
  Intent.setType(StringToJString(MimeType));
  Intent.addCategory(TJIntent.JavaClass.CATEGORY_OPENABLE);
  TAndroidHelper.Activity.startActivityForResult(Intent, RequestCode);
end;

{ Image picking - returns decoded bitmap }
class procedure TPscFilePicker.PickImage(const OnSuccess: TProc<JBitmap>; const OnCancel: TProc);
begin
  FOnBitmapSuccess := OnSuccess;
  FOnUriSuccess := nil;
  FOnCancel := OnCancel;
  StartPickerIntent('image/*', REQUEST_PICK_IMAGE);
end;

{ Video picking - returns URI }
class procedure TPscFilePicker.PickVideo(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnBitmapSuccess := nil;
  FOnUriSuccess := OnSuccess;
  FOnCancel := OnCancel;
  StartPickerIntent('video/*', REQUEST_PICK_VIDEO);
end;

{ Audio picking - returns URI }
class procedure TPscFilePicker.PickAudio(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnBitmapSuccess := nil;
  FOnUriSuccess := OnSuccess;
  FOnCancel := OnCancel;
  StartPickerIntent('audio/*', REQUEST_PICK_AUDIO);
end;

{ Document picking - returns URI (PDFs, docs, etc.) }
class procedure TPscFilePicker.PickDocument(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnBitmapSuccess := nil;
  FOnUriSuccess := OnSuccess;
  FOnCancel := OnCancel;
  StartPickerIntent('application/*', REQUEST_PICK_DOCUMENT);
end;

{ Generic file picking with custom MIME type }
class procedure TPscFilePicker.PickFile(const MimeType: string; const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
begin
  FOnBitmapSuccess := nil;
  FOnUriSuccess := OnSuccess;
  FOnCancel := OnCancel;
  StartPickerIntent(MimeType, REQUEST_PICK_FILE);
end;

{ Take photo using camera - returns bitmap thumbnail }
class procedure TPscFilePicker.TakePhoto(const OnSuccess: TProc<JBitmap>; const OnCancel: TProc);
var
  Intent: JIntent;
begin
  FOnBitmapSuccess := OnSuccess;
  FOnUriSuccess := nil;
  FOnCancel := OnCancel;
  FCurrentRequestCode := REQUEST_TAKE_PHOTO;

  TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, HandleActivityResult);

  Intent := TJIntent.JavaClass.init(TJMediaStore.JavaClass.ACTION_IMAGE_CAPTURE);
  TAndroidHelper.Activity.startActivityForResult(Intent, REQUEST_TAKE_PHOTO);
end;

{ Take video using camera - returns URI }
class procedure TPscFilePicker.TakeVideo(const OnSuccess: TProc<Jnet_Uri>; const OnCancel: TProc);
var
  Intent: JIntent;
begin
  FOnBitmapSuccess := nil;
  FOnUriSuccess := OnSuccess;
  FOnCancel := OnCancel;
  FCurrentRequestCode := REQUEST_TAKE_VIDEO;

  TMessageManager.DefaultManager.SubscribeToMessage(TMessageResultNotification, HandleActivityResult);

  Intent := TJIntent.JavaClass.init(TJMediaStore.JavaClass.ACTION_VIDEO_CAPTURE);
  TAndroidHelper.Activity.startActivityForResult(Intent, REQUEST_TAKE_VIDEO);
end;

{ Share text via system share sheet }
class procedure TPscFilePicker.ShareText(const Text: string; const Title: string);
var
  Intent: JIntent;
  ChooserIntent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  Intent.setType(StringToJString('text/plain'));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Text));

  ChooserIntent := TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence(Title));
  TAndroidHelper.Activity.startActivity(ChooserIntent);
end;

{ Share image via system share sheet using URI }
class procedure TPscFilePicker.ShareImage(const ImageUri: Jnet_Uri; const Title: string);
var
  Intent: JIntent;
  ChooserIntent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  Intent.setType(StringToJString('image/*'));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, TJParcelable.Wrap((ImageUri as ILocalObject).GetObjectID));
  Intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);

  ChooserIntent := TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence(Title));
  TAndroidHelper.Activity.startActivity(ChooserIntent);
end;

{ Share bitmap image (saves to cache first, then shares) }
class procedure TPscFilePicker.ShareImageBitmap(const Bitmap: JBitmap; const Title: string);
var
  OutputStream: JFileOutputStream;
  CacheDir: JFile;
  ImageFile: JFile;
  ImageUri: Jnet_Uri;
  Intent: JIntent;
  ChooserIntent: JIntent;
begin
  if Bitmap = nil then
    Exit;

  try
    // Save bitmap to cache directory
    CacheDir := TAndroidHelper.Context.getCacheDir;
    ImageFile := TJFile.JavaClass.init(CacheDir, StringToJString('share_image_' + IntToStr(Random(99999)) + '.png'));

    OutputStream := TJFileOutputStream.JavaClass.init(ImageFile);
    try
      Bitmap.compress(TJBitmap_CompressFormat.JavaClass.PNG, 100, OutputStream);
    finally
      OutputStream.close;
    end;

    // Get content URI via FileProvider or direct file URI
    ImageUri := TJnet_Uri.JavaClass.fromFile(ImageFile);

    // Share using standard share
    Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
    Intent.setType(StringToJString('image/png'));
    Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, TJParcelable.Wrap((ImageUri as ILocalObject).GetObjectID));
    Intent.addFlags(TJIntent.JavaClass.FLAG_GRANT_READ_URI_PERMISSION);

    ChooserIntent := TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence(Title));
    TAndroidHelper.Activity.startActivity(ChooserIntent);
  except
    // Silently fail if sharing fails
  end;
end;

{ Handle activity results for all picker types }
class procedure TPscFilePicker.HandleActivityResult(const Sender: TObject; const M: TMessage);
var
  Msg: TMessageResultNotification;
  Uri: Jnet_Uri;
  Bitmap: JBitmap;
  Extras: JBundle;
begin
  Msg := TMessageResultNotification(M);

  // Check if this is our request
  if Msg.RequestCode <> FCurrentRequestCode then
    Exit;

  // Unsubscribe immediately to avoid duplicate handling
  TMessageManager.DefaultManager.Unsubscribe(TMessageResultNotification, HandleActivityResult);

  if Msg.ResultCode = TJActivity.JavaClass.RESULT_OK then
  begin
    case FCurrentRequestCode of
      REQUEST_PICK_IMAGE:
        begin
          if Msg.Value <> nil then
          begin
            Uri := Msg.Value.getData;
            if Uri <> nil then
            begin
              Bitmap := LoadBitmapFromUri(Uri);
              if Assigned(FOnBitmapSuccess) and (Bitmap <> nil) then
                FOnBitmapSuccess(Bitmap);
            end;
          end;
        end;

      REQUEST_PICK_VIDEO, REQUEST_PICK_AUDIO, REQUEST_PICK_DOCUMENT, REQUEST_PICK_FILE:
        begin
          if Msg.Value <> nil then
          begin
            Uri := Msg.Value.getData;
            if Assigned(FOnUriSuccess) and (Uri <> nil) then
              FOnUriSuccess(Uri);
          end;
        end;

      REQUEST_TAKE_PHOTO:
        begin
          // Camera returns thumbnail bitmap in extras
          if Msg.Value <> nil then
          begin
            Extras := Msg.Value.getExtras;
            if (Extras <> nil) and Extras.containsKey(StringToJString('data')) then
            begin
              Bitmap := TJBitmap.Wrap((Extras.get(StringToJString('data')) as ILocalObject).GetObjectID);
              if Assigned(FOnBitmapSuccess) and (Bitmap <> nil) then
                FOnBitmapSuccess(Bitmap);
            end;
          end;
        end;

      REQUEST_TAKE_VIDEO:
        begin
          if Msg.Value <> nil then
          begin
            Uri := Msg.Value.getData;
            if Assigned(FOnUriSuccess) and (Uri <> nil) then
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

  // Clear all callbacks
  FOnBitmapSuccess := nil;
  FOnUriSuccess := nil;
  FOnCancel := nil;
  FCameraOutputUri := nil;
end;

{ Load bitmap from URI - public utility }
class function TPscFilePicker.LoadBitmap(const Uri: Jnet_Uri): JBitmap;
begin
  Result := LoadBitmapFromUri(Uri);
end;

{ Internal bitmap loading from URI }
class function TPscFilePicker.LoadBitmapFromUri(const Uri: Jnet_Uri): JBitmap;
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

{ Read file content to memory stream - useful for documents }
class function TPscFilePicker.ReadFileToStream(const Uri: Jnet_Uri): TMemoryStream;
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
