unit Pisces.Keyboard;

interface

uses
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Widget,
  Androidapi.Helpers,
  Pisces.Types,
  Pisces.EventListeners;

type
  TPscKeyboardHelper = class
  private
    FRootView: JView;
    FListener: TPscGlobalLayoutListener;
    FEnabled: Boolean;
    FThreshold: Integer;
    FBasePaddingLeft: Integer;
    FBasePaddingTop: Integer;
    FBasePaddingRight: Integer;
    FBasePaddingBottom: Integer;
    FBaseVisibleHeight: Integer;
    FBaseSystemDelta: Integer;
    FIsKeyboardVisible: Boolean;
    FLastKeyboardHeight: Integer;
    procedure HandleLayout(ARootView: JView; ARootHeight, AVisibleHeight: Integer);
    function GetImeInsetBottom(ARootView: JView): Integer;
    procedure HandleKeyboardChange(AIsVisible: Boolean; AKeyboardHeight: Integer);
  public
    constructor Create(ARootView: JView; AThreshold: Integer = 150);
    destructor Destroy; override;
    procedure Enable;
    procedure Disable;
    procedure ResetPadding;
  end;

implementation

uses
  Pisces.Utils,
  System.SysUtils,
  System.Math,
  Androidapi.JNI.Os,
  Pisces.JNI.Extensions;

constructor TPscKeyboardHelper.Create(ARootView: JView; AThreshold: Integer);
begin
  inherited Create;
  FRootView := ARootView;
  FThreshold := AThreshold;
  FEnabled := False;
  FBaseVisibleHeight := 0;
  FBaseSystemDelta := -1;
  FIsKeyboardVisible := False;
  FLastKeyboardHeight := 0;
  if FRootView <> nil then
  begin
    FBasePaddingLeft := FRootView.getPaddingLeft;
    FBasePaddingTop := FRootView.getPaddingTop;
    FBasePaddingRight := FRootView.getPaddingRight;
    FBasePaddingBottom := FRootView.getPaddingBottom;
  end
  else
  begin
    FBasePaddingLeft := 0;
    FBasePaddingTop := 0;
    FBasePaddingRight := 0;
    FBasePaddingBottom := 0;
  end;
end;

destructor TPscKeyboardHelper.Destroy;
begin
  Disable;
  inherited;
end;

procedure TPscKeyboardHelper.Enable;
var
  ViewTreeObserver: JViewTreeObserver;
begin
  if FEnabled then Exit;

  FListener := TPscGlobalLayoutListener.Create(FRootView);
  FListener.Proc := HandleLayout;

  ViewTreeObserver := FRootView.getViewTreeObserver;
  if Assigned(ViewTreeObserver) then begin
    ViewTreeObserver.addOnGlobalLayoutListener(FListener);
    FEnabled := True;
    TPscUtils.Log('Keyboard helper enabled', 'Enable', TLogger.Info, Self);
  end;
end;

procedure TPscKeyboardHelper.Disable;
var
  ViewTreeObserver: JViewTreeObserver;
begin
  if not FEnabled or not Assigned(FListener) then Exit;

  ViewTreeObserver := FRootView.getViewTreeObserver;
  if Assigned(ViewTreeObserver) then
    ViewTreeObserver.removeOnGlobalLayoutListener(FListener);

  FListener.Free;
  FListener := nil;
  FEnabled := False;
  TPscUtils.Log('Keyboard helper disabled', 'Disable', TLogger.Info, Self);
end;

procedure TPscKeyboardHelper.ResetPadding;
begin
  if FRootView = nil then
    Exit;

  FRootView.setPadding(
    FBasePaddingLeft,
    FBasePaddingTop,
    FBasePaddingRight,
    FBasePaddingBottom
  );

  FIsKeyboardVisible := False;
  FLastKeyboardHeight := 0;
end;

function TPscKeyboardHelper.GetImeInsetBottom(ARootView: JView): Integer;
var
  Insets: JWindowInsets;
  SystemBottom: Integer;
  StableBottom: Integer;
  ImeInsets: Jgraphics_Insets;
  ImeType: Integer;
begin
  Result := 0;
  if ARootView = nil then
    Exit;
  if TJBuild_VERSION.JavaClass.SDK_INT < 20 then
    Exit;

  Insets := ARootView.getRootWindowInsets;
  if Insets = nil then
    Exit;

  // Android 11+ provides IME insets directly
  if TJBuild_VERSION.JavaClass.SDK_INT >= 30 then
  begin
    ImeType := TJWindowInsets_Type.JavaClass.ime;
    ImeInsets := Insets.getInsets(ImeType);
    if ImeInsets <> nil then
      Result := ImeInsets.bottom;
    Exit;
  end;

  // Fallback for older APIs: derive IME delta from system vs stable insets
  SystemBottom := Insets.getSystemWindowInsetBottom;
  StableBottom := Insets.getStableInsetBottom;
  Result := SystemBottom - StableBottom;
  if Result < 0 then
    Result := 0;
