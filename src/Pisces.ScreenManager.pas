unit Pisces.ScreenManager;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Androidapi.JNIBridge,
  Androidapi.Helpers,
  Androidapi.JNI.Util,
  Androidapi.JNI.GraphicsContentViewText,
  Pisces.Types,
  Pisces.Registry,
  Pisces.Utils,
  Pisces.Base,
  Pisces.JNI.Extensions;

type

  TPscScreenManager = class
  private
    class var FInstance: TPscScreenManager;
    // Stack of screen GUIDs
    var FScreenStack: TStack<String>;
    var FCurrentScreenGUID: String;
    constructor Create;

  private
    function FindScreenGUIDByName(const ScreenName: String): String;

  public
    class function Instance: TPscScreenManager;
    class destructor Destroy;
    destructor Destroy; override;

    // Simple navigation API - uses ViewsRegistry to find screens
    procedure SetInitialScreen(const ScreenGUID: String);
    procedure SetInitialScreenByName(const ScreenName: String);
    procedure Push(const ScreenGUID: String);
    procedure PushByName(const ScreenName: String);
    procedure Pop;
    procedure PopToRoot;

    property CurrentScreenGUID: String read FCurrentScreenGUID;
  end;

implementation

function GetInterpolatorForEasing(AEasing: TEasingType): JTimeInterpolator;
begin
  Result := nil;
  case AEasing of
    TEasingType.Linear:
      Result := TJLinearInterpolator.JavaClass.init;
    TEasingType.AccelerateDecelerate:
      Result := TJAccelerateDecelerateInterpolator.JavaClass.init;
    TEasingType.Accelerate:
      Result := TJAccelerateInterpolator.JavaClass.init;
    TEasingType.Decelerate:
      Result := TJDecelerateInterpolator.JavaClass.init;
    TEasingType.Anticipate:
      Result := TJAnticipateInterpolator.JavaClass.init;
    TEasingType.Overshoot:
      Result := TJOvershootInterpolator.JavaClass.init;
    TEasingType.AnticipateOvershoot:
      Result := TJAnticipateOvershootInterpolator.JavaClass.init;
    TEasingType.Bounce:
      Result := TJBounceInterpolator.JavaClass.init;
  end;
end;

function GetScreenWidth: Integer;
var
  DisplayMetrics: JDisplayMetrics;
begin
  DisplayMetrics := TAndroidHelper.Context.getResources.getDisplayMetrics;
  Result := DisplayMetrics.widthPixels;
end;

function GetScreenHeight: Integer;
var
  DisplayMetrics: JDisplayMetrics;
begin
  DisplayMetrics := TAndroidHelper.Context.getResources.getDisplayMetrics;
  Result := DisplayMetrics.heightPixels;
end;

procedure PrepareViewForTransition(AView: JView; AConfig: TPscTransitionConfig; IsEnter: Boolean);
var
  Width, Height: Integer;
begin
  if AConfig.TransitionType = TTransitionType.None then
    Exit;

  // Use view dimensions if available, otherwise use screen dimensions
  Width := AView.getWidth;
  Height := AView.getHeight;
  if Width = 0 then
    Width := GetScreenWidth;
  if Height = 0 then
    Height := GetScreenHeight;

  TPscUtils.Log(Format('PrepareViewForTransition: Type=%d, IsEnter=%s, Width=%d, Height=%d',
    [Ord(AConfig.TransitionType), BoolToStr(IsEnter, True), Width, Height]),
    'PrepareViewForTransition', TLogger.Info, 'TPscScreenManager');

  case AConfig.TransitionType of
    TTransitionType.Fade:
      if IsEnter then AView.setAlpha(0.0);

    TTransitionType.SlideLeft:
      if IsEnter then AView.setTranslationX(-Width);

    TTransitionType.SlideRight:
      if IsEnter then AView.setTranslationX(Width);

    TTransitionType.SlideUp:
      if IsEnter then AView.setTranslationY(-Height);

    TTransitionType.SlideDown:
      if IsEnter then AView.setTranslationY(Height);

    TTransitionType.ScaleCenter:
      begin
        AView.setPivotX(Width / 2);
        AView.setPivotY(Height / 2);
        if IsEnter then
        begin
          AView.setScaleX(0);
          AView.setScaleY(0);
        end;
      end;

    TTransitionType.FlipHorizontal:
      begin
        AView.setPivotX(Width / 2);
        if IsEnter then AView.setRotationY(-90);
      end;

    TTransitionType.FlipVertical:
      begin
        AView.setPivotY(Height / 2);
        if IsEnter then AView.setRotationX(-90);
      end;
  end;
