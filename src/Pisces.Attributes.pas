unit Pisces.Attributes;

interface

uses
  Pisces.Types,
  System.SysUtils, Androidapi.JNIBridge;

type
  // Visual Components
  TPiscesViewAttribute = class(TCustomAttribute)
  private
    FComponentName: String;
  public
    constructor Create(ComponentName: String); overload;
    property Value: String read FComponentName;
    function GetUniqueId: Integer;
    property ComponentName: String read FComponentName;
  end;

  ViewAttribute = class(TPiscesViewAttribute);
  TextViewAttribute = class(TPiscesViewAttribute);
  ButtonAttribute = class(TPiscesViewAttribute);
  SwitchButtonAttribute = class(TPiscesViewAttribute);
  EditAttribute = class(TPiscesViewAttribute);
  ImageViewAttribute = class(TPiscesViewAttribute);
  ViewGroupAttribute = class(TPiscesViewAttribute);
  LinearLayoutAttribute = class(TPiscesViewAttribute);
  RelativelayoutAttribute = class(TPiscesViewAttribute);
  AbsoluteLayoutAttribute = class(TPiscesViewAttribute);
  ToolBarAttribute = class(TPiscesViewAttribute);
  FrameLayoutAttribute = class(TPiscesViewAttribute);
  ScrollViewAttribute = class(TPiscesViewAttribute);
  TimePickerAttribute = class(TPiscesViewAttribute);
  DatePickerAttribute = class(TPiscesViewAttribute);
  CalendarAttribute = class(TPiscesViewAttribute);
  //AdapterViewAttribute = class(TPiscesViewAttribute);
  ListViewAttribute = class(TPiscesViewAttribute);

  // Properties
  TPiscesStringAttribute = class(TCustomAttribute)
  private
    FValue: String;
  public
    constructor Create(Value: String);
    property Value: String read FValue;
  end;

  TPiscesIntegerAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(Value: Integer);
    property Value: Integer read FValue;
  end;

  TPiscesBooleanAttribute = class(TCustomAttribute)
  private
    FValue: Boolean;
  public
    constructor Create(Value: Boolean);
    property Value: Boolean read FValue;
  end;

  TPiscesDoubleAttribute = class(TCustomAttribute)
  private
    FValue: Double;
  public
    constructor Create(Value: Double);
    property Value: Double read FValue;
  end;

  TPiscesColorAttribute = class(TCustomAttribute)
  private
    FColor: Integer;
  public
    constructor Create(const Red, Green, Blue: Integer; Alpha: Double); overload;
    constructor Create(const Red, Green, Blue: Integer); overload;
    property Value: Integer read FColor;
  end;

  TMultiGradientAttribute = class(TCustomAttribute)
  private
    FColorStops: TColorStopArray;
    FOrientation: TGradientOrientation;
    FCornerRadius: Single;
    FShape: TGradientShape;
    FGradientRadius: Single;
    function ColorStopToAndroidColor(const ColorStop: TColorStop): Integer;
    procedure AddColorStop(Red, Green, Blue: Integer; Alpha: Double);
  public
    constructor Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape = TGradientShape.Linear); overload;
    constructor Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape = TGradientShape.Linear); overload;
    constructor Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape = TGradientShape.Linear); overload;
    constructor Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; R5, G5, B5: Integer; A5: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape = TGradientShape.Linear); overload;
    constructor Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; R5, G5, B5: Integer; A5: Double; R6, G6, B6: Integer; A6: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape = TGradientShape.Linear); overload;
    constructor Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; R5, G5, B5: Integer; A5: Double; R6, G6, B6: Integer; A6: Double; R7, G7, B7: Integer; A7: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape = TGradientShape.Linear); overload;
    property ColorStops: TColorStopArray read FColorStops;
    property Orientation: TGradientOrientation read FOrientation;
    property CornerRadius: Single read FCornerRadius;
    property Shape: TGradientShape read FShape;
    property GradientRadius: Single read FGradientRadius;
    function GetAndroidColors: TJavaArray<Integer>;
    function GetPositions: TJavaArray<Single>;
  end;

  THeightAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(AHeight: Integer); overload;
    constructor Create(AHeight: TLayout); overload;
    property Value: Integer read FValue;
  end;

  TWidthAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(AWidth: Integer); overload;
    constructor Create(AWidth: TLayout); overload;
    property Value: Integer read FValue;
  end;

  TWidthPercentAttribute = class(TCustomAttribute)
  private
    FValue: Single;
  public
    constructor Create(APercent: Single);
    property Value: Single read FValue;
  end;

  THeightPercentAttribute = class(TCustomAttribute)
  private
    FValue: Single;
  public
    constructor Create(APercent: Single);
    property Value: Single read FValue;
  end;

  TPositionAttribute = class(TCustomAttribute)
  private
    FX, FY: Single;
  public
    constructor Create(ValueX, ValueY: Single);
    property X: Single read FX;
    property Y: Single read FY;
  end;

  TPaddingAttribute = class(TCustomAttribute)
  private
    FRight, FTop, FLeft, FBottom: Integer;
  public
    constructor Create(ARight, ATop, ALeft, ABottom: Integer);
    property Right: Integer read FRight;
    property Top: Integer read FTop;
    property Left: Integer read FLeft;
    property Bottom: Integer read FBottom;
  end;

  TLayoutDirection = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(Direction: TLytDirection);
    property Value: Integer read FValue;
  end;

  TPiscesSingleAttribute = class(TCustomAttribute)
  private
    FValue: Single;
  public
    constructor Create(AValue: Single);
    property Value: Single read FValue;
  end;

  TGravityAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(const Modes: TGravitySet);
    property Value: Integer read FValue;
  end;

  TJustifyAttribute = class(TCustomAttribute)
  private
    FJustify: Boolean;
    FHyphenation: THyphenStrg;
    FTextBreak: TBreakStrg;
  public
    constructor Create(IsJustify: Boolean); overload;
    constructor Create(IsJustify: Boolean; AHyphenStrategy: THyphenStrg); overload;
    constructor Create(IsJustify: Boolean; AHyphenStrategy: THyphenStrg; ATextBreakStrategy: TBreakStrg); overload;
    constructor Create(IsJustify: Boolean; ATextBreakStrategy: TBreakStrg); overload;
    property Justify: Boolean read FJustify;
    property HyphenStrategy: THyphenStrg read FHyphenation;
    property TextBreakStrategy: TBreakStrg read FTextBreak;
  end;

  TAccessibilityLiveRegionAttribute = class(TCustomAttribute)
  private
    FMode: Integer;
  public
    constructor Create(Mode: TAccessibilityLiveRegion);
    property Value: Integer read FMode;
  end;

  TResourceAttribute = class(TCustomAttribute)
  private
    FResourceName: String;
    FLocation: String;
  public
    constructor Create(AResourceName, ALocation: String);
    property ResourceName: String read FResourceName;
    property Location: String read FLocation;
  end;

  TBackgroundResourceAttribute = class(TResourceAttribute);

  TDrawingCacheQualityAttribute = class(TCustomAttribute)
  private
    FQuality: Integer;
  public
    constructor Create(Quality: TDrawingCacheQuality);
    property Quality: Integer read FQuality;
  end;

  TFocusableInTouchModeAttribute = class(TCustomAttribute)
  private
    FMode: Integer;
  public
    constructor Create(Mode: TFocusableMode);
    property Mode: Integer read FMode;
  end;

  TLeftTopRightBottomAttribute = class(TCustomAttribute)
  private
    FLeft, FTop, FRight, FBottom: Integer;
  public
    constructor Create(ALeft, ATop, ARight, ABottom: Integer);
    property Left: Integer read FLeft;
    property Top: Integer read FTop;
    property Right: Integer read FRight;
    property Bottom: Integer read FBottom;
  end;

  TOverScrollModeAttribute = class(TCustomAttribute)
  private
    FMode: Integer;
  public
    constructor Create(Mode: TOverScrollMode);
    property Mode: Integer read FMode;
  end;

  THintAttribute = class(TCustomAttribute)
  private
    FHint: String;
  public
    constructor Create(AHint: String); overload;
    constructor Create(AResId: Integer); overload;
    property Hint: String read FHint;
  end;

  TScrollIndicatorsAttribute = class(TCustomAttribute)
  private
    FIndicators: Integer;
  public
    constructor Create(Indicators: TScrollIndicatorSet);
    property Indicators: Integer read FIndicators;
  end;

  TLineSpacingAttribute = class(TCustomAttribute)
  private
    FAdd: Single;
    FMult: Single;
  public
    constructor Create(Add: Single; Mult: Single);
    property _Add: Single read FAdd;
    property Mult: Single read FMult;
  end;

  TShadowLayerAttribute = class(TCustomAttribute)
  private
    FRadius: Single;
    FDX: Single;
    FDY: Single;
    FColor: Integer;
  public
    constructor Create(Radius, DX, DY: Single; Color: Integer);
    property Radius: Single read FRadius;
    property DX: Single read FDX;
    property DY: Single read FDY;
    property Color: Integer read FColor;
  end;

  TSelectionAttribute = class(TCustomAttribute)
  private
    FStart: Integer;
    FStop: Integer;
    FIndex: Integer;
  public
    constructor Create(Idx: Integer); overload;
    constructor Create(StartIdx: Integer; StopIdx: Integer); overload;
    property Start: Integer read FStart;
    property Stop: Integer read FStop;
    property Index_: Integer read FIndex;
  end;

  TTextAttribute = class(TCustomAttribute)
  private
    FText: String;
    FBufferType: TTextBuffer;
  public
    constructor Create(Value: String); overload;
    constructor Create(Value: String; Buffer: TTextBuffer); overload;
    property Value: String read FText;
    property BufferType: TTextBuffer read FBufferType;
  end;

  TOrientationAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(Orientation: TOrientation);
    property Value: Integer read FValue;
  end;

  TInputTypeAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(InputType: TInputType);
    property Value: Integer read FValue;
  end;

  TCalendarDateAttribute = class(TCustomAttribute)
  private
    FYear: Integer;
    FMonth: Integer;
    FDay: Integer;
  public
    constructor Create(AYear, AMonth, ADay: Integer);
    property Year: Integer read FYear;
    property Month: Integer read FMonth;
    property Day: Integer read FDay;
  end;

  TDescendantFocusabilityAttribute = class(TCustomAttribute)
  private
    FValue: Integer;
  public
    constructor Create(Value: TDescendantFocusability);
    property Value: Integer read FValue;
  end;

  TScaleTypeAttribute = class(TCustomAttribute)
  private
    FValue: TImageScaleType;
  public
    constructor Create(AValue: TImageScaleType);
    property Value: TImageScaleType read FValue;
  end;

  TScreenOrientationAttribute = class(TCustomAttribute)
  private
    FOrientation: TScreenOrientation;
  public
    constructor Create(Orientation: TScreenOrientation);
    property Orientation: TScreenOrientation read FOrientation;
  end;

  {TAutofillIdAttribute = class(TCustomAttribute)
  private
    FId: JAutofillId;
  public
    constructor Create(Id: JAutofillId);
    property Id: JAutofillId read FId;
  end;

  TAccessibilityDelegateAttribute = class(TCustomAttribute)
  private
    FDelegate: JView_AccessibilityDelegate;
  public
    constructor Create(Delegate: JView_AccessibilityDelegate);
    property Delegate: JView_AccessibilityDelegate read FDelegate;
  end;

  TAccessibilityPaneTitleAttribute = class(TCustomAttribute)
  private
    FTitle: JCharSequence;
  public
    constructor Create(Title: JCharSequence);
    property Title: JCharSequence read FTitle;
  end;

  TAnimationAttribute = class(TCustomAttribute)
  private
    FAnimation: JAnimation;
  public
    constructor Create(Animation: JAnimation);
    property Animation: JAnimation read FAnimation;
  end;

  AutofillIdAttribute = class(TCustomAttribute)
  private
    FId: JAutofillId;
  public
    constructor Create(Id: JAutofillId);
    property Id: JAutofillId read FId;
  end;

  BackgroundAttribute = class(TCustomAttribute)
  private
    FBackground: JDrawable;
  public
    constructor Create(Background: JDrawable);
    property Background: JDrawable read FBackground;
  end;

  BackgroundTintBlendModeAttribute = class(TCustomAttribute)
  private
    FBlendMode: JBlendMode;
  public
    constructor Create(BlendMode: JBlendMode);
    property BlendMode: JBlendMode read FBlendMode;
  end;

  BackgroundTintListAttribute = class(TCustomAttribute)
  private
    FTint: JColorStateList;
  public
    constructor Create(Tint: JColorStateList);
    property Tint: JColorStateList read FTint;
  end;

  BackgroundTintModeAttribute = class(TCustomAttribute)
  private
    FTintMode: JPorterDuff_Mode;
  public
    constructor Create(TintMode: JPorterDuff_Mode);
    property TintMode: JPorterDuff_Mode read FTintMode;
  end;

  ClipBoundsAttribute = class(TCustomAttribute)
  private
    FClipBounds: JRect;
  public
    constructor Create(ClipBounds: JRect);
    property ClipBounds: JRect read FClipBounds;
  end;

  ContentCaptureSessionAttribute = class(TCustomAttribute)
  private
    FContentCaptureSession: JContentCaptureSession;
  public
    constructor Create(ContentCaptureSession: JContentCaptureSession);
    property ContentCaptureSession: JContentCaptureSession read FContentCaptureSession;
  end;

  ContentDescriptionAttribute = class(TCustomAttribute)
  private
    FContentDescription: JCharSequence;
  public
    constructor Create(ContentDescription: JCharSequence);
    property ContentDescription: JCharSequence read FContentDescription;
  end;

  ForegroundAttribute = class(TCustomAttribute)
  private
    FForeground: JDrawable;
  public
    constructor Create(Foreground: JDrawable);
    property Foreground: JDrawable read FForeground;
  end;

  ForegroundTintBlendModeAttribute = class(TCustomAttribute)
  private
    FBlendMode: JBlendMode;
  public
    constructor Create(BlendMode: JBlendMode);
    property BlendMode: JBlendMode read FBlendMode;
  end;

  ForegroundTintListAttribute = class(TCustomAttribute)
  private
    FTint: JColorStateList;
  public
    constructor Create(Tint: JColorStateList);
    property Tint: JColorStateList read FTint;
  end;

  ForegroundTintModeAttribute = class(TCustomAttribute)
  private
    FTintMode: JPorterDuff_Mode;
  public
    constructor Create(TintMode: JPorterDuff_Mode);
    property TintMode: JPorterDuff_Mode read FTintMode;
  end;

  LayerPaintAttribute = class(TCustomAttribute)
  private
    FPaint: JPaint;
  public
    constructor Create(Paint: JPaint);
    property Paint: JPaint read FPaint;
  end;

  LayerTypeAttribute = class(TPiscesIntegerAttribute)
  private
    FPaint: JPaint;
  public
    constructor Create(LayerType: Integer; Paint: JPaint);
    property Paint: JPaint read FPaint;
  end;

  OnApplyWindowInsetsListenerAttribute = class(TCustomAttribute)
  private
    FListener: JView_OnApplyWindowInsetsListener;
  public
    constructor Create(Listener: JView_OnApplyWindowInsetsListener);
    property Listener: JView_OnApplyWindowInsetsListener read FListener;
  end;

  OnCapturedPointerListenerAttribute = class(TCustomAttribute)
  private
    FListener: JView_OnCapturedPointerListener;
  public
    constructor Create(Listener: JView_OnCapturedPointerListener);
    property Listener: JView_OnCapturedPointerListener read FListener;
  end;

  ColorFilterAttribute = class(TCustomAttribute)
  private
    FColor: Integer;
    FMode: JPorterDuff_Mode;
    FColorFilter: JColorFilter;
  public
    constructor Create(Color: Integer; Mode: JPorterDuff_Mode); overload;
    constructor Create(Color: Integer); overload;
    constructor Create(ColorFilter: JColorFilter); overload;
    property Color: Integer read FColor;
    property Mode: JPorterDuff_Mode read FMode;
    property ColorFilter: JColorFilter read FColorFilter;
  end;

  ImageBitmapAttribute = class(TCustomAttribute)
  private
    FBitmap: JBitmap;
  public
    constructor Create(Bitmap: JBitmap);
    property Bitmap: JBitmap read FBitmap;
  end;

  }
  //JView
  HeightAttribute = class(THeightAttribute);
  WidthAttribute = class(TWidthAttribute);
  WidthPercentAttribute = class(TWidthPercentAttribute);
  HeightPercentAttribute = class(THeightPercentAttribute);
  IdAttribute = class(TPiscesIntegerAttribute);
  BackgroundColorAttribute = class(TPiscesColorAttribute);
  TextColorAttribute = class(TPiscesColorAttribute);
  StatusBarColorAttribute = class(TPiscesColorAttribute);
  ElevationAttribute = class(TPiscesIntegerAttribute);
  VisibleAttribute = class(TPiscesBooleanAttribute);
  FullScreenAttribute = class(TPiscesBooleanAttribute);
  ScreenOrientationAttribute = class(TScreenOrientationAttribute);
  PositionAttribute = class(TPositionAttribute);
  PaddingAttribute = class(TPaddingAttribute);
  DarkStatusBarIconsAttribute = class(TPiscesBooleanAttribute);
  ClickableAttribute = class(TPiscesBooleanAttribute);
  FocusableAttribute = class(TPiscesBooleanAttribute);
  EnabledAttribute = class(TPiscesBooleanAttribute);
  LayoutDirectionAttribute = class(TLayoutDirection);
  TextSizeAttribute = class(TPiscesSingleAttribute);
  TextHintColorAttribute = class(TPiscesColorAttribute);
  GravityAttribute = class(TGravityAttribute);
  JustifyAttribute = class(TJustifyAttribute);
  AccessibilityTraversalAfterAttribute = class(TPiscesIntegerAttribute);
  AccessibilityTraversalBeforeAttribute = class(TPiscesIntegerAttribute);
  ActivatedAttribute = class(TPiscesBooleanAttribute);
  AllowClickWhenDisabledAttribute = class(TPiscesBooleanAttribute);
  AlphaAttribute = class(TPiscesSingleAttribute);
  AccessibilityHeadingAttribute = class(TPiscesBooleanAttribute);
  AccessibilityLiveRegionAttribute = class(TAccessibilityLiveRegionAttribute);
  BackgroundResourceAttribute = class(TBackgroundResourceAttribute);
  AutoHandwritingEnabledAttribute = class(TPiscesBooleanAttribute);
  BottomAttribute = class(TPiscesIntegerAttribute);
  CameraDistanceAttribute = class(TPiscesSingleAttribute);
  ClipToOutlineAttribute = class(TPiscesBooleanAttribute);
  ContextClickableAttribute = class(TPiscesBooleanAttribute);
  DefaultFocusHighlightEnabledAttribute = class(TPiscesBooleanAttribute);
  DrawingCacheBackgroundColorAttribute = class(TPiscesIntegerAttribute);
  DrawingCacheEnabledAttribute = class(TPiscesBooleanAttribute);
  DrawingCacheQualityAttribute = class(TDrawingCacheQualityAttribute);
  DuplicateParentStateEnabledAttribute = class(TPiscesBooleanAttribute);
  FadingEdgeLengthAttribute = class(TPiscesIntegerAttribute);
  FilterTouchesWhenObscuredAttribute = class(TPiscesBooleanAttribute);
  FitsSystemWindowsAttribute = class(TPiscesBooleanAttribute);
  FocusableInTouchModeAttribute = class(TFocusableInTouchModeAttribute);
  HapticFeedbackEnabledAttribute = class(TPiscesBooleanAttribute);
  HasTransientStateAttribute = class(TPiscesBooleanAttribute);
  FocusedByDefaultAttribute = class(TPiscesBooleanAttribute);
  ForceDarkAllowedAttribute = class(TPiscesBooleanAttribute);
  ForegroundGravityAttribute = class(TGravityAttribute);
  HorizontalFadingEdgeEnabledAttribute = class(TPiscesBooleanAttribute);
  HorizontalScrollBarEnabledAttribute = class(TPiscesBooleanAttribute);
  HoveredAttribute = class(TPiscesBooleanAttribute);
  ImportantForAccessibilityAttribute = class(TPiscesIntegerAttribute);
  ImportantForAutofillAttribute = class(TPiscesIntegerAttribute);
  ImportantForContentCaptureAttribute = class(TPiscesIntegerAttribute);
  KeepScreenOnAttribute = class(TPiscesBooleanAttribute);
  KeyboardNavigationClusterAttribute = class(TPiscesBooleanAttribute);
  LabelForAttribute = class(TPiscesIntegerAttribute);
  LeftAttribute = class(TPiscesIntegerAttribute);
  LongClickableAttribute = class(TPiscesBooleanAttribute);
  MinimumHeightAttribute = class(TPiscesIntegerAttribute);
  LeftTopRightBottomAttribute = class(TLeftTopRightBottomAttribute);
  MinimumWidthAttribute = class(TPiscesIntegerAttribute);
  NestedScrollingEnabledAttribute = class(TPiscesBooleanAttribute);
  NextClusterForwardIdAttribute = class(TPiscesIntegerAttribute);
  NextFocusDownIdAttribute = class(TPiscesIntegerAttribute);
  NextFocusForwardIdAttribute = class(TPiscesIntegerAttribute);
  NextFocusLeftIdAttribute = class(TPiscesIntegerAttribute);
  NextFocusRightIdAttribute = class(TPiscesIntegerAttribute);
  NextFocusUpIdAttribute = class(TPiscesIntegerAttribute);
  OutlineAmbientShadowColorAttribute = class(TPiscesColorAttribute);
  OutlineSpotShadowColorAttribute = class(TPiscesColorAttribute);
  PivotXAttribute = class(TPiscesSingleAttribute);
  PivotYAttribute = class(TPiscesSingleAttribute);
  OverScrollModeAttribute = class(TOverScrollModeAttribute);
  PaddingRelativeAttribute = class(TPaddingAttribute);
  PreferKeepClearAttribute = class(TPiscesBooleanAttribute);
  PressedAttribute = class(TPiscesBooleanAttribute);
  RevealOnFocusHintAttribute = class(TPiscesBooleanAttribute);
  RightAttribute = class(TPiscesIntegerAttribute);
  RotationAttribute = class(TPiscesSingleAttribute);
  RotationXAttribute = class(TPiscesSingleAttribute);
  RotationYAttribute = class(TPiscesSingleAttribute);
  SaveEnabledAttribute = class(TPiscesBooleanAttribute);
  SaveFromParentEnabledAttribute = class(TPiscesBooleanAttribute);
  ScaleXAttribute = class(TPiscesSingleAttribute);
  ScaleYAttribute = class(TPiscesSingleAttribute);
  ScreenReaderFocusableAttribute = class(TPiscesBooleanAttribute);
  ScrollBarDefaultDelayBeforeFadeAttribute = class(TPiscesIntegerAttribute);
  ScrollBarFadeDurationAttribute = class(TPiscesIntegerAttribute);
  ScrollBarSizeAttribute = class(TPiscesIntegerAttribute);
  ScrollBarStyleAttribute = class(TPiscesIntegerAttribute);
  ScrollCaptureHintAttribute = class(TPiscesIntegerAttribute);
  ScrollContainerAttribute = class(TPiscesBooleanAttribute);
  ScrollIndicatorsAttribute = class(TScrollIndicatorsAttribute);
  ScrollXAttribute = class(TPiscesIntegerAttribute);
  ScrollYAttribute = class(TPiscesIntegerAttribute);
  ScrollbarFadingEnabledAttribute = class(TPiscesBooleanAttribute);
  SelectedAttribute = class(TPiscesBooleanAttribute);
  SoundEffectsEnabledAttribute = class(TPiscesBooleanAttribute);
  TextAlignmentAttribute = class(TPiscesIntegerAttribute);
  TextDirectionAttribute = class(TPiscesIntegerAttribute);
  TopAttribute = class(TPiscesIntegerAttribute);
  TransitionAlphaAttribute = class(TPiscesSingleAttribute);
  TransitionVisibilityAttribute = class(TPiscesIntegerAttribute);
  TranslationXAttribute = class(TPiscesSingleAttribute);
  TranslationYAttribute = class(TPiscesSingleAttribute);
  TranslationZAttribute = class(TPiscesSingleAttribute);
  VerticalFadingEdgeEnabledAttribute = class(TPiscesBooleanAttribute);
  VerticalScrollBarEnabledAttribute = class(TPiscesBooleanAttribute);
  VerticalScrollbarPositionAttribute = class(TPiscesIntegerAttribute);
  VisibilityAttribute = class(TPiscesIntegerAttribute);
  WillNotCacheDrawingAttribute = class(TPiscesBooleanAttribute);
  WillNotDrawAttribute = class(TPiscesBooleanAttribute);
  XAttribute = class(TPiscesSingleAttribute);
  YAttribute = class(TPiscesSingleAttribute);
  ZAttribute = class(TPiscesSingleAttribute);
  BackgroundTintListAttribute = class(TPiscesColorAttribute);
  MultiGradientAttribute = class(TMultiGradientAttribute);

  //JText
  AllCapsAttribute = class(TPiscesBooleanAttribute);
  AutoLinkMaskAttribute = class(TPiscesIntegerAttribute);
  CursorVisibleAttribute = class(TPiscesBooleanAttribute);
  ElegantTextHeightAttribute = class(TPiscesBooleanAttribute);
  EmsAttribute = class(TPiscesIntegerAttribute);
  FallbackLineSpacingAttribute = class(TPiscesBooleanAttribute);
  FreezesTextAttribute = class(TPiscesBooleanAttribute);
  HighlightColorAttribute = class(TPiscesColorAttribute);
  HintTextColorAttribute = class(TPiscesColorAttribute);
  HintAttribute  = class(THintAttribute);
  HorizontallyScrollingAttribute = class(TPiscesBooleanAttribute);
  IncludeFontPaddingAttribute = class(TPiscesBooleanAttribute);
  InputExtrasAttribute = class(TPiscesIntegerAttribute);
  InputTypeAttribute = class(TInputTypeAttribute);
  LastBaselineToBottomHeightAttribute = class(TPiscesIntegerAttribute);
  LetterSpacingAttribute = class(TPiscesSingleAttribute);
  LineBreakStyleAttribute = class(TPiscesIntegerAttribute);
  LineBreakWordStyleAttribute = class(TPiscesIntegerAttribute);
  LineHeightAttribute = class(TPiscesIntegerAttribute);
  LinesAttribute = class(TPiscesIntegerAttribute);
  LineSpacingAttribute = class(TLineSpacingAttribute);
  LinkTextColorAttribute = class(TPiscesColorAttribute);
  LinksClickableAttribute = class(TPiscesBooleanAttribute);
  MarqueeRepeatLimitAttribute = class(TPiscesIntegerAttribute);
  MaxEmsAttribute = class(TPiscesIntegerAttribute);
  MaxHeightAttribute = class(TPiscesIntegerAttribute);
  MaxLinesAttribute = class(TPiscesIntegerAttribute);
  MaxWidthAttribute = class(TPiscesIntegerAttribute);
  MinEmsAttribute = class(TPiscesIntegerAttribute);
  MinHeightAttribute = class(TPiscesIntegerAttribute);
  MinLinesAttribute = class(TPiscesIntegerAttribute);
  MinWidthAttribute = class(TPiscesIntegerAttribute);
  PaintFlagsAttribute = class(TPiscesIntegerAttribute);
  SelectAllOnFocusAttribute = class(TPiscesBooleanAttribute);
  ShadowLayerAttribute = class(TShadowLayerAttribute);
  ShowSoftInputOnFocusAttribute = class(TPiscesBooleanAttribute);
  SingleLineAttribute = class(TPiscesBooleanAttribute);
  TextAppearanceAttribute = class(TResourceAttribute);
  TextIsSelectableAttribute = class(TPiscesBooleanAttribute);
  TextScaleXAttribute = class(TPiscesSingleAttribute);

  //JEditText
  TextAttribute = class(TTextAttribute);
  SelectionAttribute = class(TSelectionAttribute);

  //JCompoundButton
  CheckedAttribute = class(TPiscesBooleanAttribute);

  //JSwitch
  ShowTextAttribute = class(TPiscesBooleanAttribute);
  SplitTrackAttribute = class(TPiscesBooleanAttribute);
  SwitchMinWidthAttribute = class(TPiscesIntegerAttribute);
  SwitchPaddingAttribute = class(TPiscesIntegerAttribute);
  TextOffAttribute = class(TPiscesStringAttribute);
  TextOnAttribute = class(TPiscesStringAttribute);
  ThumbTextPaddingAttribute = class(TPiscesIntegerAttribute);

  //JImageView
  AdjustViewBoundsAttribute = class(TPiscesBooleanAttribute);
  BaselineAttribute = class(TPiscesIntegerAttribute);
  BaselineAlignBottomAttribute = class(TPiscesBooleanAttribute);
  CropToPaddingAttribute = class(TPiscesBooleanAttribute);
  ImageAlphaAttribute = class(TPiscesIntegerAttribute);
  ImageLevelAttribute = class(TPiscesIntegerAttribute);
  ImageResourceAttribute = class(TResourceAttribute);
  ScaleTypeAttribute = class(TScaleTypeAttribute);

  //ViewGroup
  AddStatesFromChildrenAttribute = class(TPiscesBooleanAttribute);
  AlwaysDrawnWithCacheEnabledAttribute = class(TPiscesBooleanAttribute);
  AnimationCacheEnabledAttribute = class(TPiscesBooleanAttribute);
  ClipChildrenAttribute = class(TPiscesBooleanAttribute);
  ClipToPaddingAttribute = class(TPiscesBooleanAttribute);
  DescendantFocusabilityAttribute = class(TDescendantFocusabilityAttribute);
  LayoutModeAttribute = class(TPiscesIntegerAttribute);
  MotionEventSplittingEnabledAttribute = class(TPiscesBooleanAttribute);
  TouchscreenBlocksFocusAttribute = class(TPiscesBooleanAttribute);
  TransitionGroupAttribute = class(TPiscesBooleanAttribute);

  //JLinearLayout & JRelativeLayout
  BaselineAlignedAttribute = class(TPiscesBooleanAttribute);
  BaselineAlignedChildIndexAttribute = class(TPiscesIntegerAttribute);
  DividerPaddingAttribute = class(TPiscesIntegerAttribute);
  HorizontalGravityAttribute = class(TGravityAttribute);
  MeasureWithLargestChildEnabledAttribute = class(TPiscesBooleanAttribute);
  OrientationAttribute = class(TOrientationAttribute);
  ShowDividersAttribute = class(TPiscesIntegerAttribute);
  VerticalGravityAttribute = class(TPiscesIntegerAttribute);
  WeightSumAttribute = class(TPiscesSingleAttribute);

  //JToolBar
  CollapseContentDescriptionAttribute = class(TPiscesStringAttribute);
  CollapseIconAttribute = class(TResourceAttribute);
  ContentInsetEndWithActionsAttribute = class(TPiscesIntegerAttribute);
  ContentInsetStartWithNavigationAttribute = class(TPiscesIntegerAttribute);
  ContentInsetsAbsoluteAttribute = class(TLeftTopRightBottomAttribute);
  ContentInsetsRelativeAttribute = class(TLeftTopRightBottomAttribute);
  LogoAttribute = class(TResourceAttribute);
  LogoDescriptionAttribute = class(TPiscesStringAttribute);
  NavigationContentDescriptionAttribute = class(TPiscesStringAttribute);
  NavigationIconAttribute = class(TResourceAttribute);
  SubtitleAttribute = class(TPiscesStringAttribute);
  SubtitleTextAppearanceAttribute = class(TResourceAttribute);
  SubtitleTextColorAttribute = class(TPiscesColorAttribute);
  TitleAttribute = class(TPiscesStringAttribute);
  TitleMarginAttribute = class(TLeftTopRightBottomAttribute);
  TitleTextColorAttribute = class(TPiscesColorAttribute);

  //FrameLayout
  MeasureAllChildrenAttribute  = class(TPiscesBooleanAttribute);

  //ScrollView
  BottomEdgeEffectColorAttribute = class(TPiscesColorAttribute);
  EdgeEffectColorAttribute = class(TPiscesColorAttribute);
  FillViewportAttribute = class(TPiscesBooleanAttribute);
  SmoothScrollingEnabledAttribute = class(TPiscesBooleanAttribute);
  TopEdgeEffectColorAttribute = class(TPiscesColorAttribute);

  //JTimePicker
  CurrentHourAttribute = class(TPiscesIntegerAttribute);
  CurrentMinuteAttribute = class(TPiscesIntegerAttribute);
  HourAttribute =  class(TPiscesIntegerAttribute);
  Is24HourViewAttribute = class(TPiscesBooleanAttribute);
  MinuteAttribute = class(TPiscesIntegerAttribute);

  //JDatePicker
  FirstDayOfWeekAttribute = class(TPiscesIntegerAttribute);
  MaxDateAttribute = class(TPiscesIntegerAttribute);
  MinDateAttribute = class(TPiscesIntegerAttribute);
  SpinnersShownAttribute = class(TPiscesBooleanAttribute);
  CalendarDateAttribute = class(TCalendarDateAttribute);

  //JCalendarView
  DateTextAppearanceAttribute = class(TResourceAttribute);

  //JListView
  ItemsCanFocusAttribute = class(TPiscesBooleanAttribute);

  //Other
  CornerRadiusAttribute = class(TPiscesDoubleAttribute);
  RippleColorAttribute = class(TPiscesColorAttribute);
  EnableKeyboardPadding = class(TPiscesBooleanAttribute);

