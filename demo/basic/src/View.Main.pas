unit View.Main;

interface

uses
  Pisces;

type

  [ TextView('text'),
    Text('Click the main view'),
    TextColor(255, 255, 255),
    TextSize(19),
    Height(300),
    Gravity([TGravity.Center]),
    BackgroundColor(79, 129, 148),
    RippleColor(125, 221, 255),
    Width(700),
    CornerRadius(100),
    Justify(True, TBreakStrg.HighQuality)
  ] TText = class(TPisces)

  end;

  [ LinearLayout('screen'),
    BackgroundColor(107, 174, 200),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Center])
  ] TScreen = class(TPisces)
  private
    FText: TText;
    procedure ShowAlert(AView: JView);
    procedure ShowLongClick(AView: JView);
  public
    constructor Create; override ;

  end;

var
  Screen: TScreen;

implementation

uses
  System.SysUtils;

{ TScreen }

constructor TScreen.Create;
begin
  OnClick := ShowAlert;
  OnLongClick := ShowLongClick;
  inherited;
end;

procedure TScreen.ShowAlert(AView: JView);
begin
  TPscUtils.Toast('You clicked the main screen', TJToast.JavaClass.LENGTH_SHORT);
  TPscUtils.Log('You clicked the main screen', 'ShowAlert', TLogger.Warning, Self);
end;

procedure TScreen.ShowLongClick(AView: JView);
begin
  TPscUtils.Toast('You long-clicked the main screen', TJToast.JavaClass.LENGTH_SHORT);
  TPscUtils.Log('You long-clicked the main screen', 'ShowLongClick', TLogger.Fatal, Self);
end;

initialization
  Screen := TScreen.Create;
  Screen.Show;

finalization
  Screen.Free;

end.
