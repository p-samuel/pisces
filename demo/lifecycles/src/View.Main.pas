unit View.Main;

interface

uses
  Pisces;

type

  [ TextView('text'),
    TextColor(255, 255, 255),
    TextSize(19),
    Height(300),
    Padding(50, 50, 50, 50),
    Gravity([TGravity.Center]),
    BackgroundColor(79, 129, 148),
    RippleColor(125, 221, 255),
    Width(700),
    CornerRadius(100),
    Justify(True, TBreakStrg.HighQuality)
  ] TText = class(TPisces)
  public
    procedure AfterShow; override;
    procedure OnViewAttachedToWindowHandler(AView: JView); override;
    procedure OnViewDetachedFromWindowHandler(AView: JView); override;
  end;

  [ LinearLayout('screen'),
    BackgroundColor(107, 174, 200),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Center])
  ] TScreen = class(TPisces)
  private
    FText: TText;

    // Activity lifecycle handlers
    procedure OnActivityCreateHandler(Activity: JActivity; SavedState: JBundle); override;
    procedure OnActivityStartHandler(Activity: JActivity); override;
    procedure OnActivityResumeHandler(Activity: JActivity); override;
    procedure OnActivityPauseHandler(Activity: JActivity); override;
    procedure OnActivityStopHandler(Activity: JActivity); override;
    procedure OnActivityDestroyHandler(Activity: JActivity); override;
    procedure OnActivityConfigurationChangedHandler(Activity: JActivity); override;


    // View lifecycle handlers
    procedure OnViewAttached(View: JView);
    procedure OnViewDetached(View: JView);
    procedure OnWindowFocusChange(HasFocus: Boolean);
  public
    constructor Create; override;
  end;

var
  Screen: TScreen;

implementation

uses
  System.SysUtils, Androidapi.Helpers;

{ TScreen }


constructor TScreen.Create;
var
  Manager: TPscLifecycleManager;
begin

  // Direct assignment for immediate handlers
  // Pre/Post handlers (these are not available as virtual methods, only direct assignment)
  Manager := TPisces.GetLifecycleManager;
  Manager.ActivityLifecycleListener.OnPreCreated :=
    procedure(Activity: JActivity; SavedState: JBundle)
    begin
      TPscUtils.Log('*** ACTIVITY PRE-CREATE ***', 'ActivityLifecycle', TLogger.Warning, Self);
    end;

  Manager.ActivityLifecycleListener.OnPostCreated :=
    procedure(Activity: JActivity; SavedState: JBundle)
    begin
      TPscUtils.Log('*** ACTIVITY POST-CREATE ***', 'ActivityLifecycle', TLogger.Warning, Self);
    end;

  inherited;
end;

procedure TScreen.OnActivityConfigurationChangedHandler(Activity: JActivity);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY CONFIGURATION CHANGED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Configuration Changed!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.OnActivityCreateHandler(Activity: JActivity; SavedState: JBundle);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY CREATED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Created!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.OnActivityStartHandler(Activity: JActivity);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY STARTED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Started!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.OnActivityResumeHandler(Activity: JActivity);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY RESUMED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Resumed!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.OnActivityPauseHandler(Activity: JActivity);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY PAUSED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Paused!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.OnActivityStopHandler(Activity: JActivity);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY STOPPED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.OnActivityDestroyHandler(Activity: JActivity);
begin
  inherited;
  TPscUtils.Log('*** ACTIVITY DESTROYED! ***', 'ActivityLifecycle', TLogger.Error, Self);
end;

procedure TScreen.OnViewAttached(View: JView);
begin
  inherited;
  TPscUtils.Log('*** SCREEN VIEW IS ATTACHED TO WINDOW! ***', 'ViewLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.OnViewDetached(View: JView);
begin
  inherited;
  TPscUtils.Log('*** SCREEN VIEW IS DETACHED FROM WINDOW ***', 'ViewLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.OnWindowFocusChange(HasFocus: Boolean);
begin
  inherited;
  if HasFocus then
    TPscUtils.Log('*** WINDOW GAINED FOCUS ***', 'WindowFocus', TLogger.Warning, Self)
  else
    TPscUtils.Log('*** WINDOW LOST FOCUS ***', 'WindowFocus', TLogger.Warning, Self);
end;

{ TText }

procedure TText.AfterShow;
begin
  inherited;
  JTextView(AndroidView).setText(StrToJCharSequence(
    'This example shows how to utilize lifecycle events with the TPisces class'));
end;

procedure TText.OnViewAttachedToWindowHandler(AView: JView);
begin
  TPscUtils.Log('Text view attached to window', 'TextLifecycle', TLogger.Warning, Self);
end;

procedure TText.OnViewDetachedFromWindowHandler(AView: JView);
begin
  TPscUtils.Log('Text view detached from window', 'TextLifecycle', TLogger.Warning, Self);
end;

initialization
  Screen := TScreen.Create;
  Screen.Show;

finalization
  Screen.Free;

end.