implementation

uses
  System.Hash, Androidapi.JNI.GraphicsContentViewText;

{ TPiscesViewAttribute }

constructor TPiscesViewAttribute.Create(ComponentName: String);
begin
  FComponentName := ComponentName;
end;

function TPiscesViewAttribute.GetUniqueId: Integer;
begin
  Result := Abs(THashBobJenkins.GetHashValue(FComponentName));
end;

{ TPiscesIntegerAttribute }

constructor TPiscesIntegerAttribute.Create(Value: Integer);
begin
  FValue := Value;
end;

{ TPiscesBooleanAttribute }

constructor TPiscesBooleanAttribute.Create(Value: Boolean);
begin
  FValue := Value;
end;

{ THeightAttribute }

constructor THeightAttribute.Create(AHeight: TLayout);
begin
  case AHeight of
    TLayout.MATCH: FValue := TJViewGroup_LayoutParams.JavaClass.MATCH_PARENT;
    TLayout.FILL: FValue := TJViewGroup_LayoutParams.JavaClass.FILL_PARENT;
    TLayout.WRAP: FValue := TJViewGroup_LayoutParams.JavaClass.WRAP_CONTENT;
  end;
end;

constructor THeightAttribute.Create(AHeight: Integer);
begin
  FValue := AHeight;
