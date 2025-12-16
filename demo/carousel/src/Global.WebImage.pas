unit Global.WebImage;

interface

uses
  Pisces, System.Classes, System.SysUtils, Androidapi.JNIBridge, Androidapi.Helpers;

type
  TStatusUpdateProc = reference to procedure(const StatusText: string);
  TBitmapSetProc = reference to procedure(const Bitmap: JBitmap);

  TImageLoader = class
  private
    FImageUrl: string;
    FIsDestroyed: Boolean;
    FUpdateStatus: TStatusUpdateProc;
    FSafeSetBitmap: TBitmapSetProc;
    FComponentName: string;
  public
    constructor Create(const UpdateStatusProc: TStatusUpdateProc; const SafeSetBitmapProc: TBitmapSetProc; const ComponentName: string);
    procedure LoadImageFromUrl(const Url: string);
    destructor Destroy; override;
    property ImageUrl: String read FImageUrl write FImageUrl;
    property IsDestroyed: Boolean read FIsDestroyed write FIsDestroyed;
    property ComponentName: string read FComponentName write FComponentName;
  end;

  TBaseWebImage = class(TPisces)
  private
    FImageLoader: TImageLoader;
    FImageUrl: string;
    FIsDestroyed: Boolean;
    procedure UpdateStatus(const StatusText: string);
    procedure SafeSetBitmap(const Bitmap: JBitmap);
  public
    procedure AfterShow; override;
    procedure LoadImageFromUrl(const Url: string);
    destructor Destroy; override;
  end;

implementation

uses
  System.Threading, System.Net.HttpClient;

{ TImageLoader }

constructor TImageLoader.Create(const UpdateStatusProc: TStatusUpdateProc; const SafeSetBitmapProc: TBitmapSetProc; const ComponentName: string);
begin
  FSafeSetBitmap := SafeSetBitmapProc;
  FUpdateStatus := UpdateStatusProc;
  FComponentName := ComponentName;
  FIsDestroyed := False;
end;

destructor TImageLoader.Destroy;
begin
  FIsDestroyed := True;
  inherited;
end;

procedure TImageLoader.LoadImageFromUrl(const Url: string);
begin
  if FIsDestroyed then
    Exit;

  FImageUrl := Url;
  TPscUtils.Log('Starting to load image: ' + Url + ' for ' + FComponentName, 'LoadImageFromUrl', TLogger.Info, Self);
  
  if Assigned(FUpdateStatus) then
    FUpdateStatus('Loading ' + FComponentName + '...');

  TTask.Run(
    procedure
    var
      HttpClient: THTTPClient;
      Response: IHTTPResponse;
      ImageStream: TMemoryStream;
      ImageBytes: TBytes;
      Bitmap: JBitmap;
      BitmapFactory: JBitmapFactoryClass;
      ByteArray: TJavaArray<Byte>;
    begin
      if FIsDestroyed then
        Exit;

      HttpClient := nil;
      ImageStream := nil;
      ByteArray := nil;

      try
        HttpClient := THTTPClient.Create;
        ImageStream := TMemoryStream.Create;

        try
          TPscUtils.Log('Downloading image for ' + FComponentName + '...', 'LoadImageFromUrl', TLogger.Info, nil);

          Response := HttpClient.Get(Url);
          if Response.StatusCode = 200 then
          begin
            ImageStream.CopyFrom(Response.ContentStream, 0);
            ImageStream.Position := 0;

            // Convert stream to byte array
            SetLength(ImageBytes, ImageStream.Size);
            ImageStream.ReadBuffer(ImageBytes[0], ImageStream.Size);

            TPscUtils.Log('Image downloaded for ' + FComponentName + ', size: ' + IntToStr(Length(ImageBytes)) + ' bytes', 'LoadImageFromUrl', TLogger.Info, nil);

            // Create bitmap on UI thread
            TThread.Synchronize(nil,
              procedure
              var
                I: Integer;
              begin
                if FIsDestroyed then
                  Exit;

                try
                  // Convert to Java byte array
                  ByteArray := TJavaArray<Byte>.Create(Length(ImageBytes));
                  try
                    for I := 0 to High(ImageBytes) do
                      ByteArray.Items[I] := ImageBytes[I];

                    // Create bitmap
                    BitmapFactory := TJBitmapFactory.JavaClass;
                    Bitmap := BitmapFactory.decodeByteArray(ByteArray, 0, Length(ImageBytes));

                    if Bitmap <> nil then
                    begin
                      TPscUtils.Log('Bitmap created successfully for ' + FComponentName, 'LoadImageFromUrl', TLogger.Info, nil);
                      if Assigned(FSafeSetBitmap) then
                        FSafeSetBitmap(Bitmap);
                    end
                    else
                    begin
                      TPscUtils.Log('Failed to decode bitmap from bytes for ' + FComponentName, 'LoadImageFromUrl', TLogger.Error, nil);
                      if Assigned(FUpdateStatus) then
                        FUpdateStatus('Failed to decode ' + FComponentName);
                    end;
                  finally
                    if ByteArray <> nil then
                      ByteArray.Free;
                  end;

                except
                  on E: Exception do
                  begin
                    TPscUtils.Log('Error creating bitmap for ' + FComponentName + ': ' + E.Message, 'LoadImageFromUrl', TLogger.Error, nil);
                    if Assigned(FUpdateStatus) then
                      FUpdateStatus('Error processing ' + FComponentName);
                  end;
                end;
              end);
          end
          else
          begin
            TPscUtils.Log('HTTP Error for ' + FComponentName + ': ' + IntToStr(Response.StatusCode), 'LoadImageFromUrl', TLogger.Error, nil);
            TThread.Synchronize(nil,
              procedure
              begin
                if not FIsDestroyed and Assigned(FUpdateStatus) then
                  FUpdateStatus('HTTP Error for ' + FComponentName + ': ' + IntToStr(Response.StatusCode));
              end);
          end;

        except
          on E: Exception do
          begin
            TPscUtils.Log('HTTP Exception for ' + FComponentName + ': ' + E.Message, 'LoadImageFromUrl', TLogger.Error, nil);
            TThread.Synchronize(nil,
              procedure
              begin
                if not FIsDestroyed and Assigned(FUpdateStatus) then
                  FUpdateStatus('Network error for ' + FComponentName + ': ' + E.Message);
              end);
          end;
        end;

      finally
        if ImageStream <> nil then
          ImageStream.Free;
        if HttpClient <> nil then
          HttpClient.Free;
      end;
    end);
