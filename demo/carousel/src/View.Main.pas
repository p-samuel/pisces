unit View.Main;

interface

uses
  Pisces,
  View.Container;

type

  [ ScrollView('main-screen'),
    FullScreen(True),
    FillViewPort(True)
  ] TMainScreen = class(TPisces)
  private
    FContainer: TContainer;
  end;

implementation

var
  MainScreen: TMainScreen;

{ TContainer }

initialization
  MainScreen := TMainScreen.Create;
  MainScreen.Show;

finalization
  if Assigned(MainScreen) then
    MainScreen.Free;

end.

