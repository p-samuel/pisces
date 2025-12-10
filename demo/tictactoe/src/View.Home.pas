unit View.Home;

interface

uses
 Pisces,
 View.Header,
 View.GameBoard,
 View.Footer;

type
  [ ImageView('home-bg'),
    ImageResource('img-back', 'drawable'),
    ScaleType(TImageScaleType.CenterCrop)
  ] TBackImage = class(TPisces)
  end;

  [ LinearLayout('home-container'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top, TGravity.Center])
  ] THomeContainer = class(TPisces)
    FHeader: THeaderContainer;
    FGameBoard: TGameBoardContainer;
    FFooter: TFooterContainer;
  end;

  [ FrameLayout('home'),
    FullScreen(True),
    Gravity([TGravity.Center]),
    DarkStatusBarIcons(True),
    ScreenOrientation(TScreenOrientation.Portrait)
  ] THomeScreen = class(TPisces)
    FImage: TBackImage;
    FContainer: THomeContainer;
  end;

var
  HomeScreen: THomeScreen;

implementation

{ THomeScreen }

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;

finalization
  HomeScreen.Free;
end.
