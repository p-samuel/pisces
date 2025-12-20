unit Pisces.Utils;

interface

uses
  Androidapi.JNIBridge,
  System.Generics.Collections,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Widget,
  System.SysUtils,
  Pisces.Types, Pisces.Registry, Pisces.Audio, Pisces.View;

type

  TPscUtilsIntent = class
  public
    // Basic actions
    class procedure ActionView(Url: String);
    class procedure ActionSend(Text: String);
    class procedure ActionCall(PhoneNumber: String);
    class procedure ActionDial(PhoneNumber: String);

    // Media and map actions
    class procedure ActionCapturePhoto;
    class procedure ActionPlayMedia(MediaUri: String);
    class procedure ActionOpenMap(Latitude, Longitude: Double);

    // System settings and utility actions
    class procedure ActionOpenSettings;
    class procedure ActionSendEmail(EmailAddress, Subject, Body: String);
    class procedure ActionSendSMS(PhoneNumber, Message: String);

    // Sharing and file management
    class procedure ActionSendFile(FilePath: String; MimeType: String);
    class procedure ActionPickFile(MimeType: String);
    class procedure ActionViewFile(FilePath: String; MimeType: String);
    class procedure ActionShareImage(ImagePath: String);

    // Connectivity actions
    class procedure ActionEnableWifi;
    class procedure ActionDisableWifi;
    class procedure ActionEnableBluetooth;
    class procedure ActionDisableBluetooth;
    class procedure ActionOpenWifiSettings;
    class procedure ActionOpenBluetoothSettings;

  end;

  TAnimationCallback = procedure of object;

