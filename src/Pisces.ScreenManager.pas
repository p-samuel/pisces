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
  TPscScreenManager = class;

  TPscInteractivePopController = class
  private
    FScreenManager: TPscScreenManager;
    FConfig: TPscInteractivePopConfig;
    FState: TPscInteractivePopState;
    FCurrentView: JView;
    FPreviousView: JView;
    FCurrentTransitions: TPscScreenTransitions;
    FPreviousTransitions: TPscScreenTransitions;
    FIsActive: Boolean;
    FPreviousGUID: String;
  public
    constructor Create(AScreenManager: TPscScreenManager);
    procedure OnGestureBegin(const State: TPscInteractivePopState);
    procedure OnGestureUpdate(const State: TPscInteractivePopState);
    procedure OnGestureEnd(const State: TPscInteractivePopState);
    procedure OnGestureCancel;
    procedure ApplyTransitionProgress(Progress: Single);
    procedure CommitPop;
    procedure CancelPop;
    property Config: TPscInteractivePopConfig read FConfig write FConfig;
    property IsActive: Boolean read FIsActive;
  end;

  TPscScreenManager = class
  private
    class var FInstance: TPscScreenManager;
    // Stack of screen GUIDs
    var FScreenStack: TStack<String>;
    var FCurrentScreenGUID: String;
    var FInteractivePopController: TPscInteractivePopController;
    var FInteractivePopConfig: TPscInteractivePopConfig;
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

    // Interactive pop API
    procedure BeginInteractivePop(const State: TPscInteractivePopState);
    procedure UpdateInteractivePop(const State: TPscInteractivePopState);
    procedure EndInteractivePop(const State: TPscInteractivePopState);
    procedure CancelInteractivePop;
    function CanInteractivePop: Boolean;
    procedure FinishInteractivePop;

    property CurrentScreenGUID: String read FCurrentScreenGUID;
    property InteractivePopConfig: TPscInteractivePopConfig read FInteractivePopConfig write FInteractivePopConfig;
    property InteractivePopController: TPscInteractivePopController read FInteractivePopController;
  end;

implementation

uses
  System.Math;

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

procedure CancelViewAnimations(AView: JView);
begin
  // Cancel any running ViewPropertyAnimator animations
  AView.animate.cancel;
end;

// Animate from current position to end state (for interactive pop commit/cancel)
procedure AnimateTransitionToEnd(AView: JView; AConfig: TPscTransitionConfig;
  IsEnter: Boolean; DurationMs: Integer; OnComplete: TProc);
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

  Width := AView.getWidth;
  Height := AView.getHeight;
  if Width = 0 then Width := GetScreenWidth;
  if Height = 0 then Height := GetScreenHeight;

  Interp := GetInterpolatorForEasing(AConfig.Easing);

  Animator := AView.animate;
  Animator := Animator.setDuration(DurationMs);

  if Interp <> nil then
  begin
    AnimatorEx := TJViewPropertyAnimatorEx.Wrap((Animator as ILocalObject).GetObjectID);
    AnimatorEx.setInterpolator(Interp);
  end;

  // Animate to final position (progress = 1.0 for enter/exit)
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

