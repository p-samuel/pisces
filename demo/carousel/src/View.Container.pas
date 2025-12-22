unit View.Container;

interface

uses
  Pisces, View.Scroller;

type
  [ TextView('title'),
    Text('Web Image Example'),
    TextSize(24),
    TextColor(235, 235, 235),
    Height(400),
    Gravity([TGravity.Center])
  ] TTitle = class(TPisces)
  end;

  [ TextView('status'),
    Text('Loading image...'),
    TextSize(16),
    TextColor(235, 235, 235),
    Height(80),
    Gravity([TGravity.Center])
  ] TStatus = class(TPisces)
  end;

  [ LinearLayout('container'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Center]),
    BackgroundColor(0, 0, 0),
    OverScrollMode(TOverScrollMode.Always)
  ] TContainer = class(TPisces)
    FTitle: TTitle;
    FHorxScroller: THorizontalScroller;
    FVertScroller: TVerticalScroller;
    FHorxScroller2: THorizontalScroller;
    FVertScrolle2: TVerticalScroller;
    FStatus: TStatus;
  public
    procedure AfterShow; override;
  end;


implementation

{ TContainer }

procedure TContainer.AfterShow;
begin
  inherited;
  TPscUtils.Log('Container created', 'AfterShow', TLogger.Info, Self);
end;

end.