type
  TPscAnimate = class
  private
    class var FInstance: TPscAnimate;
    FFromView: JView;
    FAnimatorProperties: JViewPropertyAnimator;
    constructor Create; // Private constructor
  public
    class function Instance: TPscAnimate;
    class destructor Destroy;

    // Basic setup
    function FromView(AView: JView): TPscAnimate;

    // Transform animations
    function TranslateX(X1, X2: Single): TPscAnimate;
    function TranslateY(Y1, Y2: Single): TPscAnimate;
    function Alpha(StartAlpha, EndAlpha: Single): TPscAnimate;
    function ScaleX(StartScale, EndScale: Single): TPscAnimate;
    function ScaleY(StartScale, EndScale: Single): TPscAnimate;
    function Scale(StartScale, EndScale: Single): TPscAnimate;
    function RotationX(StartRotation, EndRotation: Single): TPscAnimate;
    function RotationY(StartRotation, EndRotation: Single): TPscAnimate;
    function Rotation(StartRotation, EndRotation: Single): TPscAnimate;

    // Animation properties
    function Duration(Milliseconds: Int64): TPscAnimate;
    function StartDelay(Milliseconds: Int64): TPscAnimate;
    function WithStartAction(AProc: TProc): TPscAnimate;
    function WithEndAction(AProc: TProc): TPscAnimate;
    function WithLayer: TPscAnimate;

    // Predefined animations
    function FadeIn(ADuration: Int64 = 300): TPscAnimate;
    function FadeOut(ADuration: Int64 = 300): TPscAnimate;
    function SlideInFromLeft(ADuration: Int64 = 300): TPscAnimate;
    function SlideInFromRight(ADuration: Int64 = 300): TPscAnimate;
    function SlideOutToLeft(ADuration: Int64 = 300): TPscAnimate;
    function SlideOutToRight(ADuration: Int64 = 300): TPscAnimate;
    function Pulse(ADuration: Int64 = 600): TPscAnimate;

    // Control
    procedure Run;
    procedure Cancel;
  end;

  TPscRunnable = class(TJavaLocal, JRunnable)
  private
    FView: JView;
    FProc: TProc<JView>;
  public
    constructor Create(AView: JView; AProc: TProc<JView>);
    procedure run; cdecl;
  end;

  TPscUtils = class
  public
    { View Registry & Lookup }
    class function FindObjectId(ObjectName: String): Integer;
    class function FindResourceId(ResourceName, Location: String): Integer;
    class function FindViewByName(const AName: string): JView;
    class function FindViewById(const AId: Integer): JView;
    class function FindViewByGUID(const AGUID: String): JView;
    class procedure RegisterView(const RegistrationInfo: TViewRegistrationInfo);

    { System UI & Status Bar }
    class function IsDarkMode: Boolean;
    class procedure EnableFullScreenOnView(View: JView);
    class procedure StatusBarColor(Color: Integer);
    class procedure StatusBarLightIcons(View: JView);
    class procedure StatusBarDarkIcons(View: JView);
    class procedure SetScreenOrientation(Orientation: TScreenOrientation);

    { Visual Effects & Styling }
    class procedure SetRoundedCorners(View: JView; CornerRadius: Single); overload;
    class procedure SetRoundedCorners(View: JView; CornerRadius: Single; BackgroundColor: Integer); overload;
    class procedure SetBackgroundWithRipple(View: JView; BackgroundColor: Integer; RippleColor: Integer; CornerRadius: Single); overload;
    class procedure SetBackgroundWithRipple(View: JView; ResourceDrawable: JDrawable; RippleColor: Integer; CornerRadius: Single); overload;
    class procedure SetForegroundRipple(View: JView; RippleColor: Integer; CornerRadius: Single);
    class procedure SetMultiGradientBackground(View: JView; const ColorStops: TColorStopArray; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
    class function ColorStop(Red, Green, Blue: Integer; Alpha: Double = 1.0; Position: Single = -1): TColorStop;
    class function GetDrawable(Resname, Location: String): JDrawable;

    { UI Components }
    class function PopupWindow: IPscPopupWindow;
    class function AlertDialog: IPscAlertDialog;
    class procedure ShowPopupWindow(Anchor: JView; ContentView: JView; AWidth, AHeight: Integer);
    class procedure Toast(Text: String; Duration: Integer);
    class function Animate: TPscAnimate;

    { Audio }
    class function Sound: TPscSound;
    class function Music: TPscMusic;

    { Intents & Actions }
    class function Intent: TPscUtilsIntent;

    { Utilities }
    class procedure Log(Msg, MethodName: String; LogType: TLogger; ClassInstance: TObject); overload;
    class procedure Log(Msg, MethodName: String; LogType: TLogger; ClassInstanceName: String); overload;
    class function GetPackageName: String;
    class function DateToMillis(Year, Month, Day: Integer): Int64;
    class function Runnable(AView: JView; AProc: TProc<JView>): TPscRunnable;
    class procedure SmoothScrollTo(View: JView; TargetX, TargetY: Integer; Duration: Integer = 1000);
    class procedure ConvertAttributesToDictionary(const Attributes: TArray<TCustomAttribute>; var Dict: TDictionary<String, TCustomAttribute>);
    class procedure HideKeyboard(View: JView);
  end;

implementation

uses
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Androidapi.JNI.Net,
  Androidapi.JNI.Provider,
  Androidapi.JNI.Bluetooth,
  Androidapi.JNI.Util,
  Androidapi.JNI.Os,
  System.Hash,
  Pisces.EventListeners,
  Pisces.Logger;

type
  TRoundedOutlineProvider = class(TJavaLocal, JViewOutlineProvider, JObject)
  private
    FCornerRadius: Single;
  public
    constructor Create(ACornerRadius: Single);
    procedure getOutline(view: JView; outline: JOutline); cdecl;
    function equals(obj: JObject): Boolean; cdecl;
    function getClass: Jlang_Class; cdecl;
    function hashCode: Integer; cdecl;
    procedure notify; cdecl;
    procedure notifyAll; cdecl;
    function toString: JString; cdecl;
    procedure wait(timeout: Int64); overload; cdecl;
    procedure wait(timeout: Int64; nanos: Integer); overload; cdecl;
    procedure wait; overload; cdecl;
  end;

{ TPiscesUtils }


class function TPscUtils.Animate: TPscAnimate;
begin
  Result := TPscAnimate.Instance;
end;

class function TPscUtils.ColorStop(Red, Green, Blue: Integer; Alpha: Double;Position: Single): TColorStop;
begin
  Result := TColorStop.Create(Red, Green, Blue, Alpha, Position);
end;

class procedure TPscUtils.ConvertAttributesToDictionary(
  const Attributes: TArray<TCustomAttribute>;
  var Dict: TDictionary<String, TCustomAttribute>);
var
  Attribute: TCustomAttribute;
  AttributeName: string;
begin
  try
    for Attribute in Attributes do
    begin
      AttributeName := Attribute.ClassName;
      if not Dict.ContainsKey(AttributeName) then
        Dict.Add(AttributeName, Attribute);
    end;
  except
    on E: Exception do
      raise Exception.Create('TPscUtils.ConvertAttributesToDictionary: ' + E.Message);
  end;
end;

class procedure TPscUtils.HideKeyboard(View: JView);
var
  InputMethodManager: JInputMethodManager;
begin
  if View = nil then Exit;

  InputMethodManager := TJInputMethodManager.Wrap(
    TAndroidHelper.Context.getSystemService(TJContext.JavaClass.INPUT_METHOD_SERVICE)
  );

  if InputMethodManager <> nil then
    InputMethodManager.hideSoftInputFromWindow(View.getWindowToken, 0);
end;

class function TPscUtils.DateToMillis(Year, Month, Day: Integer): Int64;
const
  MILLISECONDS_PER_DAY = Int64(24 * 60 * 60 * 1000);
  DAYS_FROM_1970_TO_2000 = 10957;
  DaysInMonth: array[1..12] of Integer = (31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31);
var
  TotalDays, M: Integer;
begin
  // Calculate days from year
  TotalDays := (Year - 1970) * 365;

  // Add leap years
  TotalDays := TotalDays + ((Year - 1969) div 4);

  // Add days from months
  for M := 1 to Month - 1 do
    TotalDays := TotalDays + DaysInMonth[M];

  // Add leap day if current year is leap and past February
  if (Month > 2) and ((Year mod 4 = 0) and ((Year mod 100 <> 0) or (Year mod 400 = 0))) then
    Inc(TotalDays);

  // Add days of current month
  TotalDays := TotalDays + Day;

  Result := Int64(TotalDays) * MILLISECONDS_PER_DAY;
end;

class procedure TPscUtils.EnableFullScreenOnView(View: JView);
begin
  View.setSystemUiVisibility(
    View.getSystemUiVisibility or
    TJView.JavaClass.SYSTEM_UI_FLAG_LAYOUT_STABLE or
    TJView.JavaClass.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION or
    TJView.JavaClass.SYSTEM_UI_FLAG_HIDE_NAVIGATION or
    TJView.JavaClass.SYSTEM_UI_FLAG_IMMERSIVE_STICKY
  );
end;

class function TPscUtils.FindObjectId(ObjectName: String): Integer;
begin
  Result := TAndroidHelper.Context.getResources.getIdentifier(
    StringToJString(ObjectName),
    StringToJString('id'),
    TAndroidHelper.Context.getPackageName);
end;

class function TPscUtils.FindResourceId(ResourceName, Location: String): Integer;
begin
  Result := TAndroidHelper.Context.getResources.getIdentifier(
    StringToJString(ResourceName),
    StringToJString(Location),
    TAndroidHelper.Context.getPackageName
  );
end;

class function TPscUtils.FindViewByGUID(const AGUID: String): JView;
begin
  TPscUtils.Log(Format('Finding view by GUID: %s', [AGUID]), 'FindViewByGUID', TLogger.Info, nil);
  if ViewsRegistry.ContainsKey(AGUID) then begin
    Result := ViewsRegistry[AGUID].View;
    TPscUtils.Log(Format('Found view with GUID: %s', [AGUID]), 'FindViewByGUID', TLogger.Info, nil);
  end else begin
    TPscUtils.Log(Format('View with GUID: %s not found', [AGUID]), 'FindViewByGUID', TLogger.Info, nil);
    Result := nil;
  end;
end;

class function TPscUtils.FindViewById(const AId: Integer): JView;
var
  Registration: TViewRegistrationInfo;
begin
  TPscUtils.Log(Format('Finding view by ID: %d', [AId]), 'FindViewById', TLogger.Info, nil);
  Result := nil;

  for Registration in ViewsRegistry.Values do begin
    TPscUtils.Log(Format('Checking view with ID: %d', [Registration.ViewID]), 'FindViewById', TLogger.Info, nil);
    if Registration.ViewID = AId then begin
      Result := Registration.View;
      TPscUtils.Log(Format('Found view with ID: %d', [Registration.ViewID]), 'FindViewById', TLogger.Info, nil);
      Break;
    end;
  end;

  if Result = nil then
    Result := TAndroidHelper.Activity.findViewById(AId);
end;

class function TPscUtils.FindViewByName(const AName: string): JView;
var
  Registration: TViewRegistrationInfo;
begin
  TPscUtils.Log(Format('Finding view by name: %s', [AName]), 'FindViewByName', TLogger.Info, nil);
  Result := nil;
  for Registration in ViewsRegistry.Values do begin
    TPscUtils.Log(Format('Checking view with name: %s', [Registration.ViewName]), 'FindViewByName', TLogger.Info, nil);
    if Registration.ViewName = AName then begin
      Result := Registration.View;
      TPscUtils.Log(Format('Found view with name: %s', [Registration.ViewName]), 'FindViewByName', TLogger.Info, nil);
      Break;
    end;
  end;
end;

class function TPscUtils.GetDrawable(Resname, Location: String): JDrawable;
begin
  Result := TAndroidHelper.Context.getResources.getDrawable(
    TAndroidHelper.Context.getResources.getIdentifier(StringToJString(Resname),
    StringToJString(Location), TAndroidHelper.Context.getPackageName), nil);
end;

class function TPscUtils.GetPackageName: String;
var
  PackageManager: JPackageManager;
  PackageInfo: JPackageInfo;
begin
  PackageManager := TAndroidHelper.Context.getPackageManager;
  PackageInfo := PackageManager.getPackageInfo(TAndroidHelper.Context.getPackageName, 0);
  Result := JStringToString(PackageInfo.packageName);
end;

class function TPscUtils.Intent: TPscUtilsIntent;
begin
  Result := TPscUtilsIntent.Create;
end;

class function TPscUtils.IsDarkMode: Boolean;
var
  Config: JConfiguration;
  nightModeFlags: Integer;
begin
  Config := TAndroidHelper.Context.getResources.getConfiguration;
  nightModeFlags := config.uiMode and TJConfiguration.JavaClass.UI_MODE_NIGHT_MASK;
  Result := (nightModeFlags = TJConfiguration.JavaClass.UI_MODE_NIGHT_YES);
end;

class procedure TPscUtils.Log(Msg, MethodName: String; LogType: TLogger; ClassInstanceName: String);
begin
  TPscLogger.Log(Msg, MethodName, LogType, ClassInstanceName);
end;

class procedure TPscUtils.Log(Msg, MethodName: String; LogType: TLogger; ClassInstance: TObject);
begin
  TPscLogger.Log(Msg, MethodName, LogType, ClassInstance);
end;

class procedure TPscUtils.RegisterView(const RegistrationInfo: TViewRegistrationInfo);
begin
  ViewsRegistry.AddOrSetValue(RegistrationInfo.ViewGUID, RegistrationInfo);
  TPscUtils.Log(Format('Name: %s, GUID: %s, ID: %d', [RegistrationInfo.ViewName, RegistrationInfo.ViewGUID, RegistrationInfo.ViewID]), 'RegisterView', TLogger.Info, nil);
end;

class function TPscUtils.Runnable(AView: JView; AProc: TProc<JView>): TPscRunnable;
begin
  Result := TPscRunnable.Create(AView, AProc);
end;

class procedure TPscUtils.SetRoundedCorners(View: JView; CornerRadius: Single; BackgroundColor: Integer);
var
  GradientDrawable: JGradientDrawable;
begin
  GradientDrawable := TJGradientDrawable.JavaClass.init;
  GradientDrawable.setShape(TJGradientDrawable.JavaClass.RECTANGLE);
  GradientDrawable.setCornerRadius(CornerRadius);
  GradientDrawable.setColor(BackgroundColor);
  View.setBackground(GradientDrawable);
end;

class procedure TPscUtils.ShowPopupWindow(Anchor: JView; ContentView: JView; AWidth, AHeight: Integer);
var
  PopupWindow: JPopupWindow;
  Parent: JViewGroup;
  OriginalIndex: Integer;
  DismissListener: JPopupWindow_OnDismissListener;
begin
  TPscUtils.Log('Creating PopUp', 'ShowPopupWindow', TLogger.Info, nil);
  PopupWindow := TJPopupWindow.JavaClass.init;

  // Check if the ContentView already has a parent
  Parent := TJViewGroup.Wrap(ContentView.getParent);
  if Parent <> nil then begin
    OriginalIndex := Parent.indexOfChild(ContentView);
    Parent.removeView(ContentView)
  end else begin
    OriginalIndex := -1; // No original parent
  end;

  PopupWindow.setContentView(ContentView);
  PopupWindow.setWidth(AWidth);
  PopupWindow.setHeight(AHeight);
  PopupWindow.setFocusable(True);

  // Define the dismiss listener to return the view to its original parent if it exists
  DismissListener := TPscPopupWindowDismissListener.Create(
    procedure begin
      if (Parent <> nil) and (OriginalIndex >= 0) then
      begin
        Parent.addView(ContentView, OriginalIndex);
      end;
    end);

  PopupWindow.setOnDismissListener(DismissListener);
  if Anchor <> nil then begin
    try
      TPscUtils.Log('Showing view as dropdown', 'ShowPopupWindow', TLogger.Info, nil);
      PopupWindow.showAsDropDown(Anchor);
    except
      on E: Exception do
        TPscUtils.Log('Error showing popup: ' + E.Message, 'ShowPopupWindow', TLogger.Error, nil);
    end;
  end else
    TPscUtils.Log('Anchor view is nil', 'ShowPopupWindow', TLogger.Warning, nil);
end;

class procedure TPscUtils.SmoothScrollTo(View: JView; TargetX, TargetY, Duration: Integer);
var
  Scroller: JScroller;
  Handler: JHandler;
  Runnable: TPscRunnable;
begin
  if View = nil then
    Exit;

  Scroller := TJScroller.JavaClass.init(TAndroidHelper.Context);
  Scroller.startScroll(Scroller.getCurrX, Scroller.getCurrY, TargetX - Scroller.getCurrX, TargetY - Scroller.getCurrY, Duration);
  Handler := TJHandler.JavaClass.init;        // Create a handler to update the UI
  Runnable := TPscRunnable.Create(View,       // Define a JRunnable to perform the scrolling
    procedure(AView: JView)
    begin
      if Scroller.computeScrollOffset then
      begin
        AView.setScrollX(Scroller.getCurrX);
        AView.setScrollY(Scroller.getCurrY);
        AView.invalidate;                     // Redraw the view
        Handler.post(Runnable);               // Post the runnable again to continue scrolling
      end;
    end);
  Handler.post(Runnable);                     // Start the scrolling by posting the runnable
end;

class procedure TPscUtils.SetBackgroundWithRipple(View: JView; BackgroundColor: Integer; RippleColor: Integer; CornerRadius: Single);
var
  BackgroundDrawable: JGradientDrawable;
  RippleDrawable: JRippleDrawable;
  ColorStateList: JColorStateList;
begin
  if View <> nil then begin
    BackgroundDrawable := TJGradientDrawable.JavaClass.init;
    BackgroundDrawable.setShape(TJGradientDrawable.JavaClass.RECTANGLE);
    BackgroundDrawable.setColor(BackgroundColor);
    BackgroundDrawable.setCornerRadius(CornerRadius);
    ColorStateList := TJColorStateList.JavaClass.valueOf(RippleColor);
    RippleDrawable := TJRippleDrawable.JavaClass.init(ColorStateList, BackgroundDrawable, nil);
    View.setBackground(RippleDrawable);
  end;
end;

class procedure TPscUtils.SetBackgroundWithRipple(View: JView;
  ResourceDrawable: JDrawable; RippleColor: Integer; CornerRadius: Single);
var
  ShapeDrawable: JGradientDrawable;
  ColorStateList: JColorStateList;
  RippleDrawable: JRippleDrawable;
  LayerArray: TJavaObjectArray<JDrawable>;
  Layered: JLayerDrawable;
begin
  if (View = nil) or (ResourceDrawable = nil) then
    Exit;

  // 1) Shape drawable for corner clipping
  ShapeDrawable := TJGradientDrawable.JavaClass.init;
  ShapeDrawable.setShape(TJGradientDrawable.JavaClass.RECTANGLE);
  ShapeDrawable.setCornerRadius(CornerRadius);

  // 2) Build a RippleDrawable (with ShapeDrawable as mask)
  ColorStateList := TJColorStateList.JavaClass.valueOf(RippleColor);
  RippleDrawable := TJRippleDrawable.JavaClass.init(
    ColorStateList,       // pressed overlay color
    ResourceDrawable,     // content drawable
    nil                   // mask for clipping corners
  );


  // 3) Combine shape, resource, ripple into a layered drawable
  LayerArray := TJavaObjectArray<JDrawable>.Create(2);
  LayerArray.Items[0] := ShapeDrawable;     // base corner shape
  LayerArray.Items[1] := RippleDrawable;    // top layer for ripple effect
  Layered := TJLayerDrawable.JavaClass.init(LayerArray);

  // 4) Enable corner clipping and set the final layered background
  View.setClipToOutline(True);
  View.setBackground(Layered);
end;

class procedure TPscUtils.SetForegroundRipple(View: JView; RippleColor: Integer; CornerRadius: Single);
var
  ColorStateList: JColorStateList;
  RippleDrawable: JRippleDrawable;
  MaskDrawable: JGradientDrawable;
begin
  if View = nil then
    Exit;

  // Create a mask drawable for the ripple effect
  MaskDrawable := TJGradientDrawable.JavaClass.init;
  MaskDrawable.setShape(TJGradientDrawable.JavaClass.RECTANGLE);
  MaskDrawable.setCornerRadius(CornerRadius);
  MaskDrawable.setColor(TJColor.JavaClass.TRANSPARENT);

  // Create a ripple drawable with the specified color
  ColorStateList := TJColorStateList.JavaClass.valueOf(RippleColor);
  RippleDrawable := TJRippleDrawable.JavaClass.init(
    ColorStateList, // Ripple color
    nil,            // No content drawable, ripple will be on top
    nil             // No Mask for clipping corners
  );

  // Set the ripple drawable as the view's foreground
  View.setForeground(RippleDrawable);

  // Ensure the view is clickable to trigger the ripple effect
  View.setClickable(True);
  View.setFocusable(True);
end;

class procedure TPscUtils.SetMultiGradientBackground(View: JView;
  const ColorStops: TColorStopArray; Orientation: TGradientOrientation;
  CornerRadius, GradientRadius: Single; Shape: TGradientShape);
var
  GradientDrawable: JGradientDrawable;
  Colors: TJavaArray<Integer>;
  Positions: TJavaArray<Single>;
  GradientOrientation: JGradientDrawable_Orientation;
  AndroidGradientType: Integer;
  i: Integer;
  HasPositions: Boolean;
begin
  if (View = nil) or (Length(ColorStops) < 2) then
    Exit;

  GradientDrawable := TJGradientDrawable.JavaClass.init;

  // Convert to Android colors
  Colors := TJavaArray<Integer>.Create(Length(ColorStops));
  for i := 0 to High(ColorStops) do begin
    if ColorStops[i].Alpha = 0 then
      Colors.Items[i] := TJColor.JavaClass.TRANSPARENT
    else
      Colors.Items[i] := TJColor.JavaClass.argb(
        Trunc(ColorStops[i].Alpha * 255),
        ColorStops[i].Red,
        ColorStops[i].Green,
        ColorStops[i].Blue
      );
  end;

  // Check for custom positions
  HasPositions := False;
  for i := 0 to High(ColorStops) do begin
    if (ColorStops[i].Position >= 0) and (ColorStops[i].Position <= 1) then begin
      HasPositions := True;
      Break;
    end;
  end;

  // Set positions if custom ones are provided
  if HasPositions then begin
    Positions := TJavaArray<Single>.Create(Length(ColorStops));
    for i := 0 to High(ColorStops) do begin
      if (ColorStops[i].Position >= 0) and (ColorStops[i].Position <= 1) then
        Positions.Items[i] := ColorStops[i].Position
      else
        Positions.Items[i] := i / (Length(ColorStops) - 1);
    end;
  end;

  // ← Add back the gradient shape handling
  case Shape of
    TGradientShape.Linear: AndroidGradientType := TJGradientDrawable.JavaClass.LINEAR_GRADIENT;
    TGradientShape.Radial: AndroidGradientType := TJGradientDrawable.JavaClass.RADIAL_GRADIENT;
    TGradientShape.Sweep: AndroidGradientType := TJGradientDrawable.JavaClass.SWEEP_GRADIENT;
  else
    AndroidGradientType := TJGradientDrawable.JavaClass.LINEAR_GRADIENT;
  end;

  GradientDrawable.setGradientType(AndroidGradientType);

  // Set orientation (only applies to linear gradients)
  if Shape = TGradientShape.Linear then begin
    case Orientation of
      TGradientOrientation.TopToBottom: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.TOP_BOTTOM;
      TGradientOrientation.LeftToRight: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.LEFT_RIGHT;
      TGradientOrientation.BottomToTop: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.BOTTOM_TOP;
      TGradientOrientation.RightToLeft: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.RIGHT_LEFT;
      TGradientOrientation.TopLeftToBottomRight: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.TL_BR;
      TGradientOrientation.TopRightToBottomLeft: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.TR_BL;
      TGradientOrientation.BottomLeftToTopRight: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.BL_TR;
      TGradientOrientation.BottomRightToTopLeft: GradientOrientation := TJGradientDrawable_Orientation.JavaClass.BR_TL;
    else
      GradientOrientation := TJGradientDrawable_Orientation.JavaClass.TOP_BOTTOM;
    end;
    GradientDrawable.setOrientation(GradientOrientation);
  end;

  // ← Add back radial gradient radius handling
  if Shape = TGradientShape.Radial then begin
    // Set a default radius or use the provided GradientRadius
    if GradientRadius > 0 then
      GradientDrawable.setGradientRadius(GradientRadius)
    else
      GradientDrawable.setGradientRadius(200); // Default radius
  end;

  GradientDrawable.setColors(Colors);
  GradientDrawable.setShape(TJGradientDrawable.JavaClass.RECTANGLE);

  if CornerRadius > 0 then
    GradientDrawable.setCornerRadius(CornerRadius);

  View.setBackground(GradientDrawable);

end;

class procedure TPscUtils.SetRoundedCorners(View: JView; CornerRadius: Single);
var
  BgRes: JDrawable;
  ShapeDrawable: JGradientDrawable;
  LayerArray: TJavaObjectArray<JDrawable>;
  Layered: JLayerDrawable;
begin
  if View = nil then Exit;
  BgRes := View.getBackground;
  ShapeDrawable := TJGradientDrawable.JavaClass.init;
  ShapeDrawable.setShape(TJGradientDrawable.JavaClass.RECTANGLE);
  ShapeDrawable.setCornerRadius(CornerRadius);
  LayerArray := TJavaObjectArray<JDrawable>.Create(2);
  LayerArray.Items[0] := ShapeDrawable;
  LayerArray.Items[1] := BgRes;
  Layered := TJLayerDrawable.JavaClass.init(LayerArray);
  View.setClipToOutline(True);
  View.setBackground(Layered);
end;

class procedure TPscUtils.SetScreenOrientation(Orientation: TScreenOrientation);
var
  OrientationValue: Integer;
begin
  case Orientation of
    TScreenOrientation.Portrait:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_PORTRAIT;
    TScreenOrientation.Landscape:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_LANDSCAPE;
    TScreenOrientation.SensorPortrait:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_SENSOR_PORTRAIT;
    TScreenOrientation.SensorLandscape:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_SENSOR_LANDSCAPE;
    TScreenOrientation.ReverseLandscape:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_REVERSE_LANDSCAPE;
    TScreenOrientation.ReversePortrait:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_REVERSE_PORTRAIT;
    TScreenOrientation.Sensor:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_SENSOR;
    TScreenOrientation.NoSensor:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_NOSENSOR;
    TScreenOrientation.Locked:
      OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_LOCKED;
  else
    OrientationValue := TJActivityInfo.JavaClass.SCREEN_ORIENTATION_UNSPECIFIED;
  end;

  TAndroidHelper.Activity.setRequestedOrientation(OrientationValue);
  Log('Screen orientation set', 'TPscUtils', TLogger.Info, 'SetScreenOrientation');
end;

class function TPscUtils.Sound: TPscSound;
begin
  Result := TPscSound.Instance;
end;

class function TPscUtils.Music: TPscMusic;
begin
  Result := TPscMusic.Instance;
end;

class function TPscUtils.PopupWindow: IPscPopupWindow;
begin
  Result := TPscPopupWindow.New;
end;

class function TPscUtils.AlertDialog: IPscAlertDialog;
begin
  Result := TPscAlertDialog.New;
end;

class procedure TPscUtils.StatusBarColor(Color: Integer);
begin
  TAndroidHelper.Activity.getWindow.setStatusBarColor(Color);
end;

class procedure TPscUtils.StatusBarDarkIcons(View: JView);
begin
  View.setSystemUiVisibility(
    View.getSystemUiVisibility or
    TJView.JavaClass.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
  );
end;

class procedure TPscUtils.StatusBarLightIcons(View: JView);
begin
  View.setSystemUiVisibility(
    View.getSystemUiVisibility and
    (not TJView.JavaClass.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR)
  );
end;

class procedure TPscUtils.Toast(Text: String; Duration: Integer);
var
  JText: JString;
begin
  JText := StringToJString(Text);
  TJToast.JavaClass.makeText(
    TAndroidHelper.Context,
    TJCharSequence.Wrap(JText),
    Duration
  ).show;
end;

{ TPscUtilsIntent }

class procedure TPscUtilsIntent.ActionView(Url: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString(Url)));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionSend(Text: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  Intent.setType(StringToJString('text/plain'));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Text));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionCall(PhoneNumber: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_CALL);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString('tel:' + PhoneNumber)));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionDial(PhoneNumber: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_DIAL);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString('tel:' + PhoneNumber)));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionCapturePhoto;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJMediaStore.JavaClass.ACTION_IMAGE_CAPTURE);
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionPlayMedia(MediaUri: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setDataAndType(TJnet_Uri.JavaClass.parse(StringToJString(MediaUri)), StringToJString('video/*'));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionOpenMap(Latitude, Longitude: Double);
var
  GeoUri: String;
  Intent: JIntent;
begin
  GeoUri := 'geo:' + FloatToStr(Latitude) + ',' + FloatToStr(Longitude);
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString(GeoUri)));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionOpenSettings;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJSettings.JavaClass.ACTION_SETTINGS);
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionSendEmail(EmailAddress, Subject, Body: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SENDTO);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString('mailto:' + EmailAddress)));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_SUBJECT, StringToJString(Subject));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Body));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionSendSMS(PhoneNumber, Message: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SENDTO);
  Intent.setData(TJnet_Uri.JavaClass.parse(StringToJString('smsto:' + PhoneNumber)));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_TEXT, StringToJString(Message));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionSendFile(FilePath: String; MimeType: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  Intent.setType(StringToJString(MimeType));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, StringToJString(FilePath));
  TAndroidHelper.Activity.startActivity(TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence('Share File')));