// Animate from current position back to start state (for interactive pop cancel)
procedure AnimateTransitionToStart(AView: JView; AConfig: TPscTransitionConfig;
  IsEnter: Boolean; DurationMs: Integer; OnComplete: TProc);
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

  Width := AView.getWidth;
  Height := AView.getHeight;
  if Width = 0 then Width := GetScreenWidth;
  if Height = 0 then Height := GetScreenHeight;

  Interp := GetInterpolatorForEasing(AConfig.Easing);

  Animator := AView.animate;
  Animator := Animator.setDuration(DurationMs);

  if Interp <> nil then
  begin
    AnimatorEx := TJViewPropertyAnimatorEx.Wrap((Animator as ILocalObject).GetObjectID);
    AnimatorEx.setInterpolator(Interp);
  end;

  // Animate back to starting position (progress = 0)
  case AConfig.TransitionType of
    TTransitionType.Fade:
      if IsEnter then
        Animator := Animator.alpha(0.0)  // Enter starts at 0
      else
        Animator := Animator.alpha(1.0); // Exit starts at 1

    TTransitionType.SlideLeft:
      if IsEnter then
        Animator := Animator.translationX(-Width)  // Enter starts off-screen left
      else
        Animator := Animator.translationX(0);       // Exit starts at 0

    TTransitionType.SlideRight:
      if IsEnter then
        Animator := Animator.translationX(Width)   // Enter starts off-screen right
      else
        Animator := Animator.translationX(0);       // Exit starts at 0

    TTransitionType.SlideUp:
      if IsEnter then
        Animator := Animator.translationY(-Height)
      else
        Animator := Animator.translationY(0);

    TTransitionType.SlideDown:
      if IsEnter then
        Animator := Animator.translationY(Height)
      else
        Animator := Animator.translationY(0);

    TTransitionType.ScaleCenter:
      begin
        if IsEnter then
        begin
          Animator := Animator.scaleX(0);
          Animator := Animator.scaleY(0);
        end
        else
        begin
          Animator := Animator.scaleX(1.0);
          Animator := Animator.scaleY(1.0);
        end;
      end;

    TTransitionType.FlipHorizontal:
      if IsEnter then
        Animator := Animator.rotationY(-90)
      else
        Animator := Animator.rotationY(0);

    TTransitionType.FlipVertical:
      if IsEnter then
        Animator := Animator.rotationX(-90)
      else
        Animator := Animator.rotationX(0);
  end;

  if Assigned(OnComplete) then
    Animator := Animator.withEndAction(TPscUtils.Runnable(nil,
      procedure(V: JView)
      begin
        OnComplete;
      end));

  Animator.start;
end;

procedure ApplyTransitionProgressToView(AView: JView; AConfig: TPscTransitionConfig;
  Progress: Single; IsEnter: Boolean);
var
  Width, Height: Integer;
  Value: Single;
  TranslationValue: Single;
begin
  if AConfig.TransitionType = TTransitionType.None then Exit;

  Width := AView.getWidth;
  Height := AView.getHeight;
  if Width = 0 then Width := GetScreenWidth;
  if Height = 0 then Height := GetScreenHeight;

  // Debug logging for SlideRight specifically
  if AConfig.TransitionType = TTransitionType.SlideRight then
  begin
    if IsEnter then
      TranslationValue := Width * (1.0 - Progress)
    else
      TranslationValue := Width * Progress;
    TPscUtils.Log(Format('SlideRight: IsEnter=%s, Progress=%.2f, Width=%d, TranslationX=%.2f',
      [BoolToStr(IsEnter, True), Progress, Width, TranslationValue]),
      'ApplyTransitionProgressToView', TLogger.Info, 'TPscScreenManager');
  end;

  case AConfig.TransitionType of
    TTransitionType.Fade:
      begin
        if IsEnter then
          AView.setAlpha(Progress)
        else
          AView.setAlpha(1.0 - Progress);
      end;

    TTransitionType.SlideLeft:
      begin
        if IsEnter then
          AView.setTranslationX(-Width * (1.0 - Progress))
        else
          AView.setTranslationX(-Width * Progress);
      end;

    TTransitionType.SlideRight:
      begin
        if IsEnter then
          AView.setTranslationX(Width * (1.0 - Progress))
        else
          AView.setTranslationX(Width * Progress);
      end;

    TTransitionType.SlideUp:
      begin
        if IsEnter then
          AView.setTranslationY(-Height * (1.0 - Progress))
        else
          AView.setTranslationY(-Height * Progress);
      end;

    TTransitionType.SlideDown:
      begin
        if IsEnter then
          AView.setTranslationY(Height * (1.0 - Progress))
        else
          AView.setTranslationY(Height * Progress);
      end;

    TTransitionType.ScaleCenter:
      begin
        AView.setPivotX(Width / 2);
        AView.setPivotY(Height / 2);
        if IsEnter then
        begin
          AView.setScaleX(Progress);
          AView.setScaleY(Progress);
        end
        else
        begin
          Value := 1.0 - Progress;
          AView.setScaleX(Value);
          AView.setScaleY(Value);
        end;
      end;

    TTransitionType.FlipHorizontal:
      begin
        AView.setPivotX(Width / 2);
        if IsEnter then
          AView.setRotationY(-90 * (1.0 - Progress))
        else
          AView.setRotationY(90 * Progress);
      end;

    TTransitionType.FlipVertical:
      begin
        AView.setPivotY(Height / 2);
        if IsEnter then
          AView.setRotationX(-90 * (1.0 - Progress))
        else
          AView.setRotationX(90 * Progress);
      end;
  end;
