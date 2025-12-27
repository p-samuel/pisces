unit View.User;

interface

uses
  System.SysUtils,
  Pisces;

type

  [ TextView('tvUserName'),
    Text('John Doe'),
    TextSize(24),
    TextColor(0, 0, 0),
    Height(150),
    Gravity([TGravity.Center])
  ] TUserNameText = class(TPisces)
  end;

  [ TextView('tvUserId'),
    Text('User ID: 123'),
    TextSize(16),
    TextColor(100, 100, 100),
    Height(150),
    Padding(0, 16, 0, 0),
    Gravity([TGravity.Center])
  ] TUserIdText = class(TPisces)
  end;

  [ Button('btnBack'),
    Text('Go Back'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(100, 149, 237),
    Height(120)
  ] TUserBackButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('userScreen'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 250, 240),
    FullScreen(True),
    Gravity([TGravity.Center]),
    Padding(32, 32, 32, 32)
  ] TUserScreen = class(TPisces)
    UserName: TUserNameText;
    UserId: TUserIdText;
    BackButton: TUserBackButton;
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
  TPscUtils.Log('Back button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.Pop;
end;

{ TUserScreen }

procedure TUserScreen.DoShow;
var
  UserNameValue: String;
  UserIdValue: Integer;
begin
  inherited;
  UserNameValue := State.Get<String>('userName', 'John Doe');
  UserIdValue := State.Get<Integer>('userId', 0);

  if (UserName <> nil) and (UserName.AndroidView <> nil) then
    JTextView(UserName.AndroidView).setText(StrToJCharSequence(UserNameValue));
  if (UserId <> nil) and (UserId.AndroidView <> nil) then
    JTextView(UserId.AndroidView).setText(StrToJCharSequence(Format('User ID: %d', [UserIdValue])));
end;

initialization
  UserScreen := TUserScreen.Create;
  UserScreen.ShowAndHide;

finalization
  UserScreen.Free;

end.