end;

class procedure TPscUtilsIntent.ActionPickFile(MimeType: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_GET_CONTENT);
  Intent.setType(StringToJString(MimeType));
  Intent.addCategory(TJIntent.JavaClass.CATEGORY_OPENABLE);
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionViewFile(FilePath: String; MimeType: String);
var
  Intent: JIntent;
  FileUri: Jnet_Uri;
begin
  FileUri := TJnet_Uri.JavaClass.fromFile(TJFile.JavaClass.init(StringToJString(FilePath)));
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_VIEW);
  Intent.setDataAndType(FileUri, StringToJString(MimeType));
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionShareImage(ImagePath: String);
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJIntent.JavaClass.ACTION_SEND);
  Intent.setType(StringToJString('image/*'));
  Intent.putExtra(TJIntent.JavaClass.EXTRA_STREAM, StringToJString(ImagePath));
  TAndroidHelper.Activity.startActivity(TJIntent.JavaClass.createChooser(Intent, StrToJCharSequence('Share Image')));
end;

class procedure TPscUtilsIntent.ActionEnableWifi;
var
  WifiManager: JWifiManager;
begin
  WifiManager := TJWifiManager.Wrap(TAndroidHelper.Context.getSystemService(TJContext.JavaClass.WIFI_SERVICE));
  WifiManager.setWifiEnabled(True);
