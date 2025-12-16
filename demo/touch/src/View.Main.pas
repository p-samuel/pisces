unit View.Main;

interface

uses
  System.SysUtils,
  Pisces, Pisces.Utils;

type

  [ TextView('text'),
    Text('Touch the screen  '#13#10+ ' and swipe'),
    TextColor(0, 0, 0),
    Height(200),
    TextSize(25),
    Gravity([TGravity.Center])
  ] TTitle = class(TPisces)
  end;

  [ TextView('coord'),
    Text('X: 200, Y: 200'),
    TextColor(0, 0, 0),
    Height(150),
    TextSize(14),
    Gravity([TGravity.Center])
  ] TCoordinates = class(TPisces)
  end;

  // Add a transparent overlay that captures all touch events
  [ View('touch_overlay'),
    BackgroundColor(1, 0, 0, 0.1), // Very subtle background so ripples are visible
    Width(TLayout.MATCH),
    Height(TLayout.MATCH),
    RippleColor(165, 263, 156, 0.9)
  ] TTouchOverlay = class(TPisces)
  public
    procedure OnTouchHandler(AView: JView; Dir: TSwipeDirection; X, Y: Single); override;
  end;

  [ LinearLayout('content'),
    FullScreen(True),
    BackgroundColor(239, 207, 202),
    Gravity([TGravity.Center]),
    Orientation(TOrientation.Vertical)
  ] TContentLayout = class(TPisces)
    Title: TTitle;
    Coordinates: TCoordinates;
  end;

  // Main screen with overlay
  [ FrameLayout('screen'),
    FullScreen(True)
  ] TScreen = class(TPisces)
    ContentLayout: TContentLayout;
    TouchOverlay: TTouchOverlay;  // This will be on top
  end;

var
  Screen: TScreen;

implementation

uses
  Androidapi.Helpers;

{ TTouchOverlay }

procedure TTouchOverlay.OnTouchHandler(AView: JView; Dir: TSwipeDirection; X, Y: Single);
var
  CoordTextView: JView;
  FormattedCoord: String;
begin
  try
    CoordTextView := TPscUtils.FindViewByName('coord');
    if Assigned(CoordTextView) then begin
      FormattedCoord := Format('X: %.2f, Y: %.2f', [X, Y]);

      case Dir of
        TSwipeDirection.Left: FormattedCoord := FormattedCoord + #13#10 + 'Swipping left';
        TSwipeDirection.Right: FormattedCoord := FormattedCoord + #13#10 + 'Swipping right';
        TSwipeDirection.Up: FormattedCoord := FormattedCoord + #13#10 + 'Swipping Up';
        TSwipeDirection.Down: FormattedCoord := FormattedCoord + #13#10 + 'Swipping Down';
        TSwipeDirection.Touch: FormattedCoord := FormattedCoord + #13#10 + 'Touch';
        TSwipeDirection.Leave: FormattedCoord := FormattedCoord + #13#10 + 'Leave';
      end;

      JTextView(CoordTextView).setText(StrToJCharSequence(FormattedCoord));
    end;
  except
    on E: Exception do begin
      TPscUtils.Toast('Error finding/setting text view', TJToast.JavaClass.LENGTH_SHORT);
    end;
  end;
end;

initialization
  Screen := TScreen.Create;
  Screen.Show;

finalization
  Screen.Free;

end.

