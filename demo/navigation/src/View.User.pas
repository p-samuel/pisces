unit View.User;

interface

uses
  System.SysUtils,
  Pisces;

type

  [ TextView('tvUserTitle'),
    Text('User Screen'),
    TextSize(24),
    TextColor(60, 60, 60),
    Height(80),
    Gravity([TGravity.Center])
  ] TUserTitle = class(TPisces)
  end;

  [ TextView('tvUserName'),
    Text('Animation Demo'),
    TextSize(18),
    TextColor(80, 80, 80),
    Height(100),
    Gravity([TGravity.Center])
  ] TUserNameText = class(TPisces)
  end;

  [ TextView('tvUserInfo'),
    Text('This screen has gesture navigation disabled.'),
    TextSize(14),
    TextColor(120, 120, 120),
    Height(80),
    Padding(32, 0, 32, 0),
    Gravity([TGravity.Center])
  ] TUserInfoText = class(TPisces)
  end;

  [ Button('btnBack'),
    Text('Go Back'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(100, 149, 237),
    Height(100)
  ] TUserBackButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('userScreen'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 253, 231),
    FullScreen(True),
    Gravity([TGravity.Center]),
    Padding(32, 32, 32, 32),
    // Default transitions (can be overridden dynamically)
    EnterTransition(TTransitionType.ScaleCenter, TEasingType.Overshoot, 450),
    ExitTransition(TTransitionType.Fade, TEasingType.Accelerate, 450),
    PopEnterTransition(TTransitionType.Fade, TEasingType.Decelerate, 450),
    PopExitTransition(TTransitionType.ScaleCenter, TEasingType.Anticipate, 450),
    // Disable interactive pop gesture for this screen (demo of opt-out)
    DisableInteractivePop(False)
  ] TUserScreen = class(TPisces)
    FTitle: TUserTitle;
    FUserName: TUserNameText;
    FUserInfo: TUserInfoText;
    FBackButton: TUserBackButton;
    procedure DoShow; override;
  end;

var
  UserScreen: TUserScreen;

implementation

uses
  Androidapi.Helpers,
  Pisces.ScreenManager;

{ TUserBackButton }

procedure TUserBackButton.OnClickHandler(AView: JView);
begin
  TPscScreenManager.Instance.Pop;
end;

{ TUserScreen }

procedure TUserScreen.DoShow;
var
  UserNameValue: String;
  UserIdValue: Integer;
  DisplayText: String;
  InfoText: String;
begin
  inherited;
  UserNameValue := State.Get<String>('userName', 'Animation Demo');
  UserIdValue := State.Get<Integer>('userId', 0);

  if UserIdValue > 0 then
    DisplayText := Format('%s (ID: %d)', [UserNameValue, UserIdValue])
  else
    DisplayText := UserNameValue;

  InfoText := 'This screen uses DisableInteractivePop(True).'#10 +
              'Edge swipe gesture is disabled here.'#10 +
              'Use the button to go back.';

  if (FUserName <> nil) and (FUserName.AndroidView <> nil) then
    JTextView(FUserName.AndroidView).setText(StrToJCharSequence(DisplayText));

  if (FUserInfo <> nil) and (FUserInfo.AndroidView <> nil) then
    JTextView(FUserInfo.AndroidView).setText(StrToJCharSequence(InfoText));
end;

initialization
  UserScreen := TUserScreen.Create;
  UserScreen.ShowAndHide;

finalization
  UserScreen.Free;

end.
