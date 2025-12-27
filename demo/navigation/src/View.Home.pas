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
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnGoToUser'),
    Text('View User Profile'),
    TextSize(20),
    TextColor(255, 255, 255),
    BackgroundTintList(29, 94, 120),
    Height(120)
  ] TUserButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
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
  end;

var
  HomeScreen: THomeScreen;

implementation

uses
  Pisces.ScreenManager,
  View.Detail,
  View.User;

{ TDetailButton }

procedure TDetailButton.OnClickHandler(AView: JView);
begin
  TPscUtils.Log('Detail button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscState.SetValue('source', 'home');
  TPscState.SetValue('title', 'Product Details');
  TPscScreenManager.Instance.PushByName('detailScreen');
end;

{ TUserButton }

procedure TUserButton.OnClickHandler(AView: JView);
begin
  TPscUtils.Log('User button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscState.SetValue('userName', 'Alice Smith');
  TPscState.SetValue('userId', 42);
  TPscScreenManager.Instance.PushByName('userScreen');
end;

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;

  // Register home screen as the initial screen with ScreenManager
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  HomeScreen.Free;

end.