end;

{ TWidthAttribute }

constructor TWidthAttribute.Create(AWidth: TLayout);
begin
  case AWidth of
    TLayout.MATCH: FValue := TJViewGroup_LayoutParams.JavaClass.MATCH_PARENT;
    TLayout.FILL: FValue := TJViewGroup_LayoutParams.JavaClass.FILL_PARENT;
    TLayout.WRAP: FValue := TJViewGroup_LayoutParams.JavaClass.WRAP_CONTENT;
  end;
end;

constructor TWidthAttribute.Create(AWidth: Integer);
begin
  FValue := AWidth;
end;

{ TWidthPercentAttribute }

constructor TWidthPercentAttribute.Create(APercent: Single);
begin
  FValue := APercent;
end;

{ THeightPercentAttribute }

constructor THeightPercentAttribute.Create(APercent: Single);
begin
  FValue := APercent;
end;

{ TPositionAttribute }

constructor TPositionAttribute.Create(ValueX, ValueY: Single);
begin
  FX := ValueX;
  FY := ValueY;
end;

{ TPaddingAttribute }

constructor TPaddingAttribute.Create(ARight, ATop, ALeft, ABottom: Integer);
begin
  FRight := ARight;
  FTop := ATop;
  FLeft := ALeft;
  FBottom := ABottom;
