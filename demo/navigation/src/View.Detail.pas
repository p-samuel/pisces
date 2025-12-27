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
    procedure OnClickHandler(AView: JView); override;
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
    procedure DoShow; override;
  end;

var
  DetailScreen: TDetailScreen;

implementation

uses
  System.SysUtils,
  Androidapi.Helpers,
  Pisces.ScreenManager;

{ TBackButton }

procedure TBackButton.OnClickHandler(AView: JView);
begin
  TPscUtils.Log('Back button clicked!', 'HandleClick', TLogger.Info, Self);
  TPscScreenManager.Instance.Pop;
end;

{ TDetailScreen }

procedure TDetailScreen.DoShow;
var
  Source: String;
  Title: String;
  MessageText: String;
begin
  inherited;
  Source := State.Get<String>('source', '...');
  Title := State.Get<String>('title', '...');
  MessageText := Format('%s (from %s). Click the back button to return.', [Title, Source]);

  if (FContent <> nil) and (FContent.AndroidView <> nil) then
    JTextView(FContent.AndroidView).setText(StrToJCharSequence(MessageText));
end;

initialization
  DetailScreen := TDetailScreen.Create;
  DetailScreen.ShowAndHide;

finalization
  DetailScreen.Free;

end.
