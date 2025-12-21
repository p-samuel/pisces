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
    procedure HandleKeyboardChange(AIsVisible: Boolean; AKeyboardHeight: Integer);
  public
    constructor Create(ARootView: JView; AThreshold: Integer = 150);
    destructor Destroy; override;
    procedure Enable;
    procedure Disable;
  end;

implementation

uses
  Pisces.Utils, System.SysUtils, System.Math;

constructor TPscKeyboardHelper.Create(ARootView: JView; AThreshold: Integer);
begin
  inherited Create;
  FRootView := ARootView;
  FThreshold := AThreshold;
  FEnabled := False;
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

  FListener := TPscGlobalLayoutListener.Create(FRootView, FThreshold);
  FListener.Proc := HandleKeyboardChange;

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
