unit View.Home;

interface

uses
  Pisces;

type
  [ TextView('txtInstructions'),
    Text('Please enter your details below:'),
    TextSize(16),
    TextColor(33, 33, 33),
    Padding(16, 16, 16, 8),
    Gravity([TGravity.Left])
  ] TInstructionsText = class(TPisces)
  end;

  [ Edit('edtName'),
    Hint('Enter your name'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 8),
    Height(100)
  ] TNameEdit = class(TPisces)
  end;

  [ TextView('txtName'),
    Text('Name: John Doe'),
    TextSize(14),
    TextColor(66, 66, 66),
    Padding(16, 8, 16, 4)
  ] TNameText = class(TPisces)
  end;

  [ TextView('txtEmail'),
    Text('Email: john@example.com'),
    TextSize(14),
    TextColor(66, 66, 66),
    Padding(16, 4, 16, 4)
  ] TEmailText = class(TPisces)
  end;

  [ TextView('txtNotify'),
    Text('Notifications: Enabled'),
    TextSize(14),
    TextColor(66, 66, 66),
    Padding(16, 4, 16, 16)
  ] TNotifyText = class(TPisces)
  end;

  [ LinearLayout('customDialogContent'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Height(600)
  ] TCustomDialogView = class(TPisces)
    FInstructions: TInstructionsText;
    FNameEdit: TNameEdit;
    FName: TNameText;
    FEmail: TEmailText;
    FNotify: TNotifyText;
  end;

  [ Button('btnMultiChoice'),
    Text('Multi Choice (Checkbox)'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(0, 150, 136),
    Height(120),
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

  [ Button('btnCustomView'),
    Text('Custom View'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(233, 30, 99),
    Height(120),
    Padding(16, 0, 16, 0)
  ] TCustomViewButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('home'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(0, 76, 63),
    Gravity([TGravity.Center]),
    FullScreen(True),
    DarkStatusBarIcons(False)
  ] THomeView = class(TPisces)
    FCustomDialogContent: TCustomDialogView;
    FSimpleAlertBtn: TSimpleAlertButton;
    FSingleChoiceBtn: TSingleChoiceButton;
    FMultiChoiceBtn: TMultiChoiceButton;
    FCustomViewBtn: TCustomViewButton;
    constructor Create; override;
    procedure DoShow; override;
    procedure AfterShow; override;
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

{ TCustomViewButton }

procedure TCustomViewButton.OnClickHandler(AView: JView);
var
  HomeView: THomeView;
begin
  if Parent is THomeView then
  begin
    HomeView := THomeView(Parent);
    HomeView.FCustomDialogContent.Visible := True;
    TPscUtils.AlertDialog
      .Title('User Profile')
      .SingleChoiceItems(['Light Mode', 'Dark Mode', 'System Default'], 0,
      procedure(Index: Integer) begin
        TPscUtils.Log('Selected index: ' + IntToStr(Index), 'SingleChoice', TLogger.Info, nil);
      end)
      .CustomView(HomeView.FCustomDialogContent.AndroidView)
      .PositiveButton('OK', procedure begin
        TPscUtils.Toast('Profile confirmed!', 0);
      end)
      .NegativeButton('Cancel', nil)
      .OnDismiss(procedure begin
        HomeView.FCustomDialogContent.Visible := False;
      end)
    .Show;
  end;
end;

{ THomeView }


// Why only AfterShow successfully hides the custom view used to the alert dialog?
//  View Lifecycle Order:
//  1. Create (Constructor): Object is instantiated, but child fields like FCustomDialogContent are not yet created. They're just nil references at this point.
//  2. DoShow: Called early in the navigation lifecycle, but still before BuildScreen has processed child fields.
//  3. Show → BuildScreen: This is where ProcessFields is called (Pisces.Base.pas:32), which iterates through the class fields and creates instances of child views like FCustomDialogContent.
//  4. Views attached to Activity: Child views are added to the Android view hierarchy.
//  5. AfterShow: Called AFTER all children are fully created, built, and attached. At this point, FCustomDialogContent exists and is ready to use.

procedure THomeView.AfterShow;
begin
  inherited;
  FCustomDialogContent.Hide;
end;

constructor THomeView.Create;
begin
  inherited;
end;

procedure THomeView.DoShow;
begin
  inherited;
end;

initialization
  ViewHome := THomeView.Create;
  ViewHome.Show;

finalization
  ViewHome.Free;

end.
