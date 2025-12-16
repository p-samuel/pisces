unit View.Main;

interface

uses
  Pisces;

type

  // Base layer
  TBaseLayer = class(TPisces)
  private
    FCurrentTheme: Integer;
    FColorStops: TColorStopArray;
    procedure Touch(AView: JView); virtual;
  public
    constructor Create; override;
  end;

  // Touch layer
  [ View('touch_overlay'),
    BackgroundColor(1, 0, 0, 0.1),
    RippleColor(255, 255, 255, 0.4)
  ] TTouchOverlay = class(TBaseLayer)
    procedure OnClickHandler(AView: JView); override;
  end;

  // Linear
  [ TextView('linear-grad-title'),
    Text('Linear'),
    TextSize(22),
    TextColor(255, 255, 255),
    Gravity([TGravity.Center]),
    Clickable(False)
  ] TLinearGradientTitle = class(TPisces)
  end;

  [ FrameLayout('linear-gradient'),
    MultiGradient(
      233, 30, 99, 1.0,
      103, 58, 183, 1.0,
    TGradientOrientation.BottomToTop, 0, 0, TGradientShape.Linear),
    Height(900),
    Gravity([TGravity.Center])
  ] TLinearGradient = class(TPisces)
  private
    FTitle: TLinearGradientTitle;
    FTouchOverlay: TTouchOverlay;
  end;

  // Radial
  [ TextView('radial-grad-title'),
    Text('Radial'),
    TextSize(22),
    TextColor(255, 255, 255),
    Gravity([TGravity.Center])
  ] TRadialGradientTitle = class(TPisces)

  end;

  [ FrameLayout('radial-gradient'),
    MultiGradient(
      255, 94, 77, 1.0,
      255, 154, 0, 0.9,
      255, 206, 84, 0.8,
      255, 235, 59, 0.6,
    TGradientOrientation.BottomToTop, 0, 900, TGradientShape.Radial),
    Height(900),
    Gravity([TGravity.Center])
  ] TRadialGradient = class(TPisces)
    FTitle: TRadialGradientTitle;
    FTouchOverlay: TTouchOverlay;
  end;

  //Sweep
  [ TextView('Sweep-grad-title'),
    Text('Sweep'),
    TextSize(22),
    TextColor(255, 255, 255),
    Gravity([TGravity.Center])
  ] TSweepGradientTitle = class(TPisces)

  end;

  [ FrameLayout('sweep-gradient'),
    MultiGradient(
      135, 206, 235, 0.3,
      70, 130, 180, 0.6,
      25, 25, 112, 0.8,
      0, 0, 139, 1.0,
    TGradientOrientation.BottomToTop, 0, 900, TGradientShape.Sweep),
    Height(900),
    Gravity([TGravity.Center])
  ] TSweepGradient = class(TPisces)
    FTitle: TSweepGradientTitle;
    FTouchOverlay: TTouchOverlay;
  end;

  // Scrollview
  [ LinearLayout('content'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(1, 0, 0)
  ] TContent = class(TPisces)
    FLinear: TLinearGradient;
    FRadial: TRadialGradient;
    FSweep: TSweepGradient;
  end;

  [ ScrollView('screen'),
    FullScreen(True),
    FillViewport(True)
  ] TScreen = class(TPisces)
    FContent: TContent;
  end;

var
  Screen: TScreen;

implementation

{ TTouchOverlay }

constructor TBaseLayer.Create;
begin
  inherited;
  FCurrentTheme := 0;
end;

procedure TBaseLayer.Touch(AView: JView);
begin
  Inc(FCurrentTheme);
  TPscUtils.Toast('Touching', TJToast.JavaClass.LENGTH_SHORT);

  case FCurrentTheme mod 5 of
    0: // Nature theme
    begin
      SetLength(FColorStops, 3);
      FColorStops[0] := TColorStop.Create(76, 175, 80, 1.0);    // Green
      FColorStops[1] := TColorStop.Create(139, 195, 74, 1.0);   // Light green
      FColorStops[2] := TColorStop.Create(0, 188, 212, 1.0);    // Cyan
      TPscUtils.Toast('Nature Theme', TJToast.JavaClass.LENGTH_SHORT);
    end;
    1: // Fire theme
    begin
      SetLength(FColorStops, 4);
      FColorStops[0] := TColorStop.Create(255, 87, 34, 1.0);    // Orange
      FColorStops[1] := TColorStop.Create(255, 193, 7, 1.0);    // Amber
      FColorStops[2] := TColorStop.Create(255, 235, 59, 1.0);   // Yellow
      FColorStops[3] := TColorStop.Create(255, 87, 34, 1.0);    // Back to orange
      TPscUtils.Toast('Fire Theme', TJToast.JavaClass.LENGTH_SHORT);
    end;
    2: // Ocean theme
    begin
      SetLength(FColorStops, 3);
      FColorStops[0] := TColorStop.Create(33, 150, 243, 1.0);   // Blue
      FColorStops[1] := TColorStop.Create(63, 81, 181, 1.0);    // Indigo
      FColorStops[2] := TColorStop.Create(103, 58, 183, 1.0);   // Purple
      TPscUtils.Toast('Ocean Theme', TJToast.JavaClass.LENGTH_SHORT);
    end;
    3: // Sunset theme
    begin
      SetLength(FColorStops, 4);
      FColorStops[0] := TColorStop.Create(255, 94, 77, 1.0);    // Red-orange
      FColorStops[1] := TColorStop.Create(255, 154, 0, 1.0);    // Orange
      FColorStops[2] := TColorStop.Create(255, 206, 84, 1.0);   // Yellow-orange
      FColorStops[3] := TColorStop.Create(156, 39, 176, 1.0);   // Purple
      TPscUtils.Toast('Sunset Theme', TJToast.JavaClass.LENGTH_SHORT);
    end;
    4: // Neon theme
    begin
      SetLength(FColorStops, 3);
      FColorStops[0] := TColorStop.Create(255, 0, 255, 1.0);    // Magenta
      FColorStops[1] := TColorStop.Create(0, 255, 255, 1.0);    // Cyan
      FColorStops[2] := TColorStop.Create(255, 255, 0, 1.0);    // Yellow
      TPscUtils.Toast('Neon Theme', TJToast.JavaClass.LENGTH_SHORT);
    end;
  end;
end;

{ TTouchOverlay }

procedure TTouchOverlay.OnClickHandler(AView: JView);
begin
  TPscUtils.SetMultiGradientBackground(AndroidParentView, FColorStops, TGradientOrientation.LeftToRight, 0, 0, TGradientShape.Linear);
  Touch(AView);
end;

initialization
  Screen := TScreen.Create;
  Screen.Show;

finalization
  Screen.Free;

end.

