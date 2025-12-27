unit View.Footer;

interface

uses
  Pisces;

type

  [ TextView('p1-score'),
    Text('0'),
    TextSize(28),
    TextColor(255, 200, 100),
    WidthPercent(0.1),
    Gravity([TGravity.Center])
  ] TP1Score = class(TPisces)
  end;

  [ TextView('p1-dash'),
    Text('-'),
    TextSize(24),
    TextColor(255, 255, 255),
    WidthPercent(0.05),
    Gravity([TGravity.Center]),
    Padding(15, 0, 15, 0)
  ] TP1Dash = class(TPisces)
  end;

  [ TextView('p1-label'),
    Text('P1'),
    TextSize(20),
    TextColor(255, 255, 255),
    WidthPercent(0.13),
    Gravity([TGravity.Center]),
    Padding(0, 0, 40, 0)
  ] TP1Label = class(TPisces)
  end;

  [ TextView('btn-new-game'),
    Text('+'),
    TextSize(18),
    TextColor(100, 100, 100),
    BackgroundColor(255, 255, 255, 0.4),
    RippleColor(255, 255, 255, 0.5),
    CornerRadius(25),
    WidthPercent(0.20),
    Gravity([TGravity.Center]),
    Height(80)
  ] TBtnNewGame = class(TPisces)
    procedure OnClickHandler(View: JView); override;
    procedure OnLongClickHandler(View: JView); override;
  end;

  [ TextView('p2-label'),
    Text('P2'),
    TextSize(20),
    TextColor(255, 255, 255),
    WidthPercent(0.12),
    Gravity([TGravity.Center]),
    Padding(40, 0, 0, 0)
  ] TP2Label = class(TPisces)
  end;

  [ TextView('p2-dash'),
    Text('-'),
    TextSize(24),
    TextColor(255, 255, 255),
    WidthPercent(0.05),
    Gravity([TGravity.Center]),
    Padding(15, 0, 15, 0)
  ] TP2Dash = class(TPisces)
  end;

  [ TextView('p2-score'),
    Text('0'),
    TextSize(28),
    TextColor(100, 200, 255),
    WidthPercent(0.1),
    Gravity([TGravity.Center])
  ] TP2Score = class(TPisces)
  end;

  // 0 - P1 | + | P2 - 0
  [ LinearLayout('footer-container'),
    Orientation(TOrientation.Horizontal),
    Gravity([TGravity.Center, TGravity.CenterVertical]),
    ClipChildren(False),
    Height(100)
  ] TFooterContainer = class(TPisces)
  public
    FP1Score: TP1Score;
    FP1Dash: TP1Dash;
    FP1Label: TP1Label;
    FBtnNewGame: TBtnNewGame;
    FP2Label: TP2Label;
    FP2Dash: TP2Dash;
    FP2Score: TP2Score;
    procedure AfterShow; override;
  end;

var
  Footer: TFooterContainer;

procedure UpdateScores;
procedure AnimateWinner;

implementation

uses
  System.SysUtils,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  View.GameBoard,
  Logic.Game;

{ TBtnNewGame }

procedure TBtnNewGame.OnClickHandler(View: JView);
begin
  if Assigned(GameBoard) then
    GameBoard.ResetBoard;
end;

procedure TBtnNewGame.OnLongClickHandler(View: JView);
begin
  Game.ResetScores;
  UpdateScores;
  TPscUtils.Toast('Scores reset!', TJToast.JavaClass.LENGTH_SHORT);
end;

{ TFooterContainer }

procedure TFooterContainer.AfterShow;
begin
  inherited;
  Footer := Self;
  UpdateScores;
end;

procedure UpdateScores;
begin
  if Assigned(Footer) and Assigned(Footer.FP1Score) then
    JTextView(Footer.FP1Score.AndroidView).setText(StrToJCharSequence(Game.WinsX.ToString));
  if Assigned(Footer) and Assigned(Footer.FP2Score) then
    JTextView(Footer.FP2Score.AndroidView).setText(StrToJCharSequence(Game.WinsO.ToString));
end;

procedure AnimateWinner;
begin
  // animate winner here
  if Game.Status in [gsWinX] then begin
     if Assigned(Footer) and Assigned(Footer.FP1Score) then
      TPscUtils.Animate
        .FromView(Footer.FP1Score.AndroidView)
        .Scale(1, 4)
        .Rotation(0, 360)
        .Duration(200)
        .WithStartAction(
        procedure begin
          TPscUtils.Toast('Player 1 wins!', TJToast.JavaClass.LENGTH_SHORT);
        end)
       .WithEndAction(
        procedure
        begin
          Footer.FP1Score.AndroidView.setRotation(0);
          TPscUtils.Animate
            .FromView(Footer.FP1Score.AndroidView)
            .Scale(4, 1)
            .Duration(300)
            .Run;
        end)
        .Run;
  end;

  if Game.Status in [gsWinO] then begin
    if Assigned(Footer) and Assigned(Footer.FP2Score) then
      TPscUtils.Animate
        .FromView(Footer.FP2Score.AndroidView)
        .Rotation(0, 360)
        .Scale(1, 4)
        .Duration(200)
        .WithStartAction(
        procedure begin
          TPscUtils.Toast('Player 2 wins!', TJToast.JavaClass.LENGTH_SHORT);
        end)
       .WithEndAction(
        procedure
        begin
          Footer.FP2Score.AndroidView.setRotation(0);
          TPscUtils.Animate
            .FromView(Footer.FP2Score.AndroidView)
            .Scale(4, 1)
            .Duration(300)
            .Run;
        end)
        .Run;
  end;
end;

end.