end;

{ TPiscesColorAttribute }

constructor TPiscesColorAttribute.Create(const Red, Green, Blue: Integer);
begin
  FColor := TJColor.JavaClass.rgb(Red, Green, Blue);
end;

constructor TPiscesColorAttribute.Create(const Red, Green, Blue: Integer; Alpha: Double);
begin
  if Alpha = 0 then
    FColor := TJColor.JavaClass.TRANSPARENT
  else
    FColor := TJColor.JavaClass.argb(Trunc(Alpha * 255), Red, Green, Blue);
end;

{ TLayoutDirection }

constructor TLayoutDirection.Create(Direction: TLytDirection);
begin
  case Direction of
    TLytDirection.INHERIT: FValue := TJView.JavaClass.LAYOUT_DIRECTION_INHERIT;
    TLytDirection.LOCALE:  FValue := TJView.JavaClass.LAYOUT_DIRECTION_LOCALE;
    TLytDirection.LEFTTORIGHT:  FValue := TJView.JavaClass.LAYOUT_DIRECTION_LTR;
    TLytDirection.RIGHTTOLEFT:  FValue := TJView.JavaClass.LAYOUT_DIRECTION_RTL;
  end;
end;

{ TPiscesSingleAttribute }

constructor TPiscesSingleAttribute.Create(AValue: Single);
begin
  FValue := AValue;
