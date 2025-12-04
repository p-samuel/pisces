unit Pisces.Lifecycle;

{$M+}

interface

uses
  System.SysUtils, Androidapi.JNI.App, Androidapi.JNI.Os,
  Androidapi.JNI.GraphicsContentViewText, Androidapi.Helpers,
  FMX.Helpers.Android, Androidapi.JNIBridge;

type
  // Main Activity lifecycle
  TPscActivityLifecycleListener = class(TJavaLocal, JApplication_ActivityLifecycleCallbacks)
    private
      FOnCreate: TProc<JActivity, JBundle>;
      FOnStart: TProc<JActivity>;
      FOnResume: TProc<JActivity>;
      FOnPause: TProc<JActivity>;
      FOnStop: TProc<JActivity>;
      FOnDestroy: TProc<JActivity>;
      FOnRestart: TProc<JActivity>;
      FOnSaveInstanceState: TProc<JActivity, JBundle>;
      FOnBackPressed: TProc<JActivity>;
      // Pre/Post event handlers (optional)
      FOnPreCreated: TProc<JActivity, JBundle>;
      FOnPostCreated: TProc<JActivity, JBundle>;
      FOnPreStarted: TProc<JActivity>;
      FOnPostStarted: TProc<JActivity>;
      FOnPreResumed: TProc<JActivity>;
      FOnPostResumed: TProc<JActivity>;
      FOnPrePaused: TProc<JActivity>;
      FOnPostPaused: TProc<JActivity>;
      FOnPreStopped: TProc<JActivity>;
      FOnPostStopped: TProc<JActivity>;
      FOnPreDestroyed: TProc<JActivity>;
      FOnPostDestroyed: TProc<JActivity>;
      FOnPreSaveInstanceState: TProc<JActivity, JBundle>;
      FOnPostSaveInstanceState: TProc<JActivity, JBundle>;
      FOnConfigurationChanged: TProc<JActivity>;

    public
      constructor Create;

      // Required interface methods
      procedure onActivityCreated(activity: JActivity; savedInstanceState: JBundle); cdecl;
      procedure onActivityStarted(activity: JActivity); cdecl;
      procedure onActivityResumed(activity: JActivity); cdecl;
      procedure onActivityPaused(activity: JActivity); cdecl;
      procedure onActivityStopped(activity: JActivity); cdecl;
      procedure onActivityDestroyed(activity: JActivity); cdecl;
      procedure onActivitySaveInstanceState(activity: JActivity; outState: JBundle); cdecl;

      // Pre/Post methods (required by interface)
      procedure onActivityPreCreated(activity: JActivity; savedInstanceState: JBundle); cdecl;
      procedure onActivityPostCreated(activity: JActivity; savedInstanceState: JBundle); cdecl;
      procedure onActivityPreStarted(activity: JActivity); cdecl;
      procedure onActivityPostStarted(activity: JActivity); cdecl;
      procedure onActivityPreResumed(activity: JActivity); cdecl;
      procedure onActivityPostResumed(activity: JActivity); cdecl;
      procedure onActivityPrePaused(activity: JActivity); cdecl;
      procedure onActivityPostPaused(activity: JActivity); cdecl;
      procedure onActivityPreStopped(activity: JActivity); cdecl;
      procedure onActivityPostStopped(activity: JActivity); cdecl;
      procedure onActivityPreDestroyed(activity: JActivity); cdecl;
      procedure onActivityPostDestroyed(activity: JActivity); cdecl;
      procedure onActivityPreSaveInstanceState(activity: JActivity; outState: JBundle); cdecl;
      procedure onActivityPostSaveInstanceState(activity: JActivity; outState: JBundle); cdecl;
      procedure onActivityBackPressed(activity: JActivity); cdecl;
      procedure onActivityConfigurationChanged(activity: JActivity); cdecl;
    published
      property OnCreate: TProc<JActivity, JBundle> read FOnCreate write FOnCreate;
      property OnStart: TProc<JActivity> read FOnStart write FOnStart;
      property OnResume: TProc<JActivity> read FOnResume write FOnResume;
      property OnPause: TProc<JActivity> read FOnPause write FOnPause;
      property OnStop: TProc<JActivity> read FOnStop write FOnStop;
      property OnDestroy: TProc<JActivity> read FOnDestroy write FOnDestroy;
      property OnRestart: TProc<JActivity> read FOnRestart write FOnRestart;
      property OnSaveInstanceState: TProc<JActivity, JBundle> read FOnSaveInstanceState write FOnSaveInstanceState;

      // Optional Pre/Post properties
      property OnPreCreated: TProc<JActivity, JBundle> read FOnPreCreated write FOnPreCreated;
      property OnPostCreated: TProc<JActivity, JBundle> read FOnPostCreated write FOnPostCreated;
      property OnPreStarted: TProc<JActivity> read FOnPreStarted write FOnPreStarted;
      property OnPostStarted: TProc<JActivity> read FOnPostStarted write FOnPostStarted;
      property OnPreResumed: TProc<JActivity> read FOnPreResumed write FOnPreResumed;
      property OnPostResumed: TProc<JActivity> read FOnPostResumed write FOnPostResumed;
      property OnPrePaused: TProc<JActivity> read FOnPrePaused write FOnPrePaused;
      property OnPostPaused: TProc<JActivity> read FOnPostPaused write FOnPostPaused;
      property OnPreStopped: TProc<JActivity> read FOnPreStopped write FOnPreStopped;
      property OnPostStopped: TProc<JActivity> read FOnPostStopped write FOnPostStopped;
      property OnPreDestroyed: TProc<JActivity> read FOnPreDestroyed write FOnPreDestroyed;
      property OnPostDestroyed: TProc<JActivity> read FOnPostDestroyed write FOnPostDestroyed;
      property OnPreSaveInstanceState: TProc<JActivity, JBundle> read FOnPreSaveInstanceState write FOnPreSaveInstanceState;
      property OnPostSaveInstanceState: TProc<JActivity, JBundle> read FOnPostSaveInstanceState write FOnPostSaveInstanceState;
      property OnBackPressed: TProc<JActivity> read FOnBackPressed write FOnBackPressed;
      property OnConfigurationChanged: TProc<JActivity> read FOnConfigurationChanged write FOnConfigurationChanged;
    end;

  // Individual view lifecycle events
  TPscViewLifecycleListener = class(TJavaLocal, JView_OnAttachStateChangeListener)
  private
    FOnAttachedToWindow: TProc<JView>;
    FOnDetachedFromWindow: TProc<JView>;
  public
    constructor Create;
    procedure onViewAttachedToWindow(v: JView); cdecl;
    procedure onViewDetachedFromWindow(v: JView); cdecl;
  published
    property OnAttachedToWindow: TProc<JView> read FOnAttachedToWindow write FOnAttachedToWindow;
    property OnDetachedFromWindow: TProc<JView> read FOnDetachedFromWindow write FOnDetachedFromWindow;
  end;

  // Window focus changes
  TPscWindowFocusChangeListener = class(TJavaLocal, JViewTreeObserver_OnWindowFocusChangeListener)
  private
    FOnWindowFocusChanged: TProc<Boolean>;
  public
    constructor Create;
    procedure onWindowFocusChanged(hasFocus: Boolean); cdecl;
  published
    property _OnWindowFocusChanged: TProc<Boolean> read FOnWindowFocusChanged write FOnWindowFocusChanged;
  end;

  TPscLifecycleManager = class
  private
    FActivityLifecycleListener: TPscActivityLifecycleListener;
    FIsRegistered: Boolean;
    class var FInstance: TPscLifecycleManager;
  public
    constructor Create;
    destructor Destroy; override;
    procedure RegisterLifecycleCallbacks;
    procedure UnregisterLifecycleCallbacks;
    property ActivityLifecycleListener: TPscActivityLifecycleListener read FActivityLifecycleListener;
    class function Instance: TPscLifecycleManager;
    class procedure DestroyInstance;
  end;

