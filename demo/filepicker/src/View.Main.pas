unit View.Main;

interface

uses
  System.SysUtils,
  System.Classes,
  System.IOUtils,
  Pisces;

type

  [ ImageView('img'),
    ForegroundRippleColor(233, 233, 236, 0.5),
    BackgroundColor(173, 156, 158),
    CornerRadius(30),
    ScaleType(TImageScaleType.CenterCrop)
  ] TImage = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
    procedure OnLongClickHandler(AView: JView); override;
  end;

  [ TextView('title'),
    Text('Long-click the view'),
    TextColor(233, 233, 230),
    Gravity([TGravity.Left, TGravity.Bottom]),
    Clickable(False),
    Focusable(False),
    FontStyle(TFontStyle.Bold),
    FontFamily('sans-serif'),
    FontWeight(700),
    TextSize(14),
    CornerRadius(30),
    ShadowLayer(10, 5, 5, 0, 0, 0, 0.6),
    Padding(0, 8, 30, 30)
  ] TDescription = class(TPisces)
  end;

  [ FrameLayout('picker-overlay'),
    CornerRadius(30)
  ] TPickerOverlay = class(TPisces)
    Image: TImage;
    Description: TDescription;
  end;

  TPickerItemLayout = class(TPisces)
    PickerDemo: TPickerOverlay;
    procedure SetCaption(const ACaption: String);
    procedure DoClickAction; virtual;
    procedure DoPickerAction; virtual; abstract;
  end;

  { ========== URI PICKERS ========== }

  [ FrameLayout('picker-image'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TImagePicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-video'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TVideoPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-audio'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TAudioPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoClickAction; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-document'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TDocumentPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-custom'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TCustomFilePicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  { ========== STREAM PICKERS ========== }

  [ FrameLayout('picker-image-stream'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TImageStreamPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-video-stream'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TVideoStreamPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-audio-stream'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TAudioStreamPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoClickAction; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-document-stream'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TDocumentStreamPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-custom-stream'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TCustomStreamPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  { ========== MEDIA PICKERS ========== }

  [ FrameLayout('picker-camera'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TCameraPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-video-capture'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TVideoCapturePicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-share-text'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TShareTextPicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-share-image'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TShareImagePicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  [ FrameLayout('picker-share-file'),
    Padding(60, 15, 60, 15),
    HeightPercent(0.18),
    ClipChildren(True)
  ] TShareFilePicker = class(TPickerItemLayout)
    procedure AfterShow; override;
    procedure DoPickerAction; override;
  end;

  { ========== LAYOUT ========== }

  [ LinearLayout('layout'),
    Orientation(TOrientation.Vertical),
    Padding(0, 200, 0, 50)
  ] TScrowLayout = class(TPisces)
    ImagePicker: TImagePicker;
    VideoPicker: TVideoPicker;
    AudioPicker: TAudioPicker;
    DocumentPicker: TDocumentPicker;
    CustomFilePicker: TCustomFilePicker;
    ImageStreamPicker: TImageStreamPicker;
    VideoStreamPicker: TVideoStreamPicker;
    AudioStreamPicker: TAudioStreamPicker;
    DocumentStreamPicker: TDocumentStreamPicker;
    CustomStreamPicker: TCustomStreamPicker;
    { Media }
    CameraPicker: TCameraPicker;
    VideoCapturePicker: TVideoCapturePicker;
    ShareTextPicker: TShareTextPicker;
    ShareImagePicker: TShareImagePicker;
    ShareFilePicker: TShareFilePicker;
  end;

  [ ScrollView('scrow'),
    FillViewport(True),
    BackgroundColor(250, 225, 229),
    DarkStatusBarIcons(True),
    FullScreen(True)
  ] THomeView = class(TPisces)
    ScrowLayout: TScrowLayout;
  end;

var
  HomeView: THomeView;

implementation

uses
  Androidapi.Helpers,
  Androidapi.JNIBridge;

{ TImage }

procedure TImage.OnClickHandler(AView: JView);
var
  Picker: TPickerItemLayout;
begin
  inherited;
  if (Parent <> nil) and (Parent.Parent <> nil) and (Parent.Parent is TPickerItemLayout) then
  begin
    Picker := TPickerItemLayout(Parent.Parent);
    Picker.DoClickAction;
  end;
end;

procedure TImage.OnLongClickHandler(AView: JView);
var
  Picker: TPickerItemLayout;
begin
  inherited;
  if (Parent <> nil) and (Parent.Parent <> nil) and (Parent.Parent is TPickerItemLayout) then
  begin
    Picker := TPickerItemLayout(Parent.Parent);
    Picker.DoPickerAction;
  end;
end;

{ TPickerItemLayout }

procedure TPickerItemLayout.SetCaption(const ACaption: String);
begin
  JTextView(PickerDemo.Description.AndroidView).setText(StrToJCharSequence(ACaption));
end;

procedure TPickerItemLayout.DoClickAction;
begin
  // Base implementation does nothing
end;

{ ========== URI PICKERS ========== }

{ TImagePicker }

procedure TImagePicker.AfterShow;
begin
  SetCaption('Pick Image (Uri)');
  inherited;
end;

procedure TImagePicker.DoPickerAction;
var
  Picker: TImagePicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickImage(
    procedure(Uri: Jnet_Uri)
    var
      Bitmap: JBitmap;
    begin
      if Uri <> nil then
      begin
        Bitmap := TPscUtils.LoadBitmap(Uri);
        if Bitmap <> nil then
        begin
          JImageView(Picker.PickerDemo.Image.AndroidView).setImageBitmap(Bitmap);
          TPscUtils.SetRoundedCorners(Picker.PickerDemo.Image.AndroidView, 30);
          Picker.SetCaption('Image loaded');
        end;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TVideoPicker }

procedure TVideoPicker.AfterShow;
begin
  SetCaption('Pick Video (Uri)');
  inherited;
end;

procedure TVideoPicker.DoPickerAction;
var
  Picker: TVideoPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickVideo(
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        Picker.SetCaption('Playing video...');
        TPscUtils.Intent.ActionPlayMedia(JStringToString(Uri.toString));
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TAudioPicker }

procedure TAudioPicker.AfterShow;
begin
  SetCaption('Pick Audio (Uri)');
  inherited;
end;

procedure TAudioPicker.DoClickAction;
begin
  TPscUtils.Music.Pause('picked_audio');
  SetCaption('Paused');
end;

procedure TAudioPicker.DoPickerAction;
var
  Picker: TAudioPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickAudio(
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        TPscUtils.Music.LoadUri('picked_audio', JStringToString(Uri.toString));
        TPscUtils.Music.Play('picked_audio');
        Picker.SetCaption('Playing audio...');
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TDocumentPicker }

procedure TDocumentPicker.AfterShow;
begin
  SetCaption('Pick Document (Uri)');
  inherited;
end;

procedure TDocumentPicker.DoPickerAction;
var
  Picker: TDocumentPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickDocument(
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        Picker.SetCaption('Doc: ' + JStringToString(Uri.getLastPathSegment));
        TPscUtils.Toast('Uri: ' + JStringToString(Uri.toString), 1);
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TCustomFilePicker }

procedure TCustomFilePicker.AfterShow;
begin
  SetCaption('Pick Any File (*/*)');
  inherited;
end;

procedure TCustomFilePicker.DoPickerAction;
var
  Picker: TCustomFilePicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickFile('*/*',
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        Picker.SetCaption('File: ' + JStringToString(Uri.getLastPathSegment));
        TPscUtils.Toast('Uri: ' + JStringToString(Uri.toString), 1);
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ ========== STREAM PICKERS ========== }

{ TImageStreamPicker }

procedure TImageStreamPicker.AfterShow;
begin
  SetCaption('Pick Image (Stream)');
  inherited;
end;

procedure TImageStreamPicker.DoPickerAction;
var
  Picker: TImageStreamPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickImageAsStream(
    procedure(Stream: TMemoryStream)
    var
      JavaBytes: TJavaArray<Byte>;
      Bitmap: JBitmap;
      I: Integer;
    begin
      if Stream <> nil then
      try
        Picker.SetCaption('Stream: ' + IntToStr(Stream.Size) + ' bytes');
        JavaBytes := TJavaArray<Byte>.Create(Stream.Size);
        try
          Stream.Position := 0;
          for I := 0 to Stream.Size - 1 do
            JavaBytes.Items[I] := PByte(NativeInt(Stream.Memory) + I)^;
          Bitmap := TJBitmapFactory.JavaClass.decodeByteArray(JavaBytes, 0, Stream.Size);
          if Bitmap <> nil then begin
            JImageView(Picker.PickerDemo.Image.AndroidView).setImageBitmap(Bitmap);
            TPscUtils.SetRoundedCorners(Picker.PickerDemo.Image.AndroidView, 30);
          end;
        finally
          JavaBytes.Free;
        end;
      finally
        Stream.Free;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TVideoStreamPicker }

procedure TVideoStreamPicker.AfterShow;
begin
  SetCaption('Pick Video (Stream)');
  inherited;
end;

procedure TVideoStreamPicker.DoPickerAction;
var
  Picker: TVideoStreamPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickVideoAsStream(
    procedure(Stream: TMemoryStream) begin
      if Stream <> nil then
      try
        Picker.SetCaption('Video: ' + IntToStr(Stream.Size) + ' bytes');
        TPscUtils.Toast('Video stream: ' + IntToStr(Stream.Size) + ' bytes', 1);
      finally
        Stream.Free;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TAudioStreamPicker }

procedure TAudioStreamPicker.AfterShow;
begin
  SetCaption('Pick Audio (Stream)');
  inherited;
end;

procedure TAudioStreamPicker.DoClickAction;
begin
  TPscUtils.Music.Pause('picked_audio_stream');
  SetCaption('Paused');
end;

procedure TAudioStreamPicker.DoPickerAction;
var
  Picker: TAudioStreamPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickAudioAsStream(
    procedure(Stream: TMemoryStream)
    var
      TempFile: String;
    begin
      if Stream <> nil then
      try
        TempFile := TPath.Combine(TPath.GetTempPath, 'picked_audio.tmp');
        // Stop previous playback and delete old temp file
        TPscUtils.Music.Stop('picked_audio_stream');
        if TFile.Exists(TempFile) then
          TFile.Delete(TempFile);
        // Save and play new file
        Stream.SaveToFile(TempFile);
        Picker.SetCaption('Playing (' + IntToStr(Stream.Size) + ' bytes)');
        TPscUtils.Music.LoadFile('picked_audio_stream', TempFile);
        TPscUtils.Music.Play('picked_audio_stream');
      finally
        Stream.Free;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TDocumentStreamPicker }

procedure TDocumentStreamPicker.AfterShow;
begin
  SetCaption('Pick Document (Stream)');
  inherited;
end;

procedure TDocumentStreamPicker.DoPickerAction;
var
  Picker: TDocumentStreamPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickDocumentAsStream(
    procedure(Stream: TMemoryStream) begin
      if Stream <> nil then
      try
        Picker.SetCaption('Doc: ' + IntToStr(Stream.Size) + ' bytes');
        TPscUtils.Toast('Doc stream: ' + IntToStr(Stream.Size) + ' bytes', 1);
      finally
        Stream.Free;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TCustomStreamPicker }

procedure TCustomStreamPicker.AfterShow;
begin
  SetCaption('Pick Any File (Stream)');
  inherited;
end;

procedure TCustomStreamPicker.DoPickerAction;
var
  Picker: TCustomStreamPicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickFileAsStream('*/*',
    procedure(Stream: TMemoryStream) begin
      if Stream <> nil then
      try
        Picker.SetCaption('File: ' + IntToStr(Stream.Size) + ' bytes');
        TPscUtils.Toast('File stream: ' + IntToStr(Stream.Size) + ' bytes', 1);
      finally
        Stream.Free;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ ========== MEDIA PICKERS ========== }

{ TCameraPicker }

procedure TCameraPicker.AfterShow;
begin
  SetCaption('Take Photo (Camera)');
  inherited;
end;

procedure TCameraPicker.DoPickerAction;
var
  Picker: TCameraPicker;
begin
  Picker := Self;
  TPscUtils.Media.TakePhoto(
    procedure(Uri: Jnet_Uri)
    var
      Bitmap: JBitmap;
    begin
      if Uri <> nil then
      begin
        Bitmap := TPscUtils.LoadBitmap(Uri);
        if Bitmap <> nil then
        begin
          JImageView(Picker.PickerDemo.Image.AndroidView).setImageBitmap(Bitmap);
          TPscUtils.SetRoundedCorners(Picker.PickerDemo.Image.AndroidView, 30);
          Picker.SetCaption('Photo captured');
        end;
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TVideoCapturePicker }

procedure TVideoCapturePicker.AfterShow;
begin
  SetCaption('Record Video (Camera)');
  inherited;
end;

procedure TVideoCapturePicker.DoPickerAction;
var
  Picker: TVideoCapturePicker;
begin
  Picker := Self;
  TPscUtils.Media.TakeVideo(
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        Picker.SetCaption('Playing video...');
        TPscUtils.Intent.ActionPlayMedia(JStringToString(Uri.toString));
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TShareTextPicker }

procedure TShareTextPicker.AfterShow;
begin
  SetCaption('Share Text');
  inherited;
end;

procedure TShareTextPicker.DoPickerAction;
begin
  TPscUtils.Media.ShareText('Hello from Pisces Framework!', 'Share');
  SetCaption('Sharing...');
end;

{ TShareImagePicker }

procedure TShareImagePicker.AfterShow;
begin
  SetCaption('Pick & Share Image');
  inherited;
end;

procedure TShareImagePicker.DoPickerAction;
var
  Picker: TShareImagePicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickImage(
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        Picker.SetCaption('Sharing...');
        TPscUtils.Media.ShareImage(Uri, 'Share Image');
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

{ TShareFilePicker }

procedure TShareFilePicker.AfterShow;
begin
  SetCaption('Pick & Share File');
  inherited;
end;

procedure TShareFilePicker.DoPickerAction;
var
  Picker: TShareFilePicker;
begin
  Picker := Self;
  TPscUtils.Picker.PickFile('*/*',
    procedure(Uri: Jnet_Uri)
    begin
      if Uri <> nil then
      begin
        Picker.SetCaption('Sharing...');
        TPscUtils.Media.ShareFile(Uri, '*/*', 'Share File');
      end;
    end,
    procedure
    begin
      Picker.SetCaption('Cancelled');
    end);
end;

initialization
  HomeView := THomeView.Create;
  HomeView.Show;

finalization
  HomeView.Free;

end.
