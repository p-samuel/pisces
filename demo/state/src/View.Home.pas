unit View.Home;

interface

uses
  System.SysUtils,
  Pisces;

type

  [ TextView('title'),
    Text('State Demo'),
    TextSize(28),
    TextColor(255, 255, 255),
    Height(100),
    Gravity([TGravity.Center])
  ] TTitle = class(TPisces)
  end;

  [ TextView('counter'),
    Text('0'),
    TextSize(72),
    TextColor(255, 255, 255),
    Height(200),
    Gravity([TGravity.Center])
  ] TCounterText = class(TPisces)
  end;

  [ TextView('info'),
    Text('Tap + to increment. Value persists across restarts.'),
    TextSize(14),
    TextColor(200, 255, 200),
    Height(90),
    Gravity([TGravity.Center])
  ] TInfoText = class(TPisces)
  end;

  [ Button('incrementBtn'),
    Text('+'),
    TextSize(32),
    TextColor(255, 255, 255),
    BackgroundTintList(46, 125, 50),
    Height(200)
  ] TIncrementButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('resetBtn'),
    Text('Reset'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(183, 28, 28),
    Height(200)
  ] TResetButton = class(TPisces)
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
    FCounter: TCounterText;
    FInfo: TInfoText;
    FIncrementBtn: TIncrementButton;
    FResetBtn: TResetButton;
    procedure AfterInitialize; override;
  end;

var
  HomeScreen: THomeScreen;

implementation

uses
  Androidapi.Helpers,
  Pisces.ScreenManager;

procedure UpdateCounterDisplay;
var
  Count: Integer;
  CounterView: JTextView;
begin
  try
    Count := TPscState.GetValue<Integer>('counter', 0);
    CounterView := JTextView(HomeScreen.FCounter.AndroidView);
    CounterView.setText(StrToJCharSequence(IntToStr(Count)));
  except
    on E: Exception do
      TPscUtils.Log('Error in UpdateCounterDisplay: ' + E.Message, 'UpdateCounterDisplay', TLogger.Error, nil);
  end;
end;

{ TIncrementButton }

procedure TIncrementButton.OnClickHandler(AView: JView);
var
  Count: Integer;
begin
  Count := TPscState.GetValue<Integer>('counter', 0);
  Inc(Count);
  TPscState.SetValue('counter', Count);
  TPscState.Save;
  UpdateCounterDisplay;
end;

{ TResetButton }

procedure TResetButton.OnClickHandler(AView: JView);
begin
  TPscState.SetValue('counter', 0);
  TPscState.Save;
  UpdateCounterDisplay;
end;

{ THomeScreen }

procedure THomeScreen.AfterInitialize;
begin
  inherited;
  TPscState.Load;
  UpdateCounterDisplay;
end;

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  HomeScreen.Free;

end.