implementation

uses
  Pisces.Utils, Pisces.Types;

{ TPscActivityLifecycleListener }

constructor TPscActivityLifecycleListener.Create;
begin
  inherited Create;
end;

// Main lifecycle methods
procedure TPscActivityLifecycleListener.onActivityCreated(activity: JActivity; savedInstanceState: JBundle);
begin
  if Assigned(FOnCreate) then
    FOnCreate(activity, savedInstanceState);
end;

procedure TPscActivityLifecycleListener.onActivityStarted(activity: JActivity);
begin
  if Assigned(FOnStart) then
    FOnStart(activity);
end;

procedure TPscActivityLifecycleListener.onActivityResumed(activity: JActivity);
begin
  if Assigned(FOnResume) then
    FOnResume(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPaused(activity: JActivity);
begin
  if Assigned(FOnPause) then
    FOnPause(activity);
end;

procedure TPscActivityLifecycleListener.onActivityStopped(activity: JActivity);
begin
  if Assigned(FOnStop) then
    FOnStop(activity);
end;

procedure TPscActivityLifecycleListener.onActivityDestroyed(activity: JActivity);
begin
  if Assigned(FOnDestroy) then
    FOnDestroy(activity);
end;

procedure TPscActivityLifecycleListener.onActivitySaveInstanceState(activity: JActivity; outState: JBundle);
begin
  if Assigned(FOnSaveInstanceState) then
    FOnSaveInstanceState(activity, outState);
end;

// Pre methods
procedure TPscActivityLifecycleListener.onActivityPreCreated(activity: JActivity; savedInstanceState: JBundle);
begin
  if Assigned(FOnPreCreated) then
    FOnPreCreated(activity, savedInstanceState);
end;

procedure TPscActivityLifecycleListener.onActivityPreStarted(activity: JActivity);
begin
  if Assigned(FOnPreStarted) then
    FOnPreStarted(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPreResumed(activity: JActivity);
begin
  if Assigned(FOnPreResumed) then
    FOnPreResumed(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPrePaused(activity: JActivity);
begin
  if Assigned(FOnPrePaused) then
    FOnPrePaused(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPreStopped(activity: JActivity);
begin
  if Assigned(FOnPreStopped) then
    FOnPreStopped(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPreDestroyed(activity: JActivity);
begin
  if Assigned(FOnPreDestroyed) then
    FOnPreDestroyed(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPreSaveInstanceState(activity: JActivity; outState: JBundle);
begin
  if Assigned(FOnPreSaveInstanceState) then
    FOnPreSaveInstanceState(activity, outState);
end;

// Post methods
procedure TPscActivityLifecycleListener.onActivityPostCreated(activity: JActivity; savedInstanceState: JBundle);
begin
  if Assigned(FOnPostCreated) then
    FOnPostCreated(activity, savedInstanceState);
end;

procedure TPscActivityLifecycleListener.onActivityPostStarted(activity: JActivity);
begin
  if Assigned(FOnPostStarted) then
    FOnPostStarted(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPostResumed(activity: JActivity);
begin
  if Assigned(FOnPostResumed) then
    FOnPostResumed(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPostPaused(activity: JActivity);
begin
  if Assigned(FOnPostPaused) then
    FOnPostPaused(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPostStopped(activity: JActivity);
begin
  if Assigned(FOnPostStopped) then
    FOnPostStopped(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPostDestroyed(activity: JActivity);
begin
  if Assigned(FOnPostDestroyed) then
    FOnPostDestroyed(activity);
end;

procedure TPscActivityLifecycleListener.onActivityPostSaveInstanceState(activity: JActivity; outState: JBundle);
begin
  if Assigned(FOnPostSaveInstanceState) then
    FOnPostSaveInstanceState(activity, outState);
end;

procedure TPscActivityLifecycleListener.onActivityBackPressed(activity: JActivity);
begin
  if Assigned(FOnBackPressed) then
    FOnBackPressed(activity);
end;

procedure TPscActivityLifecycleListener.onActivityConfigurationChanged(activity: JActivity);
begin
  if Assigned(FOnConfigurationChanged) then
    FOnConfigurationChanged(activity);
end;

{ TPscViewLifecycleListener }

constructor TPscViewLifecycleListener.Create;
begin
  inherited Create;
end;

procedure TPscViewLifecycleListener.onViewAttachedToWindow(v: JView);
begin
  if Assigned(FOnAttachedToWindow) then
    FOnAttachedToWindow(v);
end;

procedure TPscViewLifecycleListener.onViewDetachedFromWindow(v: JView);
begin
  if Assigned(FOnDetachedFromWindow) then
    FOnDetachedFromWindow(v);
end;

{ TPscWindowFocusChangeListener }

constructor TPscWindowFocusChangeListener.Create;
begin
  inherited Create;
end;

procedure TPscWindowFocusChangeListener.onWindowFocusChanged(hasFocus: Boolean);
begin
  if Assigned(FOnWindowFocusChanged) then
    FOnWindowFocusChanged(hasFocus);
end;

{ TPscLifecycleManager }

constructor TPscLifecycleManager.Create;
begin
  inherited Create;
  FActivityLifecycleListener := TPscActivityLifecycleListener.Create;
  FIsRegistered := False;
end;

destructor TPscLifecycleManager.Destroy;
begin
  UnregisterLifecycleCallbacks;
  FActivityLifecycleListener.Free;
  inherited Destroy;
end;

procedure TPscLifecycleManager.RegisterLifecycleCallbacks;
var
  Application: JApplication;
begin
  if not FIsRegistered then begin
    try
      Application := TJApplication.Wrap(TAndroidHelper.Context.getApplicationContext);
      if Assigned(Application) then
      begin
        Application.registerActivityLifecycleCallbacks(FActivityLifecycleListener);
        FIsRegistered := True;
        TPscUtils.Log('Activity lifecycle callbacks registered successfully', 'LifecycleManager', TLogger.Info, Self);
      end;
    except
      on E: Exception do
        TPscUtils.Log('Failed to register lifecycle callbacks: ' + E.Message, 'LifecycleManager', TLogger.Error, Self);
    end;
  end;
end;

procedure TPscLifecycleManager.UnregisterLifecycleCallbacks;
var
  Application: JApplication;
begin
  if FIsRegistered then
  begin
    try
      Application := TJApplication.Wrap(TAndroidHelper.Context.getApplicationContext);
      if Assigned(Application) then
      begin
        Application.unregisterActivityLifecycleCallbacks(FActivityLifecycleListener);
        FIsRegistered := False;
      TPscUtils.Log('Activity lifecycle callbacks unregistered successfully', 'LifecycleManager', TLogger.Info, Self);
      end;
    except
      on E: Exception do
        TPscUtils.Log('Failed to unregister lifecycle callbacks: ' + E.Message, 'LifecycleManager', TLogger.Error, Self);
    end;
  end;
end;

class function TPscLifecycleManager.Instance: TPscLifecycleManager;
begin
  if not Assigned(FInstance) then
    FInstance := TPscLifecycleManager.Create;
  Result := FInstance;
end;

class procedure TPscLifecycleManager.DestroyInstance;
begin
  if Assigned(FInstance) then
  begin
    FInstance.Free;
    FInstance := nil;
  end;
end;

end.