end;

{ TGravityAttribute }

constructor TGravityAttribute.Create(const Modes: TGravitySet);
var
  Mode: TGravity;
begin
  FValue := 0;
  for Mode in Modes do
    case Mode of
      TGravity.AxisClip: FValue := FValue or TJGravity.JavaClass.AXIS_CLIP;
      TGravity.AxisPullAfter: FValue := FValue or TJGravity.JavaClass.AXIS_PULL_AFTER;
      TGravity.AxisPullBefore: FValue := FValue or TJGravity.JavaClass.AXIS_PULL_BEFORE;
      TGravity.AxisSpecified: FValue := FValue or TJGravity.JavaClass.AXIS_SPECIFIED;
      TGravity.AxisXShift: FValue := FValue or TJGravity.JavaClass.AXIS_X_SHIFT;
      TGravity.AxisYShift: FValue := FValue or TJGravity.JavaClass.AXIS_Y_SHIFT;
      TGravity.Bottom: FValue := FValue or TJGravity.JavaClass.BOTTOM;
      TGravity.Center: FValue := FValue or TJGravity.JavaClass.CENTER;
      TGravity.CenterHorizontal: FValue := FValue or TJGravity.JavaClass.CENTER_HORIZONTAL;
      TGravity.CenterVertical: FValue := FValue or TJGravity.JavaClass.CENTER_VERTICAL;
      TGravity.ClipHorizontal: FValue := FValue or TJGravity.JavaClass.CLIP_HORIZONTAL;
      TGravity.ClipVertical: FValue := FValue or TJGravity.JavaClass.CLIP_VERTICAL;
      TGravity.DisplayClipHorizontal: FValue := FValue or TJGravity.JavaClass.DISPLAY_CLIP_HORIZONTAL;
      TGravity.DisplayClipVertical: FValue := FValue or TJGravity.JavaClass.DISPLAY_CLIP_VERTICAL;
      TGravity.Fill: FValue := FValue or TJGravity.JavaClass.FILL;
      TGravity.FillHorizontal: FValue := FValue or TJGravity.JavaClass.FILL_HORIZONTAL;
      TGravity.FillVertical: FValue := FValue or TJGravity.JavaClass.FILL_VERTICAL;
      TGravity.HorizontalGravityMask: FValue := FValue or TJGravity.JavaClass.HORIZONTAL_GRAVITY_MASK;
      TGravity.Left: FValue := FValue or TJGravity.JavaClass.LEFT;
      TGravity.NoGravity: FValue := FValue or TJGravity.JavaClass.NO_GRAVITY;
      TGravity.RelativeHorizontalGravityMask: FValue := FValue or TJGravity.JavaClass.RELATIVE_HORIZONTAL_GRAVITY_MASK;
      TGravity.RelativeLayoutDirection: FValue := FValue or TJGravity.JavaClass.RELATIVE_LAYOUT_DIRECTION;
      TGravity.Right: FValue := FValue or TJGravity.JavaClass.RIGHT;
      TGravity.Start: FValue := FValue or TJGravity.JavaClass.START;
      TGravity.Top: FValue := FValue or TJGravity.JavaClass.TOP;
      TGravity.VerticalGravityMask: FValue := FValue or TJGravity.JavaClass.VERTICAL_GRAVITY_MASK;
      TGravity.EndPos: FValue := FValue or TJGravity.JavaClass.&END;
    end;