end;

{ TPscInteractivePopController }

constructor TPscInteractivePopController.Create(AScreenManager: TPscScreenManager);
begin
  inherited Create;
  FScreenManager := AScreenManager;
  FConfig := TPscInteractivePopConfig.Default;
  FIsActive := False;
end;

procedure TPscInteractivePopController.OnGestureBegin(const State: TPscInteractivePopState);
var
  CurrentRegInfo, PreviousRegInfo: TViewRegistrationInfo;
  CurrentInstance, PreviousInstance: TPisces;
begin
  if FIsActive then Exit;
  if FScreenManager.FScreenStack.Count = 0 then Exit;

  // Get current screen
  if not ViewsRegistry.TryGetValue(FScreenManager.FCurrentScreenGUID, CurrentRegInfo) then Exit;

  // Peek at previous screen
  FPreviousGUID := FScreenManager.FScreenStack.Peek;
  if not ViewsRegistry.TryGetValue(FPreviousGUID, PreviousRegInfo) then Exit;

  FCurrentView := CurrentRegInfo.View;
  FPreviousView := PreviousRegInfo.View;

  // Get transitions
  CurrentInstance := TPisces(CurrentRegInfo.Instance);
  PreviousInstance := TPisces(PreviousRegInfo.Instance);

  if Assigned(CurrentInstance) then
    FCurrentTransitions := CurrentInstance.ScreenTransitions
  else
    FCurrentTransitions := TPscScreenTransitions.Default;

  if Assigned(PreviousInstance) then
    FPreviousTransitions := PreviousInstance.ScreenTransitions
  else
    FPreviousTransitions := TPscScreenTransitions.Default;

  // Cancel any running animations on both views to prevent flickering
  CancelViewAnimations(FCurrentView);
  CancelViewAnimations(FPreviousView);

  // IMPORTANT: Set previous view to INVISIBLE first to prevent any flash
  // Use INVISIBLE (not GONE) so layout is maintained and getWidth returns correct value
  FPreviousView.setVisibility(TJView.JavaClass.INVISIBLE);

  // Now safe to reset transforms - view is hidden
  ResetViewTransform(FCurrentView);
  ResetViewTransform(FPreviousView);

  // Apply starting transforms while still invisible
  ApplyTransitionProgressToView(FPreviousView, FPreviousTransitions.PopEnterTransition, 0, True);
  ApplyTransitionProgressToView(FCurrentView, FCurrentTransitions.PopExitTransition, 0, False);

  // Now make visible - view is already in correct starting position
  FPreviousView.setVisibility(TJView.JavaClass.VISIBLE);

  // Ensure proper Z-order: current view should be on top during gesture
  // This prevents the previous view from appearing above the current view
  FCurrentView.bringToFront;

  FState := State;
  FIsActive := True;

  TPscUtils.Log(Format('Interactive pop began: CurrentTrans=%d, PreviousTrans=%d',
    [Ord(FCurrentTransitions.PopExitTransition.TransitionType),
     Ord(FPreviousTransitions.PopEnterTransition.TransitionType)]),
    'OnGestureBegin', TLogger.Info, 'TPscInteractivePopController');
end;

procedure TPscInteractivePopController.OnGestureUpdate(const State: TPscInteractivePopState);
begin
  if not FIsActive then Exit;
  FState := State;
  ApplyTransitionProgress(State.Progress);
end;

procedure TPscInteractivePopController.OnGestureEnd(const State: TPscInteractivePopState);
var
  ShouldCommit: Boolean;
