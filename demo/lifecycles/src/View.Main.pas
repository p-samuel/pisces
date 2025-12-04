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
    constructor Create; override;
    procedure AfterCreate; override;
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
    procedure ShowAlert(AView: JView);
    procedure ShowLongClick(AView: JView);

    // Activity lifecycle handlers
    procedure ActivityCreate(Activity: JActivity; SavedState: JBundle);
    procedure ActivityStart(Activity: JActivity);
    procedure ActivityResume(Activity: JActivity);
    procedure ActivityPause(Activity: JActivity);
    procedure ActivityStop(Activity: JActivity);
    procedure ActivityDestroy(Activity: JActivity);

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
  // Regular event handlers
  OnClick := ShowAlert;
  OnLongClick := ShowLongClick;

  TPscUtils.Log('Setting up activity lifecycle handlers using property approach', 'Create', TLogger.Info, Self);

  // Option 1: Property Assignment (Clean and Simple) ***
  OnActivityCreate := ActivityCreate;
  OnActivityStart := ActivityStart;
  OnActivityResume := ActivityResume;
  OnActivityPause := ActivityPause;
  OnActivityStop := ActivityStop;
  OnActivityDestroy := ActivityDestroy;

  // Option 2:  Direct Assignment (Advanced Control) ***
  // You can also do direct assignment for immediate handlers
  // Pre/Post handlers (these are not available as properties, only direct assignment)
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

  // Setup view lifecycle
  OnViewAttachedToWindow := OnViewAttached;
  OnViewDetachedFromWindow := OnViewDetached;
  OnWindowFocusChanged := OnWindowFocusChange;

  inherited; // This will call BuildScreen and assign the handlers
end;

procedure TScreen.ActivityCreate(Activity: JActivity; SavedState: JBundle);
begin
  TPscUtils.Log('*** ACTIVITY CREATED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Started!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.ActivityStart(Activity: JActivity);
begin
  TPscUtils.Log('*** ACTIVITY STARTED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.ActivityResume(Activity: JActivity);
begin
  TPscUtils.Log('*** ACTIVITY RESUMED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Resumed!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.ActivityPause(Activity: JActivity);
begin
  TPscUtils.Log('*** ACTIVITY PAUSED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
  TPscUtils.Toast('App Paused!', TJToast.JavaClass.LENGTH_SHORT);
end;

procedure TScreen.ActivityStop(Activity: JActivity);
begin
  TPscUtils.Log('*** ACTIVITY STOPPED! ***', 'ActivityLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.ActivityDestroy(Activity: JActivity);
begin
  TPscUtils.Log('*** ACTIVITY DESTROYED! ***', 'ActivityLifecycle', TLogger.Error, Self);
end;

procedure TScreen.OnViewAttached(View: JView);
begin
  TPscUtils.Log('*** SCREEN VIEW IS ATTACHED TO WINDOW! ***', 'ViewLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.OnViewDetached(View: JView);
begin
  TPscUtils.Log('*** SCREEN VIEW IS DETACHED FROM WINDOW ***', 'ViewLifecycle', TLogger.Warning, Self);
end;

procedure TScreen.OnWindowFocusChange(HasFocus: Boolean);
begin
  if HasFocus then
    TPscUtils.Log('*** WINDOW GAINED FOCUS ***', 'WindowFocus', TLogger.Warning, Self)
  else
    TPscUtils.Log('*** WINDOW LOST FOCUS ***', 'WindowFocus', TLogger.Warning, Self);
end;

procedure TScreen.ShowAlert(AView: JView);
begin
  TPscUtils.Toast('You clicked the main screen', TJToast.JavaClass.LENGTH_SHORT);
  TPscUtils.Log('You clicked the main screen', 'ShowAlert', TLogger.Warning, Self);
end;

procedure TScreen.ShowLongClick(AView: JView);
var
  ScreenHeight: Integer;
  TextViewAndroid: JView;
begin
  TPscUtils.Toast('You long-clicked the main screen - Watch the ninja fruit effect!', TJToast.JavaClass.LENGTH_LONG);
  TPscUtils.Log('You long-clicked the main screen', 'ShowLongClick', TLogger.Fatal, Self);

  // Get the text view's Android view for animation
  if FText <> nil then
  begin
    TextViewAndroid := FText.AndroidView;

    // Get screen height for the slide down effect
    ScreenHeight := TAndroidHelper.Activity.getWindow.getDecorView.getHeight;

    // Create the ninja fruit effect: rotate 360°, slide down, scale up, and fade out
    TPscUtils.Animate
      .FromView(TextViewAndroid)
      .Rotation(0, 1360)                    // Spin 360 degrees
      //.TranslateY(0, ScreenHeight)         // Slide all the way down
      .Scale(1.0, 100)                       // Scale up to 2x
      .Alpha(1.0, 0.0)                     // Fade out completely
      .Duration(700)                      // All in 1 second
      .WithLayer                           // Use hardware acceleration
      .WithStartAction(
        procedure
        begin
          TPscUtils.Log('🥷 Ninja fruit effect started!', 'Animation', TLogger.Warning, Self);
        end)
      .WithEndAction(
        procedure
        begin
          TPscUtils.Log('🍎 Fruit sliced and disappeared!', 'Animation', TLogger.Warning, Self);
          TPscUtils.Toast('Ninja fruit effect completed!', TJToast.JavaClass.LENGTH_SHORT);

          // Reset the view to its original state after animation
          TextViewAndroid.setAlpha(1.0);
          TextViewAndroid.setScaleX(1.0);
          TextViewAndroid.setScaleY(1.0);
          TextViewAndroid.setRotation(0);
          TextViewAndroid.setTranslationX(0);
          TextViewAndroid.setTranslationY(0);
        end)
      .Run;
  end;
end;

{ TText }

procedure TText.AfterCreate;
begin
  inherited;
  JTextView(AndroidView).setText(StrToJCharSequence(
    'This example shows how to utilize lifecycle events with the TPisces class'));
end;

constructor TText.Create;
begin

  // Setup view lifecycle for the text component
  OnViewAttachedToWindow := procedure(View: JView)
    begin
      TPscUtils.Log('Text view attached to window', 'TextLifecycle', TLogger.Warning, Self);
    end;

  OnViewDetachedFromWindow := procedure(View: JView)
    begin
      TPscUtils.Log('Text view detached from window', 'TextLifecycle', TLogger.Warning, Self);
    end;

  inherited;
end;

initialization
  Screen := TScreen.Create;
  Screen.Show;

finalization
  Screen.Free;

end.