end;

procedure ExecuteTransition(AView: JView; AConfig: TPscTransitionConfig;
  IsEnter: Boolean; OnComplete: TProc);
var
  Animator: JViewPropertyAnimator;
  AnimatorEx: JViewPropertyAnimatorEx;
  Interp: JTimeInterpolator;
  Width, Height: Integer;
begin
  if AConfig.TransitionType = TTransitionType.None then
  begin
    if Assigned(OnComplete) then
      OnComplete;
    Exit;
  end;

  // Use view dimensions if available, otherwise use screen dimensions
  Width := AView.getWidth;
  Height := AView.getHeight;
  if Width = 0 then
    Width := GetScreenWidth;
  if Height = 0 then
    Height := GetScreenHeight;

  TPscUtils.Log(Format('ExecuteTransition: Type=%d, IsEnter=%s, Width=%d, Height=%d',
    [Ord(AConfig.TransitionType), BoolToStr(IsEnter, True), Width, Height]),
    'ExecuteTransition', TLogger.Info, 'TPscScreenManager');

  Interp := GetInterpolatorForEasing(AConfig.Easing);

  Animator := AView.animate;
  Animator := Animator.setDuration(AConfig.DurationMs);

  if Interp <> nil then
  begin
    // Cast to extended interface that has setInterpolator
    AnimatorEx := TJViewPropertyAnimatorEx.Wrap((Animator as ILocalObject).GetObjectID);
    AnimatorEx.setInterpolator(Interp);
  end;

  case AConfig.TransitionType of
    TTransitionType.Fade:
      if IsEnter then
        Animator := Animator.alpha(1.0)
      else
        Animator := Animator.alpha(0.0);

    TTransitionType.SlideLeft:
      if IsEnter then
        Animator := Animator.translationX(0)
      else
        Animator := Animator.translationX(-Width);

    TTransitionType.SlideRight:
      if IsEnter then
        Animator := Animator.translationX(0)
      else
        Animator := Animator.translationX(Width);

    TTransitionType.SlideUp:
      if IsEnter then
        Animator := Animator.translationY(0)
      else
        Animator := Animator.translationY(-Height);

    TTransitionType.SlideDown:
      if IsEnter then
        Animator := Animator.translationY(0)
      else
        Animator := Animator.translationY(Height);

    TTransitionType.ScaleCenter:
      begin
        if IsEnter then
        begin
          Animator := Animator.scaleX(1.0);
          Animator := Animator.scaleY(1.0);
        end
        else
        begin
          Animator := Animator.scaleX(0);
          Animator := Animator.scaleY(0);
        end;
      end;

    TTransitionType.FlipHorizontal:
      if IsEnter then
        Animator := Animator.rotationY(0)
      else
        Animator := Animator.rotationY(90);

    TTransitionType.FlipVertical:
      if IsEnter then
        Animator := Animator.rotationX(0)
      else
        Animator := Animator.rotationX(90);
  end;

  if Assigned(OnComplete) then
    Animator := Animator.withEndAction(TPscUtils.Runnable(nil,
      procedure(V: JView)
      begin
        OnComplete;
      end));

  Animator.start;
end;

procedure ResetViewTransform(AView: JView);
begin
  AView.setTranslationX(0);
  AView.setTranslationY(0);
  AView.setScaleX(1);
  AView.setScaleY(1);
  AView.setRotationX(0);
  AView.setRotationY(0);
  AView.setAlpha(1);
end;

{ TPscScreenManager }

constructor TPscScreenManager.Create;
begin
  inherited Create;
  FScreenStack := TStack<String>.Create;
  FCurrentScreenGUID := '';
end;

destructor TPscScreenManager.Destroy;
begin
  if Assigned(FScreenStack) then
    FScreenStack.Free;
  inherited;
end;

class destructor TPscScreenManager.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

class function TPscScreenManager.Instance: TPscScreenManager;
begin
  if not Assigned(FInstance) then
    FInstance := TPscScreenManager.Create;
  Result := FInstance;