end;

class procedure TPscUtilsIntent.ActionDisableWifi;
var
  WifiManager: JWifiManager;
begin
  WifiManager := TJWifiManager.Wrap(TAndroidHelper.Context.getSystemService(TJContext.JavaClass.WIFI_SERVICE));
  WifiManager.setWifiEnabled(False);
end;

class procedure TPscUtilsIntent.ActionEnableBluetooth;
var
  BluetoothAdapter: JBluetoothAdapter;
begin
  BluetoothAdapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
  if BluetoothAdapter <> nil then
    BluetoothAdapter.enable;
end;

class procedure TPscUtilsIntent.ActionDisableBluetooth;
var
  BluetoothAdapter: JBluetoothAdapter;
begin
  BluetoothAdapter := TJBluetoothAdapter.JavaClass.getDefaultAdapter;
  if BluetoothAdapter <> nil then
    BluetoothAdapter.disable;
end;

class procedure TPscUtilsIntent.ActionOpenWifiSettings;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJSettings.JavaClass.ACTION_WIFI_SETTINGS);
  TAndroidHelper.Activity.startActivity(Intent);
end;

class procedure TPscUtilsIntent.ActionOpenBluetoothSettings;
var
  Intent: JIntent;
begin
  Intent := TJIntent.JavaClass.init(TJSettings.JavaClass.ACTION_BLUETOOTH_SETTINGS);
  TAndroidHelper.Activity.startActivity(Intent);
