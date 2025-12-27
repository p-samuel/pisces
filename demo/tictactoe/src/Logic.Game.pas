unit Logic.Game;

interface

uses
  Pisces;

type
  TPlayer = (plNone, plX, plO);
  TGameStatus = (gsPlaying, gsWinX, gsWinO, gsDraw);
  TBoardArray = array[0..2, 0..2] of TPlayer;

  TTicTacToeGame = class
  private
    FBoard: TBoardArray;
    FCurrentPlayer: TPlayer;
    FStatus: TGameStatus;
    FMoveCount: Integer;
    FWinsX: Integer;
    FWinsO: Integer;
    function CheckWinner: TPlayer;
    function CheckLine(P1, P2, P3: TPlayer): TPlayer;
    procedure LoadScores;
    procedure SaveScores;
  public
    constructor Create;
    procedure Reset;
    procedure ResetScores;
    function MakeMove(Row, Col: Integer): Boolean;
    function GetCell(Row, Col: Integer): TPlayer;
    function IsValidMove(Row, Col: Integer): Boolean;
    property CurrentPlayer: TPlayer read FCurrentPlayer;
    property Status: TGameStatus read FStatus;
    property MoveCount: Integer read FMoveCount;
    property WinsX: Integer read FWinsX;
    property WinsO: Integer read FWinsO;
  end;

  function PlayerToStr(Player: TPlayer): string;
  function StatusToStr(Status: TGameStatus): string;

var
  Game: TTicTacToeGame;

implementation

uses
  System.SysUtils;

function PlayerToStr(Player: TPlayer): string;
begin
  case Player of
    plX: Result := 'X';
    plO: Result := 'O';
  else
    Result := '';
  end;
end;

function StatusToStr(Status: TGameStatus): string;
begin
  case Status of
    gsPlaying: Result := 'Playing';
    gsWinX: Result := 'X Wins!';
    gsWinO: Result := 'O Wins!';
    gsDraw: Result := 'Draw!';
  end;
end;

{ TTicTacToeGame }

constructor TTicTacToeGame.Create;
begin
  inherited;
  LoadScores;
  Reset;
end;

procedure TTicTacToeGame.LoadScores;
begin
  TPscState.Load;
  FWinsX := TPscState.GetValue<Integer>('ttt_winsX', 0);
  FWinsO := TPscState.GetValue<Integer>('ttt_winsO', 0);
end;

procedure TTicTacToeGame.SaveScores;
begin
  TPscState.SetValue('ttt_winsX', FWinsX);
  TPscState.SetValue('ttt_winsO', FWinsO);
  TPscState.Save;
end;

procedure TTicTacToeGame.ResetScores;
begin
  FWinsX := 0;
  FWinsO := 0;
  SaveScores;
end;

procedure TTicTacToeGame.Reset;
var
  Row, Col: Integer;
begin
  for Row := 0 to 2 do
    for Col := 0 to 2 do
      FBoard[Row, Col] := plNone;

  FCurrentPlayer := plX;
  FStatus := gsPlaying;
  FMoveCount := 0;
end;

function TTicTacToeGame.IsValidMove(Row, Col: Integer): Boolean;
begin
  Result := (FStatus = gsPlaying) and
            (Row >= 0) and (Row <= 2) and
            (Col >= 0) and (Col <= 2) and
            (FBoard[Row, Col] = plNone);
end;

function TTicTacToeGame.MakeMove(Row, Col: Integer): Boolean;
var
  Winner: TPlayer;
begin
  Result := False;

  if not IsValidMove(Row, Col) then
    Exit;

  FBoard[Row, Col] := FCurrentPlayer;
  Inc(FMoveCount);
  Result := True;

  Winner := CheckWinner;

  if Winner = plX then begin
    FStatus := gsWinX;
    Inc(FWinsX);
    SaveScores;
  end
  else if Winner = plO then begin
    FStatus := gsWinO;
    Inc(FWinsO);
    SaveScores;
  end
  else if FMoveCount = 9 then
    FStatus := gsDraw
  else
  begin
    if FCurrentPlayer = plX then
      FCurrentPlayer := plO
    else
      FCurrentPlayer := plX;
  end;

end;

function TTicTacToeGame.GetCell(Row, Col: Integer): TPlayer;
begin
  if (Row >= 0) and (Row <= 2) and (Col >= 0) and (Col <= 2) then
    Result := FBoard[Row, Col]
  else
    Result := plNone;
end;

function TTicTacToeGame.CheckLine(P1, P2, P3: TPlayer): TPlayer;
begin
  if (P1 <> plNone) and (P1 = P2) and (P2 = P3) then
    Result := P1
  else
    Result := plNone;
end;

function TTicTacToeGame.CheckWinner: TPlayer;
var
  I: Integer;
begin
  Result := plNone;

  // Check lines
  for I := 0 to 2 do begin
    Result := CheckLine(FBoard[I, 0], FBoard[I, 1], FBoard[I, 2]);
    if Result <> plNone then
      Exit;
  end;

  // Check Columns
  for I := 0 to 2 do begin
    Result := CheckLine(FBoard[0, I], FBoard[1, I], FBoard[2, I]);
    if Result <> plNone then
      Exit;
  end;

  // Check diagonals
  Result := CheckLine(FBoard[0, 0], FBoard[1, 1], FBoard[2, 2]);
  if Result <> plNone then
    Exit;

  Result := CheckLine(FBoard[0, 2], FBoard[1, 1], FBoard[2, 0]);
end;

initialization
  Game := TTicTacToeGame.Create;

finalization
  Game.Free;
  
end.