end;

procedure TPscScreenManager.Push(const ScreenGUID: String);
var
  CurrentView, NewView: JView;
  RegInfo, NewRegInfo: TViewRegistrationInfo;
  CurrentInstance, NewInstance: TPisces;
  CurrentTransitions, NewTransitions: TPscScreenTransitions;
begin
  TPscUtils.Log(Format('Pushing screen with GUID: %s', [ScreenGUID]), 'Push', TLogger.Info, 'TPscScreenManager');

  // Check if screen exists in registry
  if not ViewsRegistry.TryGetValue(ScreenGUID, NewRegInfo) then begin
    TPscUtils.Log(Format('Screen GUID not found in registry: %s', [ScreenGUID]), 'Push', TLogger.Error, 'TPscScreenManager');
    Exit;
  end;

  NewView := NewRegInfo.View;
  NewInstance := TPisces(NewRegInfo.Instance);
  TPscUtils.Log(Format('Found screen: %s', [NewRegInfo.ViewName]), 'Push', TLogger.Info, 'TPscScreenManager');

  // Get transition configurations
  if Assigned(NewInstance) then
    NewTransitions := NewInstance.ScreenTransitions
  else
    NewTransitions := TPscScreenTransitions.Default;

  // Hide current screen if exists
  if FCurrentScreenGUID <> '' then begin
    TPscUtils.Log(Format('Hiding current screen: %s', [FCurrentScreenGUID]), 'Push', TLogger.Info, 'TPscScreenManager');
    if ViewsRegistry.TryGetValue(FCurrentScreenGUID, RegInfo) then begin
      CurrentView := RegInfo.View;
      CurrentInstance := TPisces(RegInfo.Instance);
      TPscUtils.Log(Format('Current screen name: %s', [RegInfo.ViewName]), 'Push', TLogger.Info, 'TPscScreenManager');

      // Get current screen's exit transition
      if Assigned(CurrentInstance) then
        CurrentTransitions := CurrentInstance.ScreenTransitions
      else
        CurrentTransitions := TPscScreenTransitions.Default;

      // Call DoHide lifecycle method on current screen
      if Assigned(CurrentInstance) then
        CurrentInstance.DoHide;

      // Execute exit transition
      ExecuteTransition(CurrentView, CurrentTransitions.ExitTransition, False,
        procedure
        begin
          CurrentView.setVisibility(TJView.JavaClass.GONE);
          ResetViewTransform(CurrentView);
        end);

      TPscUtils.Log('Current screen hidden with transition', 'Push', TLogger.Info, 'TPscScreenManager');
    end;
  end;

  // Push to stack
  if FCurrentScreenGUID <> '' then
    FScreenStack.Push(FCurrentScreenGUID);

  FCurrentScreenGUID := ScreenGUID;

  // Show new screen with enter transition
  TPscUtils.Log('Setting new screen visible', 'Push', TLogger.Info, 'TPscScreenManager');
  PrepareViewForTransition(NewView, NewTransitions.EnterTransition, True);
  NewView.setVisibility(TJView.JavaClass.VISIBLE);
  NewView.bringToFront;

  ExecuteTransition(NewView, NewTransitions.EnterTransition, True,
    procedure
    begin
      // Call DoShow lifecycle method on new screen after transition completes
      if Assigned(NewInstance) then
        NewInstance.DoShow;
    end);

  TPscUtils.Log('Screen pushed successfully with transition', 'Push', TLogger.Info, 'TPscScreenManager');
end;

procedure TPscScreenManager.Pop;
var
  CurrentView, PreviousView: JView;
  PreviousGUID: String;
  RegInfo, PreviousRegInfo: TViewRegistrationInfo;
  CurrentInstance, PreviousInstance: TPisces;
  CurrentTransitions, PreviousTransitions: TPscScreenTransitions;