end;

procedure TPscKeyboardHelper.HandleLayout(ARootView: JView; ARootHeight, AVisibleHeight: Integer);
var
  CurrentDelta: Integer;
  EffectiveKeyboardHeight: Integer;
  ImeInsetBottom: Integer;
  MinKeyboardHeightPx: Integer;
  PercentThreshold: Integer;
  DynamicThreshold: Integer;
  IsVisible: Boolean;
begin
  if ARootHeight <= 0 then
    Exit;

  if (ARootView <> nil) and (not ARootView.hasWindowFocus) then
  begin
    if FIsKeyboardVisible or (FLastKeyboardHeight <> 0) then
      ResetPadding;
    Exit;
  end;

  // Track baseline visible height (best guess of no-keyboard state)
  if FBaseVisibleHeight = 0 then
    FBaseVisibleHeight := AVisibleHeight
  else if AVisibleHeight > FBaseVisibleHeight then
    FBaseVisibleHeight := AVisibleHeight;

  CurrentDelta := ARootHeight - AVisibleHeight; // includes system bars + keyboard

  // Track minimal delta (system bars only) to isolate keyboard height
  if FBaseSystemDelta = -1 then
    FBaseSystemDelta := CurrentDelta
  else if CurrentDelta < FBaseSystemDelta then
    FBaseSystemDelta := CurrentDelta;

  EffectiveKeyboardHeight := Max(0, CurrentDelta - FBaseSystemDelta);
  ImeInsetBottom := GetImeInsetBottom(ARootView);
  if ImeInsetBottom > 0 then
    EffectiveKeyboardHeight := Max(EffectiveKeyboardHeight, ImeInsetBottom);

  // Use device threshold, or ~12dp, or ~1.5% of baseline visible height
  MinKeyboardHeightPx := Round(12 * TAndroidHelper.DisplayMetrics.density);
  PercentThreshold := Round(FBaseVisibleHeight * 0.015);
  DynamicThreshold := Max(FThreshold, Max(MinKeyboardHeightPx, PercentThreshold));

  IsVisible := EffectiveKeyboardHeight >= DynamicThreshold;

  TPscUtils.Log(
    Format('RootHeight=%d VisibleHeight=%d BaseVisibleHeight=%d BaseSystemDelta=%d CurrentDelta=%d ImeInset=%d Effective=%d Threshold=%d',
    [ARootHeight, AVisibleHeight, FBaseVisibleHeight, FBaseSystemDelta, CurrentDelta, ImeInsetBottom, EffectiveKeyboardHeight, DynamicThreshold]
    ), 'HandleLayout', TLogger.Info, Self );

  if (IsVisible <> FIsKeyboardVisible) or (IsVisible and (EffectiveKeyboardHeight <> FLastKeyboardHeight)) then
  begin
    if IsVisible then
      HandleKeyboardChange(True, EffectiveKeyboardHeight)
    else
      HandleKeyboardChange(False, 0);
  end;

  FIsKeyboardVisible := IsVisible;
  if IsVisible then
    FLastKeyboardHeight := EffectiveKeyboardHeight
  else
    FLastKeyboardHeight := 0;
end;

procedure TPscKeyboardHelper.HandleKeyboardChange(AIsVisible: Boolean; AKeyboardHeight: Integer);
var
  ScreenRoot: JView;
  ScreenHeight: Integer;
  TargetBottom: Integer;
  BottomBuffer: Integer;
begin
  TPscUtils.Log(Format('Keyboard %s, Height: %d',
    [BoolToStr(AIsVisible, True), AKeyboardHeight]),
    'HandleKeyboardChange', TLogger.Info, Self);

  ScreenRoot := nil;
  if FRootView <> nil then
    ScreenRoot := FRootView.getRootView;

  ScreenHeight := 0;
  if ScreenRoot <> nil then
    ScreenHeight := ScreenRoot.getHeight;

  if AIsVisible then
  begin
    // Ensure padding at least ~30% of screen height to keep focused edits above IME on devices that don't resize
    TargetBottom := Max(AKeyboardHeight, Round(ScreenHeight * 0.30));
    // Add a small extra buffer (~16dp) to fully clear the keyboard
    BottomBuffer := Round(0 * TAndroidHelper.DisplayMetrics.density);
    TargetBottom := TargetBottom + BottomBuffer;
    FRootView.setPadding(
      FBasePaddingLeft,
      FBasePaddingTop,
      FBasePaddingRight,
      FBasePaddingBottom + TargetBottom
    );
  end
  else
  begin
    // Restore original padding when keyboard hides
    FRootView.setPadding(
      FBasePaddingLeft,
      FBasePaddingTop,
      FBasePaddingRight,
      FBasePaddingBottom
    );
  end;
end;

end.
