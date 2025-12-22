unit View.Home;

interface

uses
  Pisces;

type
  // 1) Basic typography / background / ripple
  [ TextView('title'),
    Text('TextView capability tour'),
    TextColor(255, 255, 255),
    TextSize(26),
    BackgroundColor(38, 52, 80),
    RippleColor(255, 255, 255, 0.25),
    Gravity([TGravity.Center]),
    Padding(24, 24, 24, 16),
    Width(TLayout.MATCH),
    Height(400)
  ] TTitle = class(TPisces) end;

  // 2) Justification + hyphenation + break strategy
  [ TextView('justify'),
    Text('Justification, hyphenation, and break strategy working together for multi-line body copy across several sentences to show how spacing, breaks, and readability hold up in longer paragraphs even on tighter widths.'),
    TextColor(230, 230, 230),
    TextSize(16),
    Justify(True, THyphenStrg.Normal, TBreakStrg.HighQuality),
    LineSpacing(6, 1.12),
    LineBreakStyle(TLineBreakStyle.LineBreakNormal),
    LineBreakWordStyle(TLineBreakWordStyle.LineBreakWordPhrase),
    MinLines(2),
    Height(400),
    BackgroundColor(24, 28, 36),
    RippleColor(255, 255, 255, 0.25),
    Padding(12, 12, 12, 12)
  ] TJustify = class(TPisces) end;

  // 3) Auto-linking, selectable links, link colors
  [ TextView('links'),
    Text('Email: hello@example.com' + #13#10 +
         'Phone: +1-415-555-0100' + #13#10 +
         'Web: https://github.com/p-samuel/pisces'),
    TextColor(220, 220, 220),
    LinkTextColor(52, 152, 219),
    AutoLinkMask([TAutoLink.AutoLinkWeb, TAutoLink.AutoLinkEmail, TAutoLink.AutoLinkPhone, TAutoLink.AutoLinkMap]),
    LinksClickable(True),
    TextIsSelectable(True),
    BackgroundColor(46, 58, 88),
    RippleColor(255, 255, 255, 0.25),
    Height(400),
    Padding(12, 12, 12, 12)
  ] TLinks = class(TPisces) end;

  // 4) Line/spacing/letter metrics and min/max constraints
  [ TextView('metrics'),
    Text('Line spacing, line height, min/max lines, ems, and scale.'),
    TextColor(240, 240, 240),
    TextSize(15),
    LineSpacing(4, 1.08),
    LineHeight(38),
    LetterSpacing(0.08),
    TextScaleX(1.05),
    MinLines(2),
    MaxLines(4),
    MinEms(10),
    MaxEms(24),
    Ems(14),
    Height(400),
    Padding(12, 10, 12, 10),
    BackgroundColor(48, 52, 60),
    RippleColor(255, 255, 255, 0.25)
  ] TMetrics = class(TPisces) end;

  // 5) Bounds, padding removal, baseline spacing
  [ TextView('bounds'),
    Text('Width/height, include font padding off, baseline offset.'),
    TextColor(240, 240, 240),
    BackgroundColor(56, 64, 80),
    RippleColor(255, 255, 255, 0.25),
    Width(760),
    Height(400),
    IncludeFontPadding(False),
    LastBaselineToBottomHeight(20),
    Padding(10, 6, 10, 6),
    Gravity([TGravity.Center])
  ] TBounds = class(TPisces) end;

  // 6) Marquee / single-line / repeat control
  [ TextView('marquee'),
    Text('Marquee sample - long text scrolling to show marquee repeat limit. Marquee sample - long text scrolling to show marquee repeat limit.'),
    TextColor(255, 235, 59),
    TextSize(16),
    SingleLine(True),
    HorizontallyScrolling(True),
    MarqueeRepeatLimit(3),
    BackgroundColor(30, 42, 64),
    RippleColor(255, 255, 255, 0.25),
    Selected(True),
    Height(400),
    Padding(12, 12, 12, 12)
  ] TMarquee = class(TPisces)
  public
    procedure AfterShow; override;
  end;

  // 7) Shadows, highlights, all-caps
  [ TextView('shadow'),
    Text('Shadow layer + highlight color + ALL CAPS'),
    AllCaps(True),
    TextColor(255, 255, 255),
    TextSize(50),
    ShadowLayer(10, 5, 5, 0, 0, 0, 0.93),
    HighlightColor(255, 215, 64),
    BackgroundColor(221, 221, 221),
    RippleColor(255, 255, 255, 0.25),
    Padding(18, 24, 18, 24),
    Height(400)
  ] TShadow = class(TPisces) end;

  // 8) Paint flags (underline + strike), fallback spacing, freezes text
  [ TextView('paint'),
    Text('Paint flags (underline + strike) with frozen text state'),
    TextColor(236, 239, 241),
    PaintFlags([TPaintFlag.PaintUnderline, TPaintFlag.PaintStrikeThrough]),
    FallbackLineSpacing(True),
    FreezesText(True),
    BackgroundColor(40, 44, 50),
    RippleColor(255, 255, 255, 0.25),
    Height(400),
    Padding(12, 10, 12, 10)
  ] TPaintFlags = class(TPisces) end;

  // 9) Input/focus on TextView (show keyboard, cursor, selectable)
  [ TextView('inputmode'),
    Text('Focusable TextView with input type, cursor, and soft input'),
    TextColor(224, 224, 224),
    InputType(TInputType.TextMultiLine),
    CursorVisible(True),
    ShowSoftInputOnFocus(True),
    FocusableInTouchMode(TFocusableMode.FocusablesTouchMode),
    SelectAllOnFocus(True),
    MinHeight(140),
    Gravity([TGravity.Top, TGravity.Start]),
    Padding(12, 12, 12, 12),
    BackgroundColor(32, 40, 52),
    RippleColor(255, 255, 255, 0.25),
    Height(400)
  ] TInputMode = class(TPisces) end;

  // 10) Text appearance (system style) + hint colors
  [ TextView('appearance'),
    Text('TextAppearance.Material.Body1 with hint + selectable text'),
    TextAppearance('TextAppearance.Material.Body1', 'style'),
    Hint('System text appearance sample'),
    HintTextColor(150, 150, 150),
    TextColor(236, 236, 236),
    TextIsSelectable(True),
    BackgroundColor(52, 60, 82),
    RippleColor(255, 255, 255, 0.25),
    Height(400),
    Padding(12, 10, 12, 10)
  ] TAppearance = class(TPisces) end;

  // 11) Mixed styling block
  [ TextView('styled'),
    Text('Mixed styling: bold-ish appearance, highlight, underline + strike, and justified to show combined effects.'),
    TextAppearance('TextAppearance.Material.Medium', 'style'),
    FontStyle(TFontStyle.BoldItalic),
    FontFamily('sans-serif'),
    FontWeight(700),
    TextSize(18),
    HighlightColor(255, 230, 120),
    PaintFlags([TPaintFlag.PaintUnderline, TPaintFlag.PaintStrikeThrough]),
    Justify(True, THyphenStrg.Normal, TBreakStrg.HighQuality),
    LineSpacing(4, 1.05),
    BackgroundColor(44, 56, 76),
    RippleColor(255, 255, 255, 0.25),
    TextColor(245, 245, 245),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TStyled = class(TPisces) end;

  // 12) Font family + weight + style combo
  [ TextView('fonts'),
    Text('Font family/weight/style: serif, 600 weight, italic — to show how typeface controls combine.'),
    FontFamily('serif'),
    FontWeight(600),
    FontStyle(TFontStyle.Italic),
    TextSize(18),
    LineSpacing(4, 1.05),
    BackgroundColor(36, 48, 70),
    RippleColor(255, 255, 255, 0.25),
    TextColor(240, 240, 240),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TFonts = class(TPisces) end;

  // 13) Condensed headline with heavy weight
  [ TextView('condensed'),
    Text('Condensed headline with heavier weight for compact titles.'),
    FontFamily('sans-serif-condensed'),
    FontWeight(700),
    TextSize(24),
    AllCaps(True),
    BackgroundColor(60, 70, 90),
    RippleColor(255, 255, 255, 0.25),
    TextColor(245, 245, 245),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TCondensed = class(TPisces) end;

  // 14) Serif paragraph with justification and hyphenation
  [ TextView('serif'),
    Text('Serif paragraph showcasing justification, hyphenation, and break styles for longer reading text.'),
    FontFamily('serif'),
    FontStyle(TFontStyle.Italic),
    FontWeight(500),
    TextSize(17),
    Justify(True, THyphenStrg.Normal, TBreakStrg.HighQuality),
    LineBreakStyle(TLineBreakStyle.LineBreakNormal),
    LineBreakWordStyle(TLineBreakWordStyle.LineBreakWordPhrase),
    LineSpacing(4, 1.08),
    BackgroundColor(28, 36, 50),
    RippleColor(255, 255, 255, 0.25),
    TextColor(238, 238, 238),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TSerif = class(TPisces) end;

  // 15) Monospace "code-like" sample with spacing tweaks
  [ TextView('monospace'),
    Text('Monospace sample: code_like_method(); align = fixed; spacing = tuned;'),
    FontFamily('monospace'),
    FontWeight(500),
    LetterSpacing(0.05),
    LineHeight(34),
    PaintFlags([TPaintFlag.PaintUnderline]),
    BackgroundColor(34, 44, 54),
    RippleColor(255, 255, 255, 0.25),
    TextColor(220, 230, 245),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TMonospace = class(TPisces) end;

  // 16) Ultra black weight for bold emphasis
  [ TextView('blackweight'),
    Text('Ultra heavy weight for emphatic labels or counters.'),
    FontFamily('sans-serif-black'),
    FontWeight(900),
    TextSize(22),
    BackgroundColor(24, 32, 50),
    RippleColor(255, 255, 255, 0.25),
    TextColor(250, 250, 250),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TBlackWeight = class(TPisces) end;

  // 17) Light sans with italic accent
  [ TextView('lightitalic'),
    Text('Light sans with italic slant to contrast against heavier weights.'),
    FontFamily('sans-serif-light'),
    FontWeight(300),
    FontStyle(TFontStyle.Italic),
    TextSize(18),
    LineSpacing(4, 1.05),
    BackgroundColor(48, 58, 78),
    RippleColor(255, 255, 255, 0.25),
    TextColor(236, 236, 236),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TLightItalic = class(TPisces) end;

  // 18) Ultra-thin sans with soft shadow for legibility
  [ TextView('thin'),
    Text('Ultra-thin sans sample with a soft shadow to keep strokes visible.'),
    FontFamily('sans-serif-thin'),
    FontWeight(200),
    TextSize(22),
    ShadowLayer(6, 2, 2, 0, 0, 0, 0.4),
    BackgroundColor(26, 34, 46),
    RippleColor(255, 255, 255, 0.25),
    TextColor(235, 235, 235),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TThin = class(TPisces) end;

  // 19) Cursive script with highlight and relaxed spacing
  [ TextView('cursive'),
    Text('Cursive sample to show script rendering with highlight and looser spacing.'),
    FontFamily('cursive'),
    FontStyle(TFontStyle.Italic),
    TextSize(20),
    HighlightColor(255, 230, 160),
    LineSpacing(6, 1.12),
    BackgroundColor(50, 54, 62),
    RippleColor(255, 255, 255, 0.25),
    TextColor(236, 230, 220),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TCursive = class(TPisces) end;

  // 20) Condensed light body text with justification
  [ TextView('condensedlight'),
    Text('Condensed light body text packed with justification for dense layouts.'),
    FontFamily('sans-serif-condensed'),
    FontWeight(300),
    TextSize(17),
    Justify(True, THyphenStrg.Normal, TBreakStrg.HighQuality),
    LineBreakStyle(TLineBreakStyle.LineBreakNormal),
    LineBreakWordStyle(TLineBreakWordStyle.LineBreakWordPhrase),
    LineSpacing(4, 1.08),
    BackgroundColor(42, 52, 66),
    RippleColor(255, 255, 255, 0.25),
    TextColor(232, 232, 232),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TCondensedLight = class(TPisces) end;

  // 21) Mixed weights in a vertical stack (label + detail)
  [ TextView('mixedlabel'),
    Text('Black weight label'),
    FontFamily('sans-serif-black'),
    FontWeight(900),
    TextSize(22),
    TextColor(250, 250, 250),
    RippleColor(255, 255, 255, 0.25),
    WidthPercent(0.5)
  ] TLabelView = class(TPisces) end;

  [ TextView('mixeddetail'),
    Text('Light detail line to contrast the label weight.'),
    FontFamily('sans-serif-light'),
    FontWeight(300),
    TextSize(16),
    TextColor(220, 220, 220),
    Padding(0, 8, 0, 0),
    RippleColor(255, 255, 255, 0.25),
    WidthPercent(0.5)
  ] TDetailView = class(TPisces) end;

  [ LinearLayout('mixedweights'),
    Orientation(TOrientation.Horizontal),
    BackgroundColor(20, 26, 36),
    Padding(14, 18, 14, 18),
    Height(400)
  ] TMixedWeights = class(TPisces)
    LabelView: TLabelView;
    DetailView: TDetailView;
  end;

  // Content stack
  [ LinearLayout('content'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top, TGravity.CenterHorizontal]),
    BackgroundColor(14, 20, 30),
    Height(400)
  ] TContent = class(TPisces)
    Title: TTitle;
    Justify: TJustify;
    Links: TLinks;
    Metrics: TMetrics;
    Bounds: TBounds;
    Marquee: TMarquee;
    Shadow: TShadow;
    PaintFlags: TPaintFlags;
    InputMode: TInputMode;
    Appearance: TAppearance;
    Styled: TStyled;
    Fonts: TFonts;
    Condensed: TCondensed;
    Serif: TSerif;
    Monospace: TMonospace;
    BlackWeight: TBlackWeight;
    LightItalic: TLightItalic;
    Thin: TThin;
    Cursive: TCursive;
    CondensedLight: TCondensedLight;
    MixedWeights: TMixedWeights;
  end;

  [ ScrollView('home'),
    FullScreen(True),
    FillViewport(true)
  ] THomeView = class(TPisces)
    Content: TContent;
  end;

var
  HomeView: THomeView;

implementation

uses
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.Helpers,
  Pisces.Utils;

{ TMarquee }

procedure TMarquee.AfterShow;
var
  V: JView;
begin
  inherited;
  V := TPscUtils.FindViewByName('marquee');
  if V <> nil then
  begin
    JTextView(V).setEllipsize(TJTextUtils_TruncateAt.JavaClass.MARQUEE);
    JTextView(V).setSelected(True);
    JTextView(V).setHorizontallyScrolling(True);
    JTextView(V).setMarqueeRepeatLimit(3);
  end;
end;

initialization
  HomeView := THomeView.Create;
  HomeView.Show;

finalization
  HomeView.Free;

end.
