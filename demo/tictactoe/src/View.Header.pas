unit View.Header;

interface

uses
  Pisces;

type

  [ ImageView('header'),
    ImageResource('logo', 'drawable'),
    ScaleType(TImageScaleType.CenterCrop),
    Padding(150, 150, 150, 0)
  ] THeader = class(TPisces)
  end;

  [ LinearLayout('header-container'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top, TGravity.Center]),
    HeightPercent(0.40)
  ] THeaderContainer = class(TPisces)
    FHeader: THeader;
  end;

implementation

end.
