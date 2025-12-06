unit View.Home;

interface

uses
  System.SysUtils,
  Pisces;

type

  [ TextView('tvTitle'),
    Text('Home Screen'),
    TextSize(32),
    TextColor(255, 255, 255),
    Height(150),
    Padding(0, 0, 0, 40),
    Gravity([TGravity.Center])
  ] TTitle = class(TPisces)
  end;

  [ Button('btnGoToDetail'),
    Text('View Details'),
    TextSize(20),
    TextColor(255, 255, 255),
    BackgroundTintList(29, 94, 120),
    Height(120)
  ] TDetailButton = class(TPisces)
  public
    constructor Create; override;
  private
    procedure HandleClick(AView: JView);
  end;

  [ Button('btnGoToUser'),
    Text('View User Profile'),
    TextSize(20),
    TextColor(255, 255, 255),
    BackgroundTintList(29, 94, 120),
    Height(120)
  ] TUserButton = class(TPisces)
  public
    constructor Create; override;
  private
    procedure HandleClick(AView: JView);
  end;

  [ LinearLayout('home'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(27, 174, 91),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Gravity([TGravity.Center]),
    Padding(32, 32, 32, 32)
  ] THomeScreen = class(TPisces)
    FTitle: TTitle;
    FDetailButton: TDetailButton;
    FUserButton: TUserButton;
  public
    procedure AfterCreate; override;
  end;

var
  HomeScreen: THomeScreen;

implementation

uses
  Pisces.ScreenManager,
  View.Detail,
  View.User;

{ TDetailButton }

constructor TDetailButton.Create;
begin
  OnClick := HandleClick;
  inherited;
end;

procedure TDetailButton.HandleClick(AView: JView);
begin
  TPscUtils.Log('Detail button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.PushByName('detailScreen');
end;

{ TUserButton }

constructor TUserButton.Create;
begin
  OnClick := HandleClick;
  inherited;
end;

procedure TUserButton.HandleClick(AView: JView);
begin
  TPscUtils.Log('User button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.PushByName('userScreen');
end;

{ THomeScreen }

procedure THomeScreen.AfterCreate;
begin
  inherited;
  TPscUtils.Log('Home screen initialized', 'AfterCreate', TLogger.Info, Self);
end;

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;

  // Register home screen as the initial screen with ScreenManager
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  HomeScreen.Free;

end.