end;

{ TJustifyAttribute }

constructor TJustifyAttribute.Create(IsJustify: Boolean);
begin
  FJustify := IsJustify;
end;

constructor TJustifyAttribute.Create(IsJustify: Boolean; AHyphenStrategy: THyphenStrg);
begin
  FJustify := IsJustify;
  FHyphenation := AHyphenStrategy;
end;

constructor TJustifyAttribute.Create(IsJustify: Boolean;
  AHyphenStrategy: THyphenStrg; ATextBreakStrategy: TBreakStrg);
begin
  FJustify := IsJustify;
  FHyphenation := AHyphenStrategy;
  FTextBreak := ATextBreakStrategy;
end;

constructor TJustifyAttribute.Create(IsJustify: Boolean; ATextBreakStrategy: TBreakStrg);
begin
  FJustify := IsJustify;
  FTextBreak := ATextBreakStrategy;
end;

{ TAccessibilityLiveRegionAttribute }

constructor TAccessibilityLiveRegionAttribute.Create(Mode: TAccessibilityLiveRegion);
begin
   case Mode of
    TAccessibilityLiveRegion.None: FMode := TJView.JavaClass.ACCESSIBILITY_LIVE_REGION_NONE;
    TAccessibilityLiveRegion.Polite: FMode := TJView.JavaClass.ACCESSIBILITY_LIVE_REGION_POLITE;
    TAccessibilityLiveRegion.Assertive: FMode := TJView.JavaClass.ACCESSIBILITY_LIVE_REGION_ASSERTIVE;
   end;
end;

{ TResourceAttribute }

constructor TResourceAttribute.Create(AResourceName, ALocation: String);
begin
  FResourceName := AResourceName;
  FLocation := ALocation;
