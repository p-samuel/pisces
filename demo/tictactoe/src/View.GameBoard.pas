unit View.GameBoard;

interface

uses
  Pisces,
  Logic.Game;

type
  TCell = class;
  TRow = class;
  TGameBoardContainer = class;
  TCellArray = array[0..2, 0..2] of TCell;

  [ ImageView('player-x'),
    ImageResource('marker', 'drawable'),
    ScaleType(TImageScaleType.CenterCrop)
  ] TPlayerX = class(TPisces)
  end;

  [ ImageView('player-o'),
    ImageResource('circle', 'drawable'),
    ScaleType(TImageScaleType.CenterCrop)
  ] TPlayerO = class(TPisces)
  end;

  [ View('cell-overlay'),
    BackgroundColor(0, 0, 0, 0.01),
    RippleColor(255, 255, 255, 0.4)
  ] TCellOverlay = class(TPisces)
  public
    procedure OverlayClick(View: JView);
    constructor Create; override;
  end;

  [ FrameLayout('cell'),
    Gravity([TGravity.Center]),
    Width(300), Height(300)
  ] TCell = class(TPisces)
  private
    FRow: Integer;
    FCol: Integer;
  public
    FPlayerO: TPlayerO;
    FPlayerX: TPlayerX;
    FCellOverlay: TCellOverlay;
    procedure CellClick(View: JView);
    procedure AfterCreate; override;
    procedure UpdateDisplay;
    procedure SetPosition(ARow, ACol: Integer);
    property Row: Integer read FRow;
    property Col: Integer read FCol;
  end;

  [ LinearLayout('rows'),
    Orientation(TOrientation.Horizontal),
    Height(300)
  ] TRow = class(TPisces)
  public
    FCell1: TCell;
    FCell2: TCell;
    FCell3: TCell;
  end;

  [ LinearLayout('gameboard'),
    MultiGradient(
      255, 255, 255, 0.7,    // White (70% opacity)
      230, 230, 230, 0.7,    // Light gray (70% opacity)
      TGradientOrientation.TopToBottom,
      90,                    // Corner radius
      0                      // Gradient radius (0 for linear)
    ),
    Orientation(TOrientation.Vertical),
    Width(900), Height(900)
  ] TGameBoardContainer = class(TPisces)
  public
    FRow1: TRow;
    FRow2: TRow;
    FRow3: TRow;
    procedure AfterCreate; override;
    procedure ResetBoard;
  private
    procedure InitializeCellPositions;
    function GetCells: TCellArray;
  public
    property Cells: TCellArray read GetCells;
  end;

var
  GameBoard: TGameBoardContainer;

implementation

uses
  System.SysUtils,
  Androidapi.Helpers,
  View.Footer;

{ TCellOverlay }

constructor TCellOverlay.Create;
begin
  OnClick := OverlayClick;
  inherited;
end;

procedure TCellOverlay.OverlayClick(View: JView);
begin
  if Assigned(Parent) and (Parent is TCell) then
    TCell(Parent).CellClick(View);
end;

{ TCell }

procedure TCell.AfterCreate;
begin
  inherited;
  FRow := -1;
  FCol := -1;
  if Assigned(FPlayerX) then
    FPlayerX.Visible := False;
  if Assigned(FPlayerO) then
    FPlayerO.Visible := False;
end;

procedure TCell.SetPosition(ARow, ACol: Integer);
begin
  FRow := ARow;
  FCol := ACol;
end;

procedure TCell.CellClick(View: JView);
begin

  if Game.Status <> gsPlaying then
    Exit;

  if Game.MakeMove(FRow, FCol) then begin
    UpdateDisplay;
    TPscUtils.Sound.Play('twinkle');

    if Game.Status in [gsWinX, gsWinO] then begin
      TPscUtils.Sound.Play('win');
      UpdateScores;
    end;
  end;

end;

procedure TCell.UpdateDisplay;
var
  Player: TPlayer;
begin
  Player := Game.GetCell(FRow, FCol);

  case Player of
    plX: begin
      FPlayerX.Visible := True;
      FPlayerO.Visible := False;
    end;
    plO: begin
      FPlayerO.Visible := True;
      FPlayerX.Visible := False;
    end;
    plNone: begin
      FPlayerX.Visible := False;
      FPlayerO.Visible := False;
    end;
  end;
end;

{ TGameBoardContainer }

procedure TGameBoardContainer.AfterCreate;
begin
  inherited;
  GameBoard := Self;
  InitializeCellPositions;
  TPscUtils.Music.Play('bg-music');
end;

procedure TGameBoardContainer.InitializeCellPositions;
begin

  if Assigned(FRow1) then begin
    if Assigned(FRow1.FCell1) then FRow1.FCell1.SetPosition(0, 0);
    if Assigned(FRow1.FCell2) then FRow1.FCell2.SetPosition(0, 1);
    if Assigned(FRow1.FCell3) then FRow1.FCell3.SetPosition(0, 2);
  end;

  if Assigned(FRow2) then begin
    if Assigned(FRow2.FCell1) then FRow2.FCell1.SetPosition(1, 0);
    if Assigned(FRow2.FCell2) then FRow2.FCell2.SetPosition(1, 1);
    if Assigned(FRow2.FCell3) then FRow2.FCell3.SetPosition(1, 2);
  end;

  if Assigned(FRow3) then begin
    if Assigned(FRow3.FCell1) then FRow3.FCell1.SetPosition(2, 0);
    if Assigned(FRow3.FCell2) then FRow3.FCell2.SetPosition(2, 1);
    if Assigned(FRow3.FCell3) then FRow3.FCell3.SetPosition(2, 2);
  end;

end;

procedure TGameBoardContainer.ResetBoard;
var
  R, C: Integer;
  CellArray: TCellArray;
begin
  Game.Reset;
  CellArray := GetCells;
  for R := 0 to 2 do
    for C := 0 to 2 do begin
      TPscUtils.Log('updating cell [' + R.ToString + ',' + C.ToString + ']', 'ResetBoard', TLogger.Info, Self);
      if Assigned(CellArray[R, C]) then
        CellArray[R, C].UpdateDisplay;
    end;
end;

function TGameBoardContainer.GetCells: TCellArray;
begin
  Result[0, 0] := FRow1.FCell1;
  Result[0, 1] := FRow1.FCell2;
  Result[0, 2] := FRow1.FCell3;
  Result[1, 0] := FRow2.FCell1;
  Result[1, 1] := FRow2.FCell2;
  Result[1, 2] := FRow2.FCell3;
  Result[2, 0] := FRow3.FCell1;
  Result[2, 1] := FRow3.FCell2;
  Result[2, 2] := FRow3.FCell3;
end;

initialization

  TPscUtils.Music
    .Load('bg-music', 'audio/bg-music.mp3');

  TPscUtils.Sound
    .Load('twinkle', 'audio/twinkle.wav')
    .Load('win', 'audio/win.wav');

end.
