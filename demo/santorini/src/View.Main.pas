unit View.Main;

interface

uses
  Pisces;

type

  [ ImageView('img'),
    ImageResource('santo', 'drawable'),
    RippleColor(233, 233, 236, 0.2),
    HeightPercent(0.5),
    Elevation(100),
    Alpha(0.8),
    ScaleType(TImageScaleType.CenterCrop)
  ] TImage = class(TPisces)

  end;

  [ TextView('title'),
    Text('Santorini'),
    Gravity([TGravity.Center]),
    TextSize(34),
    TextColor(255, 255, 255),
    Padding(50, 50, 50, 50),
    Height(250)
  ] TTitle = class(TPisces)

  end;

  [ TextView('description'),
    TextSize(22),
    Justify(True, THyphenStrg.Full, TBreakStrg.HighQuality),
    TextColor(255, 255, 255),
    Padding(50, 0, 50, 0),
    AutoLinkMask(1)
  ] TDescription = class(TPisces)
    procedure AfterShow; override;
  end;

  [ LinearLayout('layout'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top, TGravity.Center])
  ] TLayout = class(TPisces)
    Image: TImage;
    Title: TTitle;
    Description: TDescription;
  end;

  [ ScrollView('scrow'),
    FullScreen(True),
    VerticalScrollBarEnabled(True),
    BackgroundColor(0, 0, 0),
    DarkStatusBarIcons(True)
  ] TScroll = class(TPisces)
    Content: TLayout;
  public
    procedure OnTouchHandler(AView: JView; Direction: TSwipeDirection; X, Y: Single); override;
    procedure OnActivityConfigurationChangedHandler(Activity: JActivity); override;
  end;

var
  Screen: TScroll;

implementation

{ AfterCreate }

procedure TDescription.AfterShow;
const
  SantoriniDescription: string =
    'Santorini, known since ancient times as Thira, is one of the most famous '
    + 'islands in the world. The fact that you can sit in front of the caldera, '
    + 'enjoy local dishes, a drink or a coffee while gazing at the remarkable '
    + 'beauty of an active volcano is priceless!' + #13#10#13#10
    + 'The island is actually a group of islands consisting of Thira, Thirassia, '
    + 'Aspronissi, Palea and Nea Kameni in the southernmost part of the Cyclades.'
    + #13#10#13#10
    + 'Santorini''s volcano is one of the few active volcanoes on Greek and European '
    + 'land The islands that form Santorini came into existence as a result of '
    + 'intensive volcanic activity; twelve huge eruptions occurred, one every 20,000 '
    + 'years approximately, and each violent eruption caused the collapse of the '
    + 'volcano''s central part creating a large crater (caldera). The volcano, however, '
    + 'managed to recreate itself over and over again.'
    + #13#10#13#10
    + 'Source: https://www.google.com';
begin
  inherited;
  JTextView(AndroidView).setText(TAndroidHelper.StrToJCharSequence(SantoriniDescription));
end;

{ TScroll }

procedure TScroll.OnActivityConfigurationChangedHandler(Activity: JActivity);
begin
  TPscUtils.Log('Screen Tilted', 'OnConfigurationChangedHandler', TLogger.Info, Self);
  Screen.Hide;
  Screen.Initialize;
  Screen.Show;
end;

procedure TScroll.OnTouchHandler(AView: JView; Direction: TSwipeDirection; X, Y: Single);
begin
  inherited;
  case Direction of
    TSwipeDirection.Left: TPscUtils.Log('Left', 'Swipe', TLogger.Info, Self);
    TSwipeDirection.Right: TPscUtils.Log('Right', 'Swipe', TLogger.Info, Self);
    TSwipeDirection.Up: TPscUtils.Log('Up', 'Swipe', TLogger.Info, Self);
    TSwipeDirection.Down: TPscUtils.Log('Down', 'Swipe', TLogger.Info, Self);
    TSwipeDirection.Touch: TPscUtils.Log('Touch', 'Swipe', TLogger.Info, Self);
    TSwipeDirection.Leave: TPscUtils.Log('Leave', 'Swipe', TLogger.Info, Self);
  end;
end;


initialization
  Screen := TScroll.Create;
  Screen.Show;

finalization
  Screen.Free;


end.