end;

{ TPscRunnable }

constructor TPscRunnable.Create(AView: JView; AProc: TProc<JView>);
begin
  inherited Create;
  FView := AView;
  FProc := AProc;
end;

procedure TPscRunnable.run;
begin
  if Assigned(FProc) then
    FProc(FView);
end;

{ TRoundedOutlineProvider }

constructor TRoundedOutlineProvider.Create(ACornerRadius: Single);
begin
  inherited Create;
  FCornerRadius := ACornerRadius;
end;

procedure TRoundedOutlineProvider.getOutline(view: JView; outline: JOutline); cdecl;
var
  w, h: Integer;
begin
  w := view.getWidth;
  h := view.getHeight;
  if (w > 0) and (h > 0) then
    outline.setRoundRect(0, 0, w, h, FCornerRadius);
end;

function TRoundedOutlineProvider.equals(obj: JObject): Boolean; cdecl;
var
  Other: TRoundedOutlineProvider;
begin
  if obj = nil then Exit(False);
  if Supports(obj, JViewOutlineProvider, Other) then
    Result := FCornerRadius = Other.FCornerRadius
  else
    Result := False;
end;

function TRoundedOutlineProvider.getClass: Jlang_Class; cdecl;
begin
  Result := nil;
end;

function TRoundedOutlineProvider.hashCode: Integer; cdecl;
begin
  Result := Round(FCornerRadius * 1000) xor (Integer(UIntPtr(Self)) and $FFFFFFFF);