end;

{ TDrawingCacheQualityAttribute }

constructor TDrawingCacheQualityAttribute.Create(Quality: TDrawingCacheQuality);
begin
  case Quality of
    TDrawingCacheQuality.Low: FQuality := TJView.JavaClass.DRAWING_CACHE_QUALITY_LOW;
    TDrawingCacheQuality.High: FQuality := TJView.JavaClass.DRAWING_CACHE_QUALITY_HIGH;
    TDrawingCacheQuality.Auto: FQuality := TJView.JavaClass.DRAWING_CACHE_QUALITY_AUTO;
  end;
end;

{ TFocusableInTouchModeAttribute }

constructor TFocusableInTouchModeAttribute.Create(Mode: TFocusableMode);
begin
  case Mode of
    TFocusableMode.Focusable: FMode := TJView.JavaClass.FOCUSABLE;
    TFocusableMode.FocusablesAll: FMode := TJView.JavaClass.FOCUSABLES_ALL;
    TFocusableMode.FocusablesTouchMode: FMode := TJView.JavaClass.FOCUSABLES_TOUCH_MODE;
    TFocusableMode.FocusableAuto: FMode := TJView.JavaClass.FOCUSABLE_AUTO;
    TFocusableMode.FocusBackward: FMode := TJView.JavaClass.FOCUS_BACKWARD;
    TFocusableMode.FocusDown: FMode := TJView.JavaClass.FOCUS_DOWN;
    TFocusableMode.FocusForward: FMode := TJView.JavaClass.FOCUS_FORWARD;
    TFocusableMode.FocusLeft: FMode := TJView.JavaClass.FOCUS_LEFT;
    TFocusableMode.FocusRight: FMode := TJView.JavaClass.FOCUS_RIGHT;
    TFocusableMode.FocusUp: FMode := TJView.JavaClass.FOCUS_UP;
    TFocusableMode.NotFocusable: FMode := TJView.JavaClass.NOT_FOCUSABLE;
  end;
end;

{ TLeftTopRightBottomAttribute }

constructor TLeftTopRightBottomAttribute.Create(ALeft, ATop, ARight, ABottom: Integer);
begin
  FLeft := ALeft;
  FTop := ATop;
  FRight := ARight;
  FBottom := ABottom;
end;

{ TOverScrollModeAttribute }

constructor TOverScrollModeAttribute.Create(Mode: TOverScrollMode);
begin
  case Mode of
    TOverScrollMode.Always: FMode := TJView.JavaClass.OVER_SCROLL_ALWAYS;
    TOverScrollMode.IfContentScrolls: FMode := TJView.JavaClass.OVER_SCROLL_IF_CONTENT_SCROLLS;
    TOverScrollMode.Never: FMode := TJView.JavaClass.OVER_SCROLL_NEVER;
  end;
end;

{ THintAttribute }

constructor THintAttribute.Create(AResId: Integer);
begin
  FHint := IntToStr(AResId);
end;

constructor THintAttribute.Create(AHint: String);
begin
  FHint := AHint;
end;

{ TScrollIndicatorsAttribute }

constructor TScrollIndicatorsAttribute.Create(Indicators: TScrollIndicatorSet);
var
  Indicator: TScrollIndicator;
begin
  for Indicator in Indicators do
    case Indicator of
      TScrollIndicator.Bottom: FIndicators := FIndicators or TJView.JavaClass.SCROLL_INDICATOR_BOTTOM ;
      TScrollIndicator.Top: FIndicators := FIndicators or TJView.JavaClass.SCROLL_INDICATOR_TOP ;
      TScrollIndicator.Right: FIndicators := FIndicators or TJView.JavaClass.SCROLL_INDICATOR_RIGHT ;
      TScrollIndicator.Left: FIndicators := FIndicators or TJView.JavaClass.SCROLL_INDICATOR_LEFT ;
      TScrollIndicator.Start: FIndicators := FIndicators or TJView.JavaClass.SCROLL_INDICATOR_START ;
      TScrollIndicator.EndPos: FIndicators := FIndicators or TJView.JavaClass.SCROLL_INDICATOR_END;
    end;
end;

{ TLineSpacingAttribute }

constructor TLineSpacingAttribute.Create(Add, Mult: Single);
begin
  FAdd := Add;
  FMult := Mult;
end;

{ TShadowLayerAttribute }

constructor TShadowLayerAttribute.Create(Radius, DX, DY: Single; Color: Integer);
begin
  FRadius := Radius;
  FDX := DX;
  FDY := DY;
  FColor := Color;
end;

{ TPiscesStringAttribute }

constructor TPiscesStringAttribute.Create(Value: String);
begin
  FValue := Value;
end;

{ TSelectionAttribute }

constructor TSelectionAttribute.Create(StartIdx, StopIdx: Integer);
begin
  FStart := StartIdx;
  FStop := StopIdx;
end;

constructor TSelectionAttribute.Create(Idx: Integer);
begin
  FIndex := Idx;
end;

{ TTextAttribute }

constructor TTextAttribute.Create(Value: String; Buffer: TTextBuffer);
begin
  FText := Value;
  FBufferType := Buffer;
end;

constructor TTextAttribute.Create(Value: String);
begin
  FText := Value;
  FBufferType := TTextBuffer.Editable;
end;

{ TOrientationAttribute }

constructor TOrientationAttribute.Create(Orientation: TOrientation);
begin
  case Orientation of
    TOrientation.Horizontal: FValue := TJLayoutMode.JavaClass.HORIZONTAL;
    TOrientation.Vertical: FValue := TJLayoutMode.JavaClass.VERTICAL;
  end;
end;

{ TInputTypeAttribute }

constructor TInputTypeAttribute.Create(InputType: TInputType);
begin
  case InputType of
    TInputType.Text: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT;
    TInputType.Number: FValue := TJInputType.JavaClass.TYPE_CLASS_NUMBER;
    TInputType.Phone: FValue := TJInputType.JavaClass.TYPE_CLASS_PHONE;
    TInputType.DateTime: FValue := TJInputType.JavaClass.TYPE_CLASS_DATETIME;
    TInputType.TextEmailAddress: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_EMAIL_ADDRESS;
    TInputType.TextPassword: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PASSWORD;
    TInputType.TextVisiblePassword: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_VISIBLE_PASSWORD;
    TInputType.TextWebEmailAddress: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_WEB_EMAIL_ADDRESS;
    TInputType.TextWebPassword: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_WEB_PASSWORD;
    TInputType.TextUri: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_URI;
    TInputType.TextPersonName: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_PERSON_NAME;
    TInputType.TextPostalAddress: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_VARIATION_POSTAL_ADDRESS;
    TInputType.TextMultiLine: FValue := TJInputType.JavaClass.TYPE_CLASS_TEXT or TJInputType.JavaClass.TYPE_TEXT_FLAG_MULTI_LINE;
    TInputType.NumberDecimal: FValue := TJInputType.JavaClass.TYPE_CLASS_NUMBER or TJInputType.JavaClass.TYPE_NUMBER_FLAG_DECIMAL;
    TInputType.NumberSigned: FValue := TJInputType.JavaClass.TYPE_CLASS_NUMBER or TJInputType.JavaClass.TYPE_NUMBER_FLAG_SIGNED;
    TInputType.NumberPassword: FValue := TJInputType.JavaClass.TYPE_CLASS_NUMBER or TJInputType.JavaClass.TYPE_NUMBER_VARIATION_PASSWORD;
    TInputType.Date: FValue := TJInputType.JavaClass.TYPE_CLASS_DATETIME or TJInputType.JavaClass.TYPE_DATETIME_VARIATION_DATE;
    TInputType.Time: FValue := TJInputType.JavaClass.TYPE_CLASS_DATETIME or TJInputType.JavaClass.TYPE_DATETIME_VARIATION_TIME;
  end;