end;

{ TBaseWebImage }

procedure TBaseWebImage.AfterShow;
begin
  inherited;

  FIsDestroyed := False;

  FImageLoader := TImageLoader.Create(

    procedure(const StatusText: string) begin
      UpdateStatus(StatusText);
    end,

    procedure(const Bitmap: JBitmap) begin
      SafeSetBitmap(Bitmap);
    end, 'WebImage'

  );

  LoadImageFromUrl('https://picsum.photos/250/200?random=' + Random(10).ToString);
end;

destructor TBaseWebImage.Destroy;
begin
  FIsDestroyed := True;

  if Assigned(FImageLoader) then
  begin
    FImageLoader.IsDestroyed := True;
    FImageLoader.Free;
  end;
  inherited;
end;

procedure TBaseWebImage.SafeSetBitmap(const Bitmap: JBitmap);
var
  ImageViewRef: JImageView;
begin
  if FIsDestroyed then
  begin
    TPscUtils.Log('View destroyed, skipping bitmap set', 'SafeSetBitmap', TLogger.Warning, Self);
    Exit;
  end;

  try
    ImageViewRef := JImageView(AndroidView);
    if (ImageViewRef <> nil) and (Bitmap <> nil) then
    begin
      ImageViewRef.setImageBitmap(Bitmap);
      TPscUtils.Log('Bitmap set successfully for WebImage', 'SafeSetBitmap', TLogger.Info, Self);
      UpdateStatus('Image loaded: WebImage');
    end
    else
    begin
      TPscUtils.Log('ImageView or Bitmap is nil for WebImage', 'SafeSetBitmap', TLogger.Error, Self);
      UpdateStatus('Failed to set image: WebImage');
    end;
  except
    on E: Exception do
    begin
      TPscUtils.Log('Error in SafeSetBitmap for WebImage: ' + E.Message, 'SafeSetBitmap', TLogger.Error, Self);
      UpdateStatus('Error setting image: WebImage');
    end;
  end;
end;

procedure TBaseWebImage.LoadImageFromUrl(const Url: string);
begin
  if FIsDestroyed or not Assigned(FImageLoader) then
    Exit;

  FImageUrl := Url;
  FImageLoader.LoadImageFromUrl(Url);
end;

procedure TBaseWebImage.UpdateStatus(const StatusText: string);
var
  StatusView: JView;
begin
  if FIsDestroyed then
    Exit;

  try
    // Find the status view by its name instead of using global reference
    StatusView := TPscUtils.FindViewByName('status');
    if Assigned(StatusView) then
    begin
      JTextView(StatusView).setText(StrToJCharSequence(StatusText));
      TPscUtils.Log('Status updated: ' + StatusText, 'UpdateStatus', TLogger.Info, Self);
    end
    else
      TPscUtils.Log('Status view not available: ' + StatusText, 'UpdateStatus', TLogger.Warning, Self);
  except
    on E: Exception do
      TPscUtils.Log('Error updating status: ' + E.Message, 'UpdateStatus', TLogger.Error, Self);
  end;
end;

end.