end;

procedure TRoundedOutlineProvider.notify; cdecl;
begin
  // Do nothing
end;

procedure TRoundedOutlineProvider.notifyAll; cdecl;
begin
  // Do nothing
end;

function TRoundedOutlineProvider.toString: JString; cdecl;
begin
  Result := StringToJString('TRoundedOutlineProvider: CornerRadius=' + FloatToStr(FCornerRadius));
end;

procedure TRoundedOutlineProvider.wait(timeout: Int64); cdecl;
begin
  // Do nothing
end;

procedure TRoundedOutlineProvider.wait(timeout: Int64; nanos: Integer); cdecl;
begin
  // Do nothing
end;

procedure TRoundedOutlineProvider.wait; cdecl;
begin
  // Do nothing
end;

{ TPscAnimate }

constructor TPscAnimate.Create;
begin
  inherited Create;
  FFromView := nil;
  FAnimatorProperties := nil;
end;

class function TPscAnimate.Instance: TPscAnimate;
begin
  if FInstance = nil then
    FInstance := TPscAnimate.Create;
  Result := FInstance;
end;

class destructor TPscAnimate.Destroy;
begin
  if FInstance <> nil then
    FInstance.Free;
end;

function TPscAnimate.FromView(AView: JView): TPscAnimate;
begin
  FFromView := AView;
  if AView <> nil then
    FAnimatorProperties := AView.animate;
  Result := Self;
