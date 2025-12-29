unit View.Detail;

interface

uses
  Pisces;

type

  [ TextView('detailTitle'),
    Text('Detail Screen'),
    TextSize(24),
    TextColor(60, 60, 60),
    Height(80),
    Gravity([TGravity.Center])
  ] TDetailTitle = class(TPisces)
  end;

  [ TextView('detailTextViewContent'),
    Text('Transition info will appear here'),
    TextSize(16),
    TextColor(100, 100, 100),
    Padding(32, 16, 32, 32),
    Height(180),
    Gravity([TGravity.Center])
  ] TDetailContent = class(TPisces)
  end;

  [ Button('detailBtnBack'),
    Text('Go Back'),
    TextSize(18),
    TextColor(255, 255, 255),
    BackgroundTintList(100, 149, 237),
    Height(100)
  ] TBackButton = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('detailScreen'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(236, 239, 241),
    FullScreen(True),
    Padding(32, 32, 32, 32),
    Gravity([TGravity.Center]),
    // Default transitions (can be overridden dynamically)
    EnterTransition(TTransitionType.SlideRight, TEasingType.Decelerate, 450),
    ExitTransition(TTransitionType.Fade, TEasingType.Accelerate, 450),
    PopEnterTransition(TTransitionType.Fade, TEasingType.Decelerate, 450),
    PopExitTransition(TTransitionType.SlideRight, TEasingType.Accelerate, 450)
  ] TDetailScreen = class(TPisces)
    FTitle: TDetailTitle;
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
  TPscScreenManager.Instance.Pop;
end;

{ TDetailScreen }

procedure TDetailScreen.DoShow;
var
  TransitionName: String;
  Source: String;
  Title: String;
  MessageText: String;
begin
  inherited;
  TransitionName := State.Get<String>('transition', 'Default');
  Source := State.Get<String>('source', 'unknown');
  Title := State.Get<String>('title', 'Detail Screen');

  MessageText := Format('Transition: %s'#10'Source: %s'#10#10'Tap "Go Back" to see the pop animation.',
    [TransitionName, Source]);

  if (FTitle <> nil) and (FTitle.AndroidView <> nil) then
    JTextView(FTitle.AndroidView).setText(StrToJCharSequence(Title));
  if (FContent <> nil) and (FContent.AndroidView <> nil) then
    JTextView(FContent.AndroidView).setText(StrToJCharSequence(MessageText));
end;

initialization
  DetailScreen := TDetailScreen.Create;
  DetailScreen.ShowAndHide;

finalization
  DetailScreen.Free;

end.