begin
  if not FIsActive then Exit;
  FState := State;

  // Simple commit decision: only based on progress threshold
  // Progress is calculated from horizontal swipe distance
  ShouldCommit := State.Progress >= FConfig.ProgressThreshold;

  TPscUtils.Log(Format('Interactive pop ended: Progress=%.2f, Commit=%s',
    [State.Progress, BoolToStr(ShouldCommit, True)]),
    'OnGestureEnd', TLogger.Info, 'TPscInteractivePopController');

  if ShouldCommit then
    CommitPop
  else
    CancelPop;
end;

procedure TPscInteractivePopController.OnGestureCancel;
begin
  if not FIsActive then Exit;
  TPscUtils.Log('Interactive pop cancelled', 'OnGestureCancel', TLogger.Info, 'TPscInteractivePopController');
  CancelPop;
end;

procedure TPscInteractivePopController.ApplyTransitionProgress(Progress: Single);
begin
  if not FIsActive then Exit;

  // Log transition types being applied
  TPscUtils.Log(Format('ApplyProgress: %.2f, CurrentExit=%d, PreviousEnter=%d',
    [Progress, Ord(FCurrentTransitions.PopExitTransition.TransitionType),
     Ord(FPreviousTransitions.PopEnterTransition.TransitionType)]),
    'ApplyTransitionProgress', TLogger.Info, 'TPscInteractivePopController');

  // Apply PopExitTransition to current (exiting) view
  ApplyTransitionProgressToView(FCurrentView, FCurrentTransitions.PopExitTransition, Progress, False);

  // Apply PopEnterTransition to previous (entering) view
  ApplyTransitionProgressToView(FPreviousView, FPreviousTransitions.PopEnterTransition, Progress, True);
end;

procedure TPscInteractivePopController.CommitPop;
var
  RemainingProgress: Single;
  Duration: Integer;
  CurrentInstance: TPisces;
  CurrentRegInfo: TViewRegistrationInfo;
  LocalCurrentView, LocalPreviousView: JView;
  LocalScreenManager: TPscScreenManager;
begin
  if not FIsActive then Exit;

  RemainingProgress := 1.0 - FState.Progress;
  Duration := Round(FConfig.AnimationDurationMs * RemainingProgress);
  if Duration < 50 then Duration := 50;

  TPscUtils.Log(Format('CommitPop: Progress=%.2f, Remaining=%.2f, Duration=%d',
    [FState.Progress, RemainingProgress, Duration]),
    'CommitPop', TLogger.Info, 'TPscInteractivePopController');

  // Capture local references for use in anonymous methods
  LocalCurrentView := FCurrentView;
  LocalPreviousView := FPreviousView;
  LocalScreenManager := FScreenManager;

  // Animate current view out from current position to end
  AnimateTransitionToEnd(FCurrentView, FCurrentTransitions.PopExitTransition, False, Duration,
    procedure
    begin
      TPscUtils.Log('CommitPop: Current view animation completed', 'CommitPop', TLogger.Info, 'TPscInteractivePopController');
      LocalCurrentView.setVisibility(TJView.JavaClass.GONE);
      ResetViewTransform(LocalCurrentView);
    end);

  // Animate previous view in from current position to end
  AnimateTransitionToEnd(FPreviousView, FPreviousTransitions.PopEnterTransition, True, Duration,
    procedure
    begin
      TPscUtils.Log('CommitPop: Previous view animation completed, finishing pop', 'CommitPop', TLogger.Info, 'TPscInteractivePopController');
      ResetViewTransform(LocalPreviousView);
      LocalScreenManager.FinishInteractivePop;
    end);

  // Call lifecycle methods
  if ViewsRegistry.TryGetValue(FScreenManager.FCurrentScreenGUID, CurrentRegInfo) then
  begin
    CurrentInstance := TPisces(CurrentRegInfo.Instance);
    if Assigned(CurrentInstance) then
      CurrentInstance.DoHide;
  end;

  FIsActive := False;
end;

