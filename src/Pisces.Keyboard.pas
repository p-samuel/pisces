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
    procedure HandleKeyboardChange(AIsVisible: Boolean; AKeyboardHeight: Integer);
  public
    constructor Create(ARootView: JView; AThreshold: Integer = 150);
    destructor Destroy; override;
    procedure Enable;
    procedure Disable;
  end;

implementation

uses
  Pisces.Utils, System.SysUtils;

constructor TPscKeyboardHelper.Create(ARootView: JView; AThreshold: Integer);
begin
  inherited Create;
  FRootView := ARootView;
  FThreshold := AThreshold;
  FEnabled := False;
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
begin
  TPscUtils.Log(Format('Keyboard %s, Height: %d',
    [BoolToStr(AIsVisible, True), AKeyboardHeight]),
    'HandleKeyboardChange', TLogger.Info, Self);

  // Simple approach: just add/remove bottom padding
  if AIsVisible then
    FRootView.setPadding(
      FRootView.getPaddingLeft,
      FRootView.getPaddingTop,
      FRootView.getPaddingRight,
      AKeyboardHeight
    )
  else
    FRootView.setPadding(
      FRootView.getPaddingLeft,
      FRootView.getPaddingTop,
      FRootView.getPaddingRight,
      0
    );
end;

end.