end;

function TPscAnimate.TranslateX(X1, X2: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.translationX(X2);
  Result := Self;
end;

function TPscAnimate.TranslateY(Y1, Y2: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.translationY(Y2);
  Result := Self;
end;

function TPscAnimate.Alpha(StartAlpha, EndAlpha: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.alpha(EndAlpha);
  Result := Self;
end;

function TPscAnimate.ScaleX(StartScale, EndScale: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.scaleX(EndScale);
  Result := Self;
end;

function TPscAnimate.ScaleY(StartScale, EndScale: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.scaleY(EndScale);
  Result := Self;
end;

function TPscAnimate.Scale(StartScale, EndScale: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
  begin
    FAnimatorProperties := FAnimatorProperties.scaleX(EndScale);
    FAnimatorProperties := FAnimatorProperties.scaleY(EndScale);
  end;
  Result := Self;
end;

function TPscAnimate.RotationX(StartRotation, EndRotation: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.rotationX(EndRotation);
  Result := Self;
end;

function TPscAnimate.RotationY(StartRotation, EndRotation: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.rotationY(EndRotation);
  Result := Self;
end;

function TPscAnimate.Rotation(StartRotation, EndRotation: Single): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.rotation(EndRotation);
  Result := Self;
end;

function TPscAnimate.Duration(Milliseconds: Int64): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.setDuration(Milliseconds);
  Result := Self;
end;

function TPscAnimate.StartDelay(Milliseconds: Int64): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.setStartDelay(Milliseconds);
  Result := Self;
end;

function TPscAnimate.WithStartAction(AProc: TProc): TPscAnimate;
var
  StartRunnable: TPscRunnable;
begin
  if FAnimatorProperties <> nil then
  begin
    StartRunnable := TPscRunnable.Create(nil,
      procedure(AView: JView)
      begin
        if Assigned(AProc) then
          AProc;
      end);
    FAnimatorProperties := FAnimatorProperties.withStartAction(StartRunnable);
  end;
  Result := Self;
end;

function TPscAnimate.WithEndAction(AProc: TProc): TPscAnimate;
var
  EndRunnable: TPscRunnable;
begin
  if FAnimatorProperties <> nil then
  begin
    EndRunnable := TPscRunnable.Create(nil,
      procedure(AView: JView)
      begin
        if Assigned(AProc) then
          AProc;
      end);
    FAnimatorProperties := FAnimatorProperties.withEndAction(EndRunnable);
  end;
  Result := Self;
end;

function TPscAnimate.WithLayer: TPscAnimate;
begin
  if FAnimatorProperties <> nil then
    FAnimatorProperties := FAnimatorProperties.withLayer;
  Result := Self;
end;

function TPscAnimate.FadeIn(ADuration: Int64): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
  begin
    FAnimatorProperties := FAnimatorProperties.alpha(1.0);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration);
  end;
  Result := Self;
end;

function TPscAnimate.FadeOut(ADuration: Int64): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
  begin
    FAnimatorProperties := FAnimatorProperties.alpha(0.0);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration);
  end;
  Result := Self;
end;

function TPscAnimate.SlideInFromLeft(ADuration: Int64): TPscAnimate;
var
  CurrentView: JView;
begin
  CurrentView := FFromView;
  if (CurrentView <> nil) and (FAnimatorProperties <> nil) then
  begin
    CurrentView.setTranslationX(-CurrentView.getWidth);
    FAnimatorProperties := FAnimatorProperties.translationX(0);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration);
  end;
  Result := Self;
end;

function TPscAnimate.SlideInFromRight(ADuration: Int64): TPscAnimate;
var
  CurrentView: JView;
begin
  CurrentView := FFromView;
  if (CurrentView <> nil) and (FAnimatorProperties <> nil) then
  begin
    CurrentView.setTranslationX(CurrentView.getWidth);
    FAnimatorProperties := FAnimatorProperties.translationX(0);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration);
  end;
  Result := Self;
end;

function TPscAnimate.SlideOutToLeft(ADuration: Int64): TPscAnimate;
var
  CurrentView: JView;
begin
  CurrentView := FFromView;
  if (CurrentView <> nil) and (FAnimatorProperties <> nil) then
  begin
    FAnimatorProperties := FAnimatorProperties.translationX(-CurrentView.getWidth);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration);
  end;
  Result := Self;
end;

function TPscAnimate.SlideOutToRight(ADuration: Int64): TPscAnimate;
var
  CurrentView: JView;
begin
  CurrentView := FFromView;
  if (CurrentView <> nil) and (FAnimatorProperties <> nil) then
  begin
    FAnimatorProperties := FAnimatorProperties.translationX(CurrentView.getWidth);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration);
  end;
  Result := Self;
end;

function TPscAnimate.Pulse(ADuration: Int64): TPscAnimate;
begin
  if FAnimatorProperties <> nil then
  begin
    FAnimatorProperties := FAnimatorProperties.scaleX(1.2);
    FAnimatorProperties := FAnimatorProperties.scaleY(1.2);
    if ADuration > 0 then
      FAnimatorProperties := FAnimatorProperties.setDuration(ADuration div 2);
  end;
  Result := Self;
end;

procedure TPscAnimate.Run;
begin
  if FAnimatorProperties <> nil then
  begin
    FAnimatorProperties.start;
    // Reset after starting
    FAnimatorProperties := nil;
    FFromView := nil;
  end;
end;

procedure TPscAnimate.Cancel;
begin
  if FAnimatorProperties <> nil then
  begin
    FAnimatorProperties.cancel;
    FAnimatorProperties := nil;
    FFromView := nil;
  end;
end;


end.