procedure TPscInteractivePopController.CancelPop;
var
  Duration: Integer;
  LocalCurrentView, LocalPreviousView: JView;
begin
  if not FIsActive then Exit;

  Duration := Round(FConfig.AnimationDurationMs * FState.Progress);
  if Duration < 50 then Duration := 50;

  // Capture local references for use in anonymous methods
  LocalCurrentView := FCurrentView;
  LocalPreviousView := FPreviousView;

  // Animate current view back to starting position
  AnimateTransitionToStart(FCurrentView, FCurrentTransitions.PopExitTransition, False, Duration,
    procedure
    begin
      ResetViewTransform(LocalCurrentView);
    end);

  // Animate previous view back to starting position and hide
  AnimateTransitionToStart(FPreviousView, FPreviousTransitions.PopEnterTransition, True, Duration,
    procedure
    begin
      LocalPreviousView.setVisibility(TJView.JavaClass.GONE);
      ResetViewTransform(LocalPreviousView);
    end);

  FIsActive := False;
  TPscUtils.Log('Interactive pop cancelled and animating back', 'CancelPop', TLogger.Info, 'TPscInteractivePopController');
end;

{ TPscScreenManager }

constructor TPscScreenManager.Create;
begin
  inherited Create;
  FScreenStack := TStack<String>.Create;
  FCurrentScreenGUID := '';
  FInteractivePopConfig := TPscInteractivePopConfig.Default;
  FInteractivePopController := TPscInteractivePopController.Create(Self);
end;

destructor TPscScreenManager.Destroy;
begin
  if Assigned(FInteractivePopController) then
    FInteractivePopController.Free;
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

{ Interactive Pop Methods }

procedure TPscScreenManager.BeginInteractivePop(const State: TPscInteractivePopState);
begin
  if not CanInteractivePop then Exit;
  FInteractivePopController.OnGestureBegin(State);
end;

procedure TPscScreenManager.UpdateInteractivePop(const State: TPscInteractivePopState);
begin
  FInteractivePopController.OnGestureUpdate(State);
end;

procedure TPscScreenManager.EndInteractivePop(const State: TPscInteractivePopState);
begin
  FInteractivePopController.OnGestureEnd(State);
end;

procedure TPscScreenManager.CancelInteractivePop;
begin
  FInteractivePopController.OnGestureCancel;
end;

function TPscScreenManager.CanInteractivePop: Boolean;
var
  CurrentRegInfo: TViewRegistrationInfo;
  CurrentInstance: TPisces;
begin
  Result := False;

  // Basic checks
  if FScreenStack.Count = 0 then Exit;
  if FInteractivePopController.IsActive then Exit;
  if not FInteractivePopConfig.Enabled then Exit;

  // Check if current screen allows interactive pop
  if ViewsRegistry.TryGetValue(FCurrentScreenGUID, CurrentRegInfo) then
  begin
    CurrentInstance := TPisces(CurrentRegInfo.Instance);
    if Assigned(CurrentInstance) and (not CurrentInstance.AllowInteractivePop) then
    begin
      TPscUtils.Log('Interactive pop blocked - current screen has DisableInteractivePop',
        'CanInteractivePop', TLogger.Info, 'TPscScreenManager');
      Exit;
    end;
  end;

  Result := True;
end;

procedure TPscScreenManager.FinishInteractivePop;
var
  PreviousGUID: String;
  PreviousRegInfo: TViewRegistrationInfo;
  PreviousInstance: TPisces;
begin
  // Pop the stack without animation (animation already done by controller)
  if FScreenStack.Count > 0 then
  begin
    PreviousGUID := FScreenStack.Pop;

    // Call DoShow on previous screen
    if ViewsRegistry.TryGetValue(PreviousGUID, PreviousRegInfo) then
    begin
      PreviousInstance := TPisces(PreviousRegInfo.Instance);
      if Assigned(PreviousInstance) then
        PreviousInstance.DoShow;
    end;

    FCurrentScreenGUID := PreviousGUID;
    TPscUtils.Log('Interactive pop finished', 'FinishInteractivePop', TLogger.Info, 'TPscScreenManager');
  end;
end;

end.
