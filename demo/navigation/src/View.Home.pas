unit View.Home;

interface

uses
  Pisces;

type

  [ LinearLayout('home'),
    BackgroundColor(27, 274, 91),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Center]),
    RippleColor(29, 294, 120)
  ] THomeScreen = class(TPisces)
  private

  end;

var
  HomeScreen: THomeScreen;

implementation

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;

finalization
  HomeScreen.Free;

end.
