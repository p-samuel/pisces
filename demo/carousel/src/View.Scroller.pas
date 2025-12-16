unit View.Scroller;

interface

uses
  Pisces, Global.WebImage;

type

  [ ImageView('horizontal-image'),
    Height(1100),
    Rotation(-90),
    ScaleType(TImageScaleType.CenterCrop)
  ] THorizontalWebImage = class(TBaseWebImage)

  end;

  [ ImageView('vertical-image'),
    Height(900),
    ScaleType(TImageScaleType.CenterCrop)
  ] TVerticalWebImage = class(TBaseWebImage)

  end;

  [ LinearLayout('horizontal-scroller-layout'),
    Orientation(TOrientation.Vertical)
  ] THorizontalScrollerLayout = class(TPisces)
  private
    FImg1: THorizontalWebImage;
    FImg2: THorizontalWebImage;
    FImg3: THorizontalWebImage;
    FImg4: THorizontalWebImage;
  end;

  [ ScrollView('horizontal-scroller'),
    VerticalScrollBarEnabled(True),
    HorizontalScrollBarEnabled(True),
    HeightPercent(0.5),
    Rotation(90),
    FillViewport(True)
  ] THorizontalScroller = class(TPisces)
  private
    FScrollerLayout: THorizontalScrollerLayout;
  end;

  [ LinearLayout('vertical-scroller-layout'),
    Orientation(TOrientation.Vertical)
  ] TVerticalScrollerLayout = class(TPisces)
  private
    FImg1: TVerticalWebImage;
    FImg2: TVerticalWebImage;
    FImg3: TVerticalWebImage;
    FImg4: TVerticalWebImage;
  end;

  [ ScrollView('vertical-scroller'),
    VerticalScrollBarEnabled(True),
    HorizontalScrollBarEnabled(True),
    HeightPercent(0.33),
    Width(1100),
    FillViewport(False),
    NestedScrollingEnabled(True)
  ] TVerticalScroller = class(TPisces)
  private
    FScrollerLayout: TVerticalScrollerLayout;
  end;


implementation

end.
