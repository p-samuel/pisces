unit View.Settings;

interface

uses
  Pisces, View.Toolbar;

type
  [ TextView('settingsContent'),
    Text('This is the Settings screen. Use the back button in the toolbar to return to the Home screen.'),
    TextColor(60, 60, 60),
    TextSize(18),
    Padding(32, 32, 32, 32),
    Gravity([TGravity.Center])
  ] TSettingsContent = class(TPisces)
  end;

  [ LinearLayout('settingsContainer'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top])
  ] TSettingsContainer = class(TPisces)
    FToolbar: TToolbarHeader;
    FContent: TSettingsContent;
  end;

  [ FrameLayout('settings'),
    FullScreen(True),
    BackgroundColor(255, 243, 224),
    DarkStatusBarIcons(True),
    StatusBarColor(245, 124, 0)
  ] TViewSettings = class(TPisces)
    FContainer: TSettingsContainer;
  public
    procedure DoShow; override;
  end;

var
  ViewSettings: TViewSettings;

implementation

uses
  Pisces.ScreenManager;

{ TViewSettings }

procedure TViewSettings.DoShow;
begin
  inherited;
  if Assigned(FContainer) and Assigned(FContainer.FToolbar) then begin
    FContainer.FToolbar.SetTitle('Settings');
    FContainer.FToolbar.ShowBackButton;
  end;
end;

initialization
  ViewSettings := TViewSettings.Create;
  ViewSettings.ShowAndHide;

finalization
  ViewSettings.Free;

end.
