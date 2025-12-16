unit View.Home;

interface

uses
  Pisces;

type
  [ Button('btnMultiChoice'),
    Text('Multi Choice (Checkbox)'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(0, 150, 136),
    Height(120),
    Width(TLayout.MATCH),
    Padding(16, 0, 16, 0)
  ] TMultiChoiceButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnSimpleAlert'),
    Text('Simple Alert'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(255, 152, 0),
    Height(120),
    Width(TLayout.MATCH),
    Padding(16, 0, 16, 0)
  ] TSimpleAlertButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnSingleChoice'),
    Text('Single Choice (Radio)'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(156, 39, 176),
    Height(120),
    Width(TLayout.MATCH),
    Padding(16, 0, 16, 0)
  ] TSingleChoiceButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('home'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(0, 76, 63),
    Gravity([TGravity.Center]),
    FullScreen(True),
    DarkStatusBarIcons(False)
  ] THomeView = class(TPisces)
    FSimpleAlertBtn: TSimpleAlertButton;
    FSingleChoiceBtn: TSingleChoiceButton;
    FMultiChoiceBtn: TMultiChoiceButton;
  end;

var
  ViewHome: THomeView;

implementation

uses
  System.SysUtils, Pisces.ScreenManager;


{ TMultiChoiceButton }

procedure TMultiChoiceButton.OnClickHandler(AView: JView);
begin
  TPscUtils.AlertDialog
    .Title('Select Features')
    .MultiChoiceItems(
      ['Enable Notifications', 'Dark Mode', 'Auto-sync', 'Location Services'],
      [True, False, True, False],
      procedure(Index: Integer; Checked: Boolean) begin
        TPscUtils.Log('Item ' + IntToStr(Index) + ' checked: ' + BoolToStr(Checked, True),
          'MultiChoice', TLogger.Info, nil);
      end)
    .PositiveButton('Save', procedure begin
      TPscUtils.Toast('Settings saved!', 0);
    end)
  .Show;
end;

{ TSimpleAlertButton }

procedure TSimpleAlertButton.OnClickHandler(AView: JView);
begin
  TPscUtils.AlertDialog
    .Title('Confirmation')
    .Message('Are you sure you want to proceed with this action?')
    .PositiveButton('Yes', procedure begin
      TPscUtils.Toast('You clicked Yes!', 0);
    end)
    .NegativeButton('No', procedure begin
      TPscUtils.Toast('You clicked No!', 0);
    end)
    .NeutralButton('Maybe', procedure begin
      TPscUtils.Toast('You clicked Maybe!', 0);
    end)
  .Show;
end;

{ TSingleChoiceButton }

procedure TSingleChoiceButton.OnClickHandler(AView: JView);
begin
  TPscUtils.AlertDialog
    .Title('Select Theme')
    .SingleChoiceItems(['Light Mode', 'Dark Mode', 'System Default'], 0,
      procedure(Index: Integer) begin
        TPscUtils.Log('Selected index: ' + IntToStr(Index), 'SingleChoice', TLogger.Info, nil);
      end)
    .PositiveButton('Apply', procedure begin
      TPscUtils.Toast('Theme applied!', 0);
    end)
    .NegativeButton('Cancel', nil)
  .Show;
end;

initialization
  ViewHome := THomeView.Create;
  ViewHome.Show;
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  ViewHome.Free;

end.