begin
  if FScreenStack.Count = 0 then
  begin
    TPscUtils.Log('Cannot pop - stack is empty', 'Pop', TLogger.Warning, 'TPscScreenManager');
    Exit;
  end;

  TPscUtils.Log('Popping current screen', 'Pop', TLogger.Info, 'TPscScreenManager');

  // Get previous screen from stack
  PreviousGUID := FScreenStack.Pop;

  // Hide current screen with PopExitTransition
  if ViewsRegistry.TryGetValue(FCurrentScreenGUID, RegInfo) then
  begin
    CurrentView := RegInfo.View;
    CurrentInstance := TPisces(RegInfo.Instance);

    // Get current screen's pop exit transition
    if Assigned(CurrentInstance) then
      CurrentTransitions := CurrentInstance.ScreenTransitions
    else
      CurrentTransitions := TPscScreenTransitions.Default;

    // Call DoHide lifecycle method on current screen
    if Assigned(CurrentInstance) then
      CurrentInstance.DoHide;

    // Execute pop exit transition
    ExecuteTransition(CurrentView, CurrentTransitions.PopExitTransition, False,
      procedure
      begin
        CurrentView.setVisibility(TJView.JavaClass.GONE);
        ResetViewTransform(CurrentView);
      end);
  end;

  // Show previous screen with PopEnterTransition
  if ViewsRegistry.TryGetValue(PreviousGUID, PreviousRegInfo) then
  begin
    PreviousView := PreviousRegInfo.View;
    PreviousInstance := TPisces(PreviousRegInfo.Instance);

    // Get previous screen's pop enter transition
    if Assigned(PreviousInstance) then
      PreviousTransitions := PreviousInstance.ScreenTransitions
    else
      PreviousTransitions := TPscScreenTransitions.Default;

    PrepareViewForTransition(PreviousView, PreviousTransitions.PopEnterTransition, True);
    PreviousView.setVisibility(TJView.JavaClass.VISIBLE);

    ExecuteTransition(PreviousView, PreviousTransitions.PopEnterTransition, True,
      procedure
      begin
        // Call DoShow lifecycle method on previous screen after transition
        if Assigned(PreviousInstance) then
          PreviousInstance.DoShow;
      end);
  end;

  FCurrentScreenGUID := PreviousGUID;

  TPscUtils.Log('Screen popped successfully with transition', 'Pop', TLogger.Info, 'TPscScreenManager');
end;

procedure TPscScreenManager.PopToRoot;
var
  RootGUID: String;
begin
  if FScreenStack.Count = 0 then
    Exit;

  TPscUtils.Log('Popping to root screen', 'PopToRoot', TLogger.Info, 'TPscScreenManager');

  // Get root screen (first one in stack)
  RootGUID := FScreenStack.ToArray[FScreenStack.Count - 1];

  // Clear stack
  FScreenStack.Clear;

  // Pop to root
  FScreenStack.Push(RootGUID);
  Pop;

  TPscUtils.Log('Popped to root successfully', 'PopToRoot', TLogger.Info, 'TPscScreenManager');
end;

function TPscScreenManager.FindScreenGUIDByName(const ScreenName: String): String;
var
  RegInfo: TViewRegistrationInfo;
begin
  Result := '';
  for RegInfo in ViewsRegistry.Values do
  begin
    if SameText(RegInfo.ViewName, ScreenName) then
    begin
      Result := RegInfo.ViewGUID;
      Exit;
    end;
  end;
end;

procedure TPscScreenManager.SetInitialScreen(const ScreenGUID: String);
begin
  FCurrentScreenGUID := ScreenGUID;
  TPscUtils.Log(Format('Initial screen set to GUID: %s', [ScreenGUID]), 'SetInitialScreen', TLogger.Info, 'TPscScreenManager');
end;

procedure TPscScreenManager.SetInitialScreenByName(const ScreenName: String);
var
  GUID: String;
begin
  GUID := FindScreenGUIDByName(ScreenName);
  if GUID <> '' then
  begin
    SetInitialScreen(GUID);
    TPscUtils.Log(Format('Initial screen set to: %s', [ScreenName]), 'SetInitialScreenByName', TLogger.Info, 'TPscScreenManager');
  end
  else
    TPscUtils.Log(Format('Screen not found: %s', [ScreenName]), 'SetInitialScreenByName', TLogger.Error, 'TPscScreenManager');
end;

procedure TPscScreenManager.PushByName(const ScreenName: String);
var
  GUID: String;
begin
  GUID := FindScreenGUIDByName(ScreenName);
  if GUID <> '' then
    Push(GUID)
  else
    TPscUtils.Log(Format('Screen not found: %s', [ScreenName]), 'PushByName', TLogger.Error, 'TPscScreenManager');
end;

end.
