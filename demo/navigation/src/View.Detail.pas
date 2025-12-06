unit View.Detail;

interface

uses
  Pisces;

type

  [ Button('detailBtnBack'),
    Text('Go Back'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(100, 149, 237),
    Height(120)
  ] TBackButton = class(TPisces)
  public
    constructor Create; override;
  private
    procedure HandleClick(AView: JView);
  end;

  [ TextView('detailTextViewContent'),
    Text('This is the detail screen. Click the back button to return.'),
    TextSize(18),
    TextColor(60, 60, 60),
    Padding(32, 32, 32, 32),
    Height(250),
    Gravity([TGravity.Center])
  ] TDetailContent = class(TPisces)
  end;

  [ LinearLayout('detailScreen'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(230, 230, 250),
    FullScreen(True),
    Padding(32, 32, 32, 32),
    Gravity([TGravity.Center])
  ] TDetailScreen = class(TPisces)
    FContent: TDetailContent;
    FBackButton: TBackButton;
  end;

var
  DetailScreen: TDetailScreen;

implementation

uses
  Pisces.ScreenManager;

{ TBackButton }

constructor TBackButton.Create;
begin
  OnClick := HandleClick;
  inherited;
end;

procedure TBackButton.HandleClick(AView: JView);
begin
  TPscUtils.Log('Back button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.Pop;
end;

{ TDetailScreen }

initialization
  DetailScreen := TDetailScreen.Create;
  DetailScreen.ShowAndHide;

finalization
  DetailScreen.Free;

end.
