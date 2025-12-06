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
  public
    constructor Create; override;
  private
    procedure HandleClick(AView: JView);
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
  end;

var
  UserScreen: TUserScreen;

implementation

uses
  Pisces.ScreenManager;

{ TUserBackButton }

constructor TUserBackButton.Create;
begin
  OnClick := HandleClick;
  inherited;
end;

procedure TUserBackButton.HandleClick(AView: JView);
begin
  TPscUtils.Log('Back button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.Pop;
end;

{ TUserScreen }

initialization
  UserScreen := TUserScreen.Create;
  UserScreen.ShowAndHide;

finalization
  UserScreen.Free;

end.
