unit View.Scroller;

interface

uses
  Pisces, Global.WebImage;

type

  [ ImageView('horizontal-image'),
    Height(900),
    WidthPercent(1),
    ScaleType(TImageScaleType.CenterCrop)
  ] THorizontalWebImage = class(TBaseWebImage)

  end;

  [ ImageView('vertical-image'),
    Height(900),
    ScaleType(TImageScaleType.CenterCrop)
  ] TVerticalWebImage = class(TBaseWebImage)

  end;

  [ LinearLayout('horizontal-scroller-layout'),
    Orientation(TOrientation.Horizontal)
  ] THorizontalScrollerLayout = class(TPisces)
  private
    FImg1: THorizontalWebImage;
    FImg2: THorizontalWebImage;
    FImg3: THorizontalWebImage;
    FImg4: THorizontalWebImage;
  end;

  [ HorizontalScrollView('horizontal-scroller'),
    HorizontalScrollBarEnabled(True),
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
    Height(900),
    FillViewport(False),
    NestedScrollingEnabled(True)
  ] TVerticalScroller = class(TPisces)
  private
    FScrollerLayout: TVerticalScrollerLayout;
  end;


implementation

end.
