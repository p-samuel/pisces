unit View.Home;

interface

uses
  System.SysUtils,
  Pisces;

type

  [ TextView('tvTitle'),
    Text('Transition Demo'),
    TextSize(28),
    TextColor(255, 255, 255),
    Height(100),
    Gravity([TGravity.Center])
  ] TTitle = class(TPisces)
  end;

  [ TextView('tvSubtitle'),
    Text('Tap buttons or swipe from left edge to go back'),
    TextSize(14),
    TextColor(220, 220, 220),
    Height(60),
    Padding(0, 0, 0, 20),
    Gravity([TGravity.Center])
  ] TSubtitle = class(TPisces)
  end;

  // Slide Right button - coral color
  [ Button('btnSlideRight'),
    Text('Slide Right'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(255, 127, 80),
    Height(100)
  ] TSlideRightButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  // Slide Up button - teal color
  [ Button('btnSlideUp'),
    Text('Slide Up'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(0, 150, 136),
    Height(100)
  ] TSlideUpButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  // Scale button - purple color
  [ Button('btnScale'),
    Text('Scale + Overshoot'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(156, 39, 176),
    Height(100)
  ] TScaleButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  // Flip button - indigo color
  [ Button('btnFlip'),
    Text('Flip Vertical'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(63, 81, 181),
    Height(100)
  ] TFlipButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  // Bounce button - orange color
  [ Button('btnBounce'),
    Text('Scale + Bounce'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(255, 152, 0),
    Height(100)
  ] TBounceButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  // Fade button - blue-grey color
  [ Button('btnFade'),
    Text('Fade'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(96, 125, 139),
    Height(100)
  ] TFadeButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('home'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(55, 71, 79),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Gravity([TGravity.Center]),
    Padding(32, 24, 32, 24),
    EnterTransition(TTransitionType.Fade, TEasingType.AccelerateDecelerate, 450),
    ExitTransition(TTransitionType.SlideLeft, TEasingType.Accelerate, 450),
    PopEnterTransition(TTransitionType.SlideLeft, TEasingType.Decelerate, 450),
    PopExitTransition(TTransitionType.Fade, TEasingType.Accelerate, 450)
  ] THomeScreen = class(TPisces)
    FTitle: TTitle;
    FSubtitle: TSubtitle;
    FSlideRightButton: TSlideRightButton;
    FSlideUpButton: TSlideUpButton;
    FScaleButton: TScaleButton;
    FFlipButton: TFlipButton;
    FBounceButton: TBounceButton;
    FFadeButton: TFadeButton;
  end;

var
  HomeScreen: THomeScreen;

implementation

uses
  Pisces.ScreenManager,
  View.Detail,
  View.User;

{ TSlideRightButton }

procedure TSlideRightButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('transition', 'SlideRight');
  TPscState.SetValue('source', 'Slide Right button');
  TPscState.SetValue('title', 'Slide Right Demo');
  DetailScreen.ScreenTransitions := TPscScreenTransitions.Create(
    TPscTransitionConfig.Create(TTransitionType.SlideRight, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.SlideLeft, TEasingType.Accelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.SlideRight, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.SlideRight, TEasingType.Accelerate, 450)
  );
  TPscScreenManager.Instance.PushByName('detailScreen');
end;

{ TSlideUpButton }

procedure TSlideUpButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('transition', 'SlideUp');
  TPscState.SetValue('source', 'Slide Up button');
  TPscState.SetValue('title', 'Slide Up Demo');
  DetailScreen.ScreenTransitions := TPscScreenTransitions.Create(
    TPscTransitionConfig.Create(TTransitionType.SlideUp, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.SlideDown, TEasingType.Accelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.SlideUp, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.SlideDown, TEasingType.Accelerate, 450)
  );
  TPscScreenManager.Instance.PushByName('detailScreen');
end;

{ TScaleButton }

procedure TScaleButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('userName', 'Scale Demo (No Gesture)');
  TPscState.SetValue('userId', 1);
  UserScreen.ScreenTransitions := TPscScreenTransitions.Create(
    TPscTransitionConfig.Create(TTransitionType.ScaleCenter, TEasingType.Overshoot, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Accelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.ScaleCenter, TEasingType.Anticipate, 450)
  );
  TPscScreenManager.Instance.PushByName('userScreen');
end;

{ TFlipButton }

procedure TFlipButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('transition', 'FlipVertical');
  TPscState.SetValue('source', 'Flip button');
  TPscState.SetValue('title', 'Flip Vertical Demo');
  DetailScreen.ScreenTransitions := TPscScreenTransitions.Create(
    TPscTransitionConfig.Create(TTransitionType.FlipVertical, TEasingType.AccelerateDecelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Accelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.FlipVertical, TEasingType.AccelerateDecelerate, 450)
  );
  TPscScreenManager.Instance.PushByName('detailScreen');
end;

{ TBounceButton }

procedure TBounceButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('userName', 'Bounce Demo (No Gesture)');
  TPscState.SetValue('userId', 2);
  UserScreen.ScreenTransitions := TPscScreenTransitions.Create(
    TPscTransitionConfig.Create(TTransitionType.ScaleCenter, TEasingType.Bounce, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Accelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.ScaleCenter, TEasingType.Accelerate, 450)
  );
  TPscScreenManager.Instance.PushByName('userScreen');
end;

{ TFadeButton }

procedure TFadeButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('transition', 'Fade');
  TPscState.SetValue('source', 'Fade button');
  TPscState.SetValue('title', 'Fade Demo');
  DetailScreen.ScreenTransitions := TPscScreenTransitions.Create(
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.AccelerateDecelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Accelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Decelerate, 450),
    TPscTransitionConfig.Create(TTransitionType.Fade, TEasingType.Accelerate, 450)
  );
  TPscScreenManager.Instance.PushByName('detailScreen');
end;

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  HomeScreen.Free;

end.