end;

{ TPiscesDoubleAttribute }

constructor TPiscesDoubleAttribute.Create(Value: Double);
begin
  FValue := Value;
end;

{ TCalendarDateAttribute }

constructor TCalendarDateAttribute.Create(AYear, AMonth, ADay: Integer);
begin
  FYear := AYear;
  FMonth := AMonth;
  FDay := ADay;
end;

{ TDescendantFocusabilityAttribute }

constructor TDescendantFocusabilityAttribute.Create(Value: TDescendantFocusability);
begin
  case Value of
    TDescendantFocusability.FocusAfterDescendants: FValue := TJViewGroup.JavaClass.FOCUS_AFTER_DESCENDANTS;
    TDescendantFocusability.FocusBeforeDescendants: FValue := TJViewGroup.JavaClass.FOCUS_BEFORE_DESCENDANTS;
    TDescendantFocusability.FocusBlockDescendants: FValue := TJViewGroup.JavaClass.FOCUS_BLOCK_DESCENDANTS;
  end;
end;

{ TScaleTypeAttribute }

constructor TScaleTypeAttribute.Create(AValue: TImageScaleType);
begin
  inherited Create;
  FValue := AValue;
end;

{ TMultiGradientAttribute }

function TMultiGradientAttribute.ColorStopToAndroidColor(const ColorStop: TColorStop): Integer;
begin
  if ColorStop.Alpha = 0 then
    Result := TJColor.JavaClass.TRANSPARENT
  else
    Result := TJColor.JavaClass.argb(Trunc(ColorStop.Alpha * 255), ColorStop.Red, ColorStop.Green, ColorStop.Blue);
end;

procedure TMultiGradientAttribute.AddColorStop(Red, Green, Blue: Integer; Alpha: Double);
var
  Len: Integer;
begin
  Len := Length(FColorStops);
  SetLength(FColorStops, Len + 1);
  FColorStops[Len] := TColorStop.Create(Red, Green, Blue, Alpha);
end;

constructor TMultiGradientAttribute.Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
begin
  inherited Create;
  SetLength(FColorStops, 0);
  AddColorStop(R1, G1, B1, A1);
  AddColorStop(R2, G2, B2, A2);
  FOrientation := Orientation;
  FCornerRadius := CornerRadius;
  FGradientRadius := GradientRadius;
  FShape := Shape;
end;

constructor TMultiGradientAttribute.Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
begin
  inherited Create;
  SetLength(FColorStops, 0);
  AddColorStop(R1, G1, B1, A1);
  AddColorStop(R2, G2, B2, A2);
  AddColorStop(R3, G3, B3, A3);
  FOrientation := Orientation;
  FCornerRadius := CornerRadius;
  FGradientRadius := GradientRadius;
  FShape := Shape;
end;

constructor TMultiGradientAttribute.Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
begin
  inherited Create;
  SetLength(FColorStops, 0);
  AddColorStop(R1, G1, B1, A1);
  AddColorStop(R2, G2, B2, A2);
  AddColorStop(R3, G3, B3, A3);
  AddColorStop(R4, G4, B4, A4);
  FOrientation := Orientation;
  FCornerRadius := CornerRadius;
  FGradientRadius := GradientRadius;
  FShape := Shape;
end;

constructor TMultiGradientAttribute.Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; R5, G5, B5: Integer; A5: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
begin
  inherited Create;
  SetLength(FColorStops, 0);
  AddColorStop(R1, G1, B1, A1);
  AddColorStop(R2, G2, B2, A2);
  AddColorStop(R3, G3, B3, A3);
  AddColorStop(R4, G4, B4, A4);
  AddColorStop(R5, G5, B5, A5);
  FOrientation := Orientation;
  FCornerRadius := CornerRadius;
  FGradientRadius := GradientRadius;
  FShape := Shape;
end;

constructor TMultiGradientAttribute.Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; R5, G5, B5: Integer; A5: Double; R6, G6, B6: Integer; A6: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
begin
  inherited Create;
  SetLength(FColorStops, 0);
  AddColorStop(R1, G1, B1, A1);
  AddColorStop(R2, G2, B2, A2);
  AddColorStop(R3, G3, B3, A3);
  AddColorStop(R4, G4, B4, A4);
  AddColorStop(R5, G5, B5, A5);
  AddColorStop(R6, G6, B6, A6);
  FOrientation := Orientation;
  FCornerRadius := CornerRadius;
  FGradientRadius := GradientRadius;
  FShape := Shape;
end;

constructor TMultiGradientAttribute.Create(R1, G1, B1: Integer; A1: Double; R2, G2, B2: Integer; A2: Double; R3, G3, B3: Integer; A3: Double; R4, G4, B4: Integer; A4: Double; R5, G5, B5: Integer; A5: Double; R6, G6, B6: Integer; A6: Double; R7, G7, B7: Integer; A7: Double; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape);
begin
  inherited Create;
  SetLength(FColorStops, 0);
  AddColorStop(R1, G1, B1, A1);
  AddColorStop(R2, G2, B2, A2);
  AddColorStop(R3, G3, B3, A3);
  AddColorStop(R4, G4, B4, A4);
  AddColorStop(R5, G5, B5, A5);
  AddColorStop(R6, G6, B6, A6);
  AddColorStop(R7, G7, B7, A7);
  FOrientation := Orientation;
  FCornerRadius := CornerRadius;
  FGradientRadius := GradientRadius;
  FShape := Shape;
end;

function TMultiGradientAttribute.GetAndroidColors: TJavaArray<Integer>;
var
  i: Integer;
begin
  Result := TJavaArray<Integer>.Create(Length(FColorStops));
  for i := 0 to High(FColorStops) do
    Result.Items[i] := ColorStopToAndroidColor(FColorStops[i])
end;

function TMultiGradientAttribute.GetPositions: TJavaArray<Single>;
var
  i: Integer;
  HasPositions: Boolean;
begin
  HasPositions := False;
  for i := 0 to High(FColorStops) do begin
    if FColorStops[i].Position > 0 then begin
      HasPositions := True;
    end;
  end;

  if HasPositions then begin
    Result := TJavaArray<Single>.Create(Length(FColorStops));
    for i := 0 to High(FColorStops) do begin
      if FColorStops[i].Position > 0 then
        Result.Items[i] := FColorStops[i].Position
      else
        Result.Items[i] := i / (Length(FColorStops) - 1);
    end;
  end else
    Result := nil;
end;

{ TScreenOrientationAttribute }

constructor TScreenOrientationAttribute.Create(Orientation: TScreenOrientation);
begin
  FOrientation := Orientation;
end;

end.

