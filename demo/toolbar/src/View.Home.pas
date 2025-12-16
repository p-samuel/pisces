unit View.Home;

interface

uses
  Pisces, View.Toolbar;

type

  [ Button('btnDetail'),
    Text('Go to Details'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(33, 150, 243),
    Height(120),
    Padding(16, 0, 16, 0)
  ] TDetailButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnSettings'),
    Text('Go to Settings'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(76, 175, 80),
    Height(120),
    Padding(16, 0, 16, 0)
  ] TSettingsButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('homeContent'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Center]),
    Padding(32, 32, 32, 32)
  ] THomeContent = class(TPisces)
    FDetailBtn: TDetailButton;
    FSettingsBtn: TSettingsButton;
  end;

  [ LinearLayout('homeContainer'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top])
  ] THomeContainer = class(TPisces)
    FToolbar: TToolbarHeader;
    FContent: THomeContent;
  end;

  [ FrameLayout('home'),
    FullScreen(True),
    BackgroundColor(250, 250, 250),
    DarkStatusBarIcons(False),
    StatusBarColor(25, 118, 210)
  ] TViewHome = class(TPisces)
    FContainer: THomeContainer;
  public
    procedure DoShow; override;
  end;

var
  ViewHome: TViewHome;

implementation

uses
  Pisces.ScreenManager,
  View.Detail,
  View.Settings;

{ TDetailButton }

procedure TDetailButton.OnClickHandler(AView: JView);
begin
  TPscUtils.Log('Navigating to Detail screen', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.PushByName('detail');
end;

{ TSettingsButton }

procedure TSettingsButton.OnClickHandler(AView: JView);
begin
  TPscUtils.Log('Navigating to Settings screen', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.PushByName('settings');
end;

{ TViewHome }

procedure TViewHome.DoShow;
begin
  inherited;
  if Assigned(FContainer) and Assigned(FContainer.FToolbar) then begin
    FContainer.FToolbar.SetTitle('Toolbar Demo');
    FContainer.FToolbar.HideBackButton;
  end;
end;

initialization
  ViewHome := TViewHome.Create;
  ViewHome.Show;
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  ViewHome.Free;

end.
