unit Pisces.View;

{$M+}

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Widget,
  Pisces.EventListeners,
  Pisces.Types;

type

  IPscViewBase = interface
    ['{0B6848FF-AF4A-4C63-BD7B-2D7E32AF21DE}']
  end;

  IPscView = interface(IPscViewBase)
    ['{08342209-042B-42CC-A6C3-9D6B5DA03D00}']
    function OnClick(Proc: TProc<JView>): IPscView;
    function OnLongClick(Proc: TProc<JView>): IPscView;
    function OnSwipe(Proc: TProc<JView, TSwipeDirection, Single, Single>): IPscView;
    function BuildScreen: IPscView;
    function Show: IPscView;
    function GetView: JView;
  end;

  IPscText = interface(IPscView)
    ['{EB0F674A-A7CC-416B-AB3B-180D884CE5C0}']
    function BuildScreen: IPscText;
    function Show: IPscText;
    function Text(Value: String): IPscText; overload;
  end;

  IPscButton = interface(IPscText)
    ['{B0EB1DF5-BC90-4733-9143-A4989E5D72B8}']
    function BuildScreen: IPscButton;
    function Show: IPscButton;
  end;

  IPscCompoundButton = interface(IPscButton)
    ['{C3BB2FD9-997A-48FB-A326-8B4777A3C9CF}']
  end;

  IPscSwitch = interface(IPscCompoundButton)
    ['{B8CA456D-0B76-4FD3-ACD9-18C3D4DD77B1}']
    function BuildScreen: IPscSwitch;
    function Show: IPscSwitch;
  end;

  IPscEdit = interface(IPscText)
    ['{1AB1895B-9AA8-43DC-8994-0B30BADBC6C6}']
    function BuildScreen: IPscEdit;
    function Show: IPscEdit;
  end;

  IPscImage = interface(IPscView)
    ['{B4D0A110-29F4-4F7E-969C-1A9585384FCE}']
    function BuildScreen: IPscImage;
    function Show: IPscImage;
  end;

  IPscPopupWindow = interface(IPscViewBase)
    ['{7F6BEBF1-0EAA-4996-92CC-F847C8972569}']
    function Content(AView: JView): IPscPopupWindow;
    function Width(AValue: Integer): IPscPopupWindow;
    function Height(AValue: Integer): IPscPopupWindow;
    function Focusable(AValue: Boolean): IPscPopupWindow;
    function OutsideTouchable(AValue: Boolean): IPscPopupWindow;
    function ClippingEnabled(AValue: Boolean): IPscPopupWindow;
    function Elevation(AValue: Single): IPscPopupWindow;
    function BackgroundColor(AColor: Integer): IPscPopupWindow;
    function AnimationStyle(AStyle: Integer): IPscPopupWindow;
    function Offset(AX, AY: Integer): IPscPopupWindow;
    function OnDismiss(AProc: TProc): IPscPopupWindow;
    function ShowAsDropDown(AAnchor: JView): IPscPopupWindow; overload;
    function ShowAsDropDown(AAnchor: JView; AXOff, AYOff, AGravity: Integer): IPscPopupWindow; overload;
    function ShowAtLocation(AParent: JView; AGravity, AX, AY: Integer): IPscPopupWindow;
    function Update(AWidth, AHeight: Integer): IPscPopupWindow; overload;
    function Update(AX, AY, AWidth, AHeight: Integer): IPscPopupWindow; overload;
    function Dismiss: IPscPopupWindow;
    function IsShowing: Boolean;
    function GetPopupWindow: JPopupWindow;
  end;

  TPscViewBase = class(TInterfacedObject, IPscViewBase)
  private
    FAttributes: TDictionary<String, TCustomAttribute>;
    FContext: JContext;
    FView: JView;
    FLayoutParams: JViewGroup_LayoutParams;
  published
    property Context: JContext read FContext;
    property LayoutParams: JViewGroup_LayoutParams read FLayoutParams;
    property View: JView read FView write FView;
    property Attributes: TDictionary<String, TCustomAttribute> read FAttributes;
    procedure ApplyAttributes; virtual;
  public
    constructor Create(Attributes: TArray<TCustomAttribute>);
    destructor Destroy; override;
    function Layout(AWidth, AHeight: Integer): IPscViewBase; overload;
    function Layout: IPscViewBase; overload;
    function BackgroundColor(AColor: Integer): IPscViewBase; overload;
    function BackgroundColor: IPscViewBase; overload;
    function Position(X, Y: Single): IPscViewBase; overload;
    function Position: IPscViewBase; overload;
    function Visible(Visible: Boolean): IPscViewBase; overload;
    function Visible: IPscViewBase; overload;
    function Elevation(Value: Single): IPscViewBase; overload;
    function Elevation: IPscViewBase; overload;
    function Id(AId: Integer): IPscViewBase; overload;
    function Id: IPscViewBase; overload;
    function Padding(Left, Top, Right, Bottom: Integer): IPscViewBase; overload;
    function Padding: IPscViewBase; overload;
    function GetView: JView;
    function FullScreen: IPscViewBase;
    function ScreenOrientation: IPscViewBase; overload;
    function ScreenOrientation(Orientation: TScreenOrientation): IPscViewBase; overload;
    function StatusbarColor(Color: Integer): IPscViewBase; overload;
    function StatusbarColor: IPscViewBase; overload;
    function DarkStatusBar: IPscViewBase;
    function Clickable(IsClickable: Boolean): IPscViewBase; overload;
    function Clickable: IPscViewBase; overload;
    function Focusable(IsFocusable: Boolean): IPscViewBase; overload;
    function Focusable: IPscViewBase; overload;
    function Enabled(IsEnabled: Boolean): IPscViewBase; overload;
    function Enabled: IPscViewBase; overload;
    function LayoutDirection(Direction: Integer): IPscViewBase; overload;
    function LayoutDirection: IPscViewBase; overload;
    function AccessibilityHeading(IsHeading: Boolean): IPscViewBase; overload;
    function AccessibilityHeading: IPscViewBase; overload;
    function AccessibilityLiveRegion(Mode: Integer): IPscViewBase; overload;
    function AccessibilityLiveRegion: IPscViewBase; overload;
    function AccessibilityTraversalAfter(AfterId: Integer): IPscViewBase; overload;
    function AccessibilityTraversalAfter: IPscViewBase; overload;
    function AccessibilityTraversalBefore(BeforeId: Integer): IPscViewBase; overload;
    function AccessibilityTraversalBefore: IPscViewBase; overload;
    function Activated(Activated: Boolean): IPscViewBase; overload;
    function Activated: IPscViewBase; overload;
    function AllowClickWhenDisabled(ClickableWhenDisabled: Boolean): IPscViewBase; overload;
    function AllowClickWhenDisabled: IPscViewBase; overload;
    function Alpha(Alpha: Single): IPscViewBase; overload;
    function Alpha: IPscViewBase; overload;
    function AutoHandwritingEnabled(Enabled: Boolean): IPscViewBase; overload;
    function AutoHandwritingEnabled: IPscViewBase; overload;
    function BackgroundResource(ResName, Location: String): IPscViewBase; overload;
    function BackgroundResource: IPscViewBase; overload;
    function Bottom(Bottom: Integer): IPscViewBase; overload;
    function Bottom: IPscViewBase; overload;
    function CameraDistance(Distance: Single): IPscViewBase; overload;
    function CameraDistance: IPscViewBase; overload;
    function ClipToOutline(ClipToOutline: Boolean): IPscViewBase; overload;
    function ClipToOutline: IPscViewBase; overload;
    function ContextClickable(ContextClickable: Boolean): IPscViewBase; overload;
    function ContextClickable: IPscViewBase; overload;
    function DefaultFocusHighlightEnabled(DefaultFocusHighlightEnabled: Boolean): IPscViewBase; overload;
    function DefaultFocusHighlightEnabled: IPscViewBase; overload;
    function DrawingCacheBackgroundColor(Color: Integer): IPscViewBase; overload;
    function DrawingCacheBackgroundColor: IPscViewBase; overload;
    function DrawingCacheEnabled(Enabled: Boolean): IPscViewBase; overload;
    function DrawingCacheEnabled: IPscViewBase; overload;
    function DrawingCacheQuality(Quality: Integer): IPscViewBase; overload;
    function DrawingCacheQuality: IPscViewBase; overload;
    function DuplicateParentStateEnabled(Enabled: Boolean): IPscViewBase; overload;
    function DuplicateParentStateEnabled: IPscViewBase; overload;
    function FadingEdgeLength(Length: Integer): IPscViewBase; overload;
    function FadingEdgeLength: IPscViewBase; overload;
    function FilterTouchesWhenObscured(Enabled: Boolean): IPscViewBase; overload;
    function FilterTouchesWhenObscured: IPscViewBase; overload;
    function FitsSystemWindows(FitSystemWindows: Boolean): IPscViewBase; overload;
    function FitsSystemWindows: IPscViewBase; overload;
    function FocusableInTouchMode(Focusable: Integer): IPscViewBase; overload;
    function FocusableInTouchMode: IPscViewBase; overload;
    function ForegroundGravity(Gravity: Integer): IPscViewBase; overload;
    function ForegroundGravity: IPscViewBase; overload;
    function ForceDarkAllowed(Allow: Boolean): IPscViewBase; overload;
    function ForceDarkAllowed: IPscViewBase; overload;
    function FocusedByDefault(IsFocusedByDefault: Boolean): IPscViewBase; overload;
    function FocusedByDefault: IPscViewBase; overload;
    function HapticFeedbackEnabled(HapticFeedbackEnabled: Boolean): IPscViewBase; overload;
    function HapticFeedbackEnabled: IPscViewBase; overload;
    function HasTransientState(HasTransientState: Boolean): IPscViewBase; overload;
    function HasTransientState: IPscViewBase; overload;
    function HorizontalFadingEdgeEnabled(Enabled: Boolean): IPscViewBase; overload;
    function HorizontalFadingEdgeEnabled: IPscViewBase; overload;
    function HorizontalScrollBarEnabled(Enabled: Boolean): IPscViewBase; overload;
    function HorizontalScrollBarEnabled: IPscViewBase; overload;
    function Hovered(Hovered: Boolean): IPscViewBase; overload;
    function Hovered: IPscViewBase; overload;
    function ImportantForAccessibility(Mode: Integer): IPscViewBase; overload;
    function ImportantForAccessibility: IPscViewBase; overload;
    function ImportantForAutofill(Mode: Integer): IPscViewBase; overload;
    function ImportantForAutofill: IPscViewBase; overload;
    function ImportantForContentCapture(Mode: Integer): IPscViewBase; overload;
    function ImportantForContentCapture: IPscViewBase; overload;
    function KeepScreenOn(KeepOn: Boolean): IPscViewBase; overload;
    function KeepScreenOn: IPscViewBase; overload;
    function KeyboardNavigationCluster(IsCluster: Boolean): IPscViewBase; overload;
    function KeyboardNavigationCluster: IPscViewBase; overload;
    function LabelFor(Id: Integer): IPscViewBase; overload;
    function LabelFor: IPscViewBase; overload;
    function Left(Left: Integer): IPscViewBase; overload;
    function Left: IPscViewBase; overload;
    function LeftTopRightBottom(ALeft, ATop, ARight, ABottom: Integer): IPscViewBase; overload;
    function LeftTopRightBottom: IPscViewBase; overload;
    function LongClickable(LongClickable: Boolean): IPscViewBase; overload;
    function LongClickable: IPscViewBase; overload;
    function MinimumHeight(MinHeight: Integer): IPscViewBase; overload;
    function MinimumHeight: IPscViewBase; overload;
    function MinimumWidth(MinWidth: Integer): IPscViewBase; overload;
    function MinimumWidth: IPscViewBase; overload;
    function NestedScrollingEnabled(Enabled: Boolean): IPscViewBase; overload;
    function NestedScrollingEnabled: IPscViewBase; overload;
    function NextClusterForwardId(Id: Integer): IPscViewBase; overload;
    function NextClusterForwardId: IPscViewBase; overload;
    function NextFocusDownId(Id: Integer): IPscViewBase; overload;
    function NextFocusDownId: IPscViewBase; overload;
    function NextFocusForwardId(Id: Integer): IPscViewBase; overload;
    function NextFocusForwardId: IPscViewBase; overload;
    function NextFocusLeftId(Id: Integer): IPscViewBase; overload;
    function NextFocusLeftId: IPscViewBase; overload;
    function NextFocusRightId(Id: Integer): IPscViewBase; overload;
    function NextFocusRightId: IPscViewBase; overload;
    function NextFocusUpId(Id: Integer): IPscViewBase; overload;
    function NextFocusUpId: IPscViewBase; overload;
    function OutlineAmbientShadowColor(Color: Integer): IPscViewBase; overload;
    function OutlineAmbientShadowColor: IPscViewBase; overload;
    function OutlineSpotShadowColor(Color: Integer): IPscViewBase; overload;
    function OutlineSpotShadowColor: IPscViewBase; overload;
    function OverScrollMode(Mode: Integer): IPscViewBase; overload;
    function OverScrollMode: IPscViewBase; overload;
    function PaddingRelative(Start, Top, End_, Bottom: Integer): IPscViewBase; overload;
    function PaddingRelative: IPscViewBase; overload;
    function PivotX(Value: Single): IPscViewBase; overload;
    function PivotX: IPscViewBase; overload;
    function PivotY(Value: Single): IPscViewBase; overload;
    function PivotY: IPscViewBase; overload;
    function PreferKeepClear(Prefer: Boolean): IPscViewBase; overload;
    function PreferKeepClear: IPscViewBase; overload;
    function Pressed(Pressed: Boolean): IPscViewBase; overload;
    function Pressed: IPscViewBase; overload;
    function RevealOnFocusHint(Reveal: Boolean): IPscViewBase; overload;
    function RevealOnFocusHint: IPscViewBase; overload;
    function Right(Right: Integer): IPscViewBase; overload;
    function Right: IPscViewBase; overload;
    function Rotation(Value: Single): IPscViewBase; overload;
    function Rotation: IPscViewBase; overload;
    function RotationX(Value: Single): IPscViewBase; overload;
    function RotationX: IPscViewBase; overload;
    function RotationY(Value: Single): IPscViewBase; overload;
    function RotationY: IPscViewBase; overload;
    function SaveEnabled(Enabled: Boolean): IPscViewBase; overload;
    function SaveEnabled: IPscViewBase; overload;
    function SaveFromParentEnabled(Enabled: Boolean): IPscViewBase; overload;
    function SaveFromParentEnabled: IPscViewBase; overload;
    function ScaleX(Value: Single): IPscViewBase; overload;
    function ScaleX: IPscViewBase; overload;
    function ScaleY(Value: Single): IPscViewBase; overload;
    function ScaleY: IPscViewBase; overload;
    function ScreenReaderFocusable(Focusable: Boolean): IPscViewBase; overload;
    function ScreenReaderFocusable: IPscViewBase; overload;
    function ScrollBarDefaultDelayBeforeFade(Delay: Integer): IPscViewBase; overload;
    function ScrollBarDefaultDelayBeforeFade: IPscViewBase; overload;
    function ScrollBarFadeDuration(Duration: Integer): IPscViewBase; overload;
    function ScrollBarFadeDuration: IPscViewBase; overload;
    function ScrollBarSize(Size: Integer): IPscViewBase; overload;
    function ScrollBarSize: IPscViewBase; overload;
    function ScrollBarStyle(Style: Integer): IPscViewBase; overload;
    function ScrollBarStyle: IPscViewBase; overload;
    function ScrollCaptureHint(Hint: Integer): IPscViewBase; overload;
    function ScrollCaptureHint: IPscViewBase; overload;
    function ScrollContainer(IsContainer: Boolean): IPscViewBase; overload;
    function ScrollContainer: IPscViewBase; overload;
    function ScrollIndicators(Indicators: Integer): IPscViewBase; overload;
    function ScrollIndicators(Indicators, Mask: Integer): IPscViewBase; overload;
    function ScrollIndicators: IPscViewBase; overload;
    function ScrollX(Value: Integer): IPscViewBase; overload;
    function ScrollX: IPscViewBase; overload;
    function ScrollY(Value: Integer): IPscViewBase; overload;
    function ScrollY: IPscViewBase; overload;
    function ScrollbarFadingEnabled(Enabled: Boolean): IPscViewBase; overload;
    function ScrollbarFadingEnabled: IPscViewBase; overload;
    function Selected(Selected: Boolean): IPscViewBase; overload;
    function Selected: IPscViewBase; overload;
    function SoundEffectsEnabled(Enabled: Boolean): IPscViewBase; overload;
    function SoundEffectsEnabled: IPscViewBase; overload;
    function TextAlignment(Alignment: Integer): IPscViewBase; overload;
    function TextAlignment: IPscViewBase; overload;
    function TextDirection(Direction: Integer): IPscViewBase; overload;
    function TextDirection: IPscViewBase; overload;
    function Top(Top: Integer): IPscViewBase; overload;
    function Top: IPscViewBase; overload;
    function TransitionAlpha(Alpha: Single): IPscViewBase; overload;
    function TransitionAlpha: IPscViewBase; overload;
    function TransitionVisibility(Visibility: Integer): IPscViewBase; overload;
    function TransitionVisibility: IPscViewBase; overload;
    function TranslationX(Value: Single): IPscViewBase; overload;
    function TranslationX: IPscViewBase; overload;
    function TranslationY(Value: Single): IPscViewBase; overload;
    function TranslationY: IPscViewBase; overload;
    function TranslationZ(Value: Single): IPscViewBase; overload;
    function TranslationZ: IPscViewBase; overload;
    function VerticalFadingEdgeEnabled(Enabled: Boolean): IPscViewBase; overload;
    function VerticalFadingEdgeEnabled: IPscViewBase; overload;
    function VerticalScrollBarEnabled(Enabled: Boolean): IPscViewBase; overload;
    function VerticalScrollBarEnabled: IPscViewBase; overload;
    function VerticalScrollbarPosition(Position: Integer): IPscViewBase; overload;
    function VerticalScrollbarPosition: IPscViewBase; overload;
    function Visibility(Visibility: Integer): IPscViewBase; overload;
    function Visibility: IPscViewBase; overload;
    function WillNotCacheDrawing(Value: Boolean): IPscViewBase; overload;
    function WillNotCacheDrawing: IPscViewBase; overload;
    function WillNotDraw(Value: Boolean): IPscViewBase; overload;
    function WillNotDraw: IPscViewBase; overload;
    function X(Value: Single): IPscViewBase; overload;
    function X: IPscViewBase; overload;
    function Y(Value: Single): IPscViewBase; overload;
    function Y: IPscViewBase; overload;
    function Z(Value: Single): IPscViewBase; overload;
    function Z: IPscViewBase; overload;
    function CornerRadius: IPscViewBase; overload;
    function CornerRadius(Value: Double): IPscViewbase; overload;
    function BackgroundTintList: IPscViewBase; overload;
    function BackgroundTintList(AColor: Integer): IPscViewBase; overload;
    function RippleColor: IPscViewBase; overload;
    function RippleColor(Color: Integer): IPscViewBase; overload;
    function Orientation: IPscViewBase; overload;
    function Orientation(Value: Integer): IPscViewBase; overload;

    function MultiGradient: IPscViewBase; overload;
    function MultiGradient(const ColorStops: TColorStopArray; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape): IPscViewBase; overload;
  end;

  TPscView = class(TPscViewBase, IPscView)
  public
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscView;
    function BuildScreen: IPscView;
    function Show: IPscView;
    function OnClick(Proc: TProc<JView>): IPscView;
    function OnLongClick(Proc: TProc<JView>): IPscView;
    function OnSwipe(Proc: TProc<JView, TSwipeDirection, Single, Single>): IPscView;
    function OnTimeChange(Proc: TProc<JTimePicker, Integer, Integer>): IPscView; virtual; abstract;
  end;

  TPscText = class(TPscView, IPscText)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscText;
    function BuildScreen: IPscText;
    function Show: IPscText;
    function Text(Value: String): IPscText; overload;
    function Text: IPscText; overload;
    function TextColor(Value: Integer): IPscText; overload;
    function TextColor: IPscText; overload;
    function TextSize(TxtSize: Single): IPscText; overload;
    function TextSize: IPscText; overload;
    function TextHintColor(HintColor: Integer): IPscText; overload;
    function TextHintColor: IPscText; overload;
    function Gravity(Value: Integer): IPscText; overload;
    function Gravity: IPscText; overload;
    function Justify(Value: Integer): IPscText; overload;
    function Justify: IPscText; overload;
    function Hyphenation(Value: Integer): IPscText;
    function TextBreak(Value: Integer): IPscText;
    function AllCaps(Value: Boolean): IPscText; overload;
    function AllCaps: IPscText; overload;
    function AutoLinkMask(Mask: Integer): IPscText; overload;
    function AutoLinkMask: IPscText; overload;
    function CursorVisible(Visible: Boolean): IPscText; overload;
    function CursorVisible: IPscText; overload;
    function ElegantTextHeight(Elegant: Boolean): IPscText; overload;
    function ElegantTextHeight: IPscText; overload;
    function Ems(Value: Integer): IPscText; overload;
    function Ems: IPscText; overload;
    function FallbackLineSpacing(Enabled: Boolean): IPscText; overload;
    function FallbackLineSpacing: IPscText; overload;
    function FreezesText(Freezes: Boolean): IPscText; overload;
    function FreezesText: IPscText; overload;
    function Height(Pixels: Integer): IPscText; overload;
    function Height: IPscText; overload;
    function HighlightColor(Color: Integer): IPscText; overload;
    function HighlightColor: IPscText; overload;
    function Hint(Hint: String): IPscText; overload;
    function Hint(ResId: Integer): IPscText; overload;
    function Hint: IPscText; overload;
    function HintTextColor(Color: Integer): IPscText; overload;
    function HintTextColor: IPscText; overload;
    function HorizontallyScrolling(Whether: Boolean): IPscText; overload;
    function HorizontallyScrolling: IPscText; overload;
    function IncludeFontPadding(IncludePad: Boolean): IPscText; overload;
    function IncludeFontPadding: IPscText; overload;
    function InputExtras(XmlResId: Integer): IPscText; overload;
    function InputExtras: IPscText; overload;
    function InputType(Type_: Integer): IPscText; overload;
    function InputType: IPscText; overload;
    function LastBaselineToBottomHeight(Height: Integer): IPscText; overload;
    function LastBaselineToBottomHeight: IPscText; overload;
    function LetterSpacing(Spacing: Single): IPscText; overload;
    function LetterSpacing: IPscText; overload;
    function LineBreakStyle(Style: Integer): IPscText; overload;
    function LineBreakStyle: IPscText; overload;
    function LineBreakWordStyle(WordStyle: Integer): IPscText; overload;
    function LineBreakWordStyle: IPscText; overload;
    function LineHeight(Height: Integer): IPscText; overload;
    function LineHeight: IPscText; overload;
    function LineSpacing(Add: Single; Mult: Single): IPscText; overload;
    function LineSpacing: IPscText; overload;
    function Lines(Lines: Integer): IPscText; overload;
    function Lines: IPscText; overload;
    function LinkTextColor(Color: Integer): IPscText; overload;
    function LinkTextColor: IPscText; overload;
    function LinksClickable(Whether: Boolean): IPscText; overload;
    function LinksClickable: IPscText; overload;
    function MarqueeRepeatLimit(MarqueeLimit: Integer): IPscText; overload;
    function MarqueeRepeatLimit: IPscText; overload;
    function MaxEms(MaxEms: Integer): IPscText; overload;
    function MaxEms: IPscText; overload;
    function MaxHeight(MaxPixels: Integer): IPscText; overload;
    function MaxHeight: IPscText; overload;
    function MaxLines(MaxLines: Integer): IPscText; overload;
    function MaxLines: IPscText; overload;
    function MaxWidth(MaxPixels: Integer): IPscText; overload;
    function MaxWidth: IPscText; overload;
    function MinEms(MinEms: Integer): IPscText; overload;
    function MinEms: IPscText; overload;
    function MinHeight(MinPixels: Integer): IPscText; overload;
    function MinHeight: IPscText; overload;
    function MinLines(MinLines: Integer): IPscText; overload;
    function MinLines: IPscText; overload;
    function MinWidth(MinPixels: Integer): IPscText; overload;
    function MinWidth: IPscText; overload;
    function PaintFlags(Flags: Integer): IPscText; overload;
    function PaintFlags: IPscText; overload;
    function SelectAllOnFocus(SelectAll: Boolean): IPscText; overload;
    function SelectAllOnFocus: IPscText; overload;
    function Selected(Selected: Boolean): IPscText; overload;
    function Selected: IPscText; overload;
    function ShadowLayer(Radius, DX, DY: Single; Color: Integer): IPscText; overload;
    function ShadowLayer: IPscText; overload;
    function ShowSoftInputOnFocus(Show: Boolean): IPscText; overload;
    function ShowSoftInputOnFocus: IPscText; overload;
    function SingleLine(Single: Boolean): IPscText; overload;
    function SingleLine: IPscText; overload;
    function Text(ResId: Integer): IPscText; overload;
    function TextAppearance(ResName, Location: String): IPscText; overload;
    function TextAppearance: IPscText; overload;
    function TextIsSelectable(Selectable: Boolean): IPscText; overload;
    function TextIsSelectable: IPscText; overload;
    function TextScaleX(Size: Single): IPscText; overload;
    function TextScaleX: IPscText; overload;
    function Width(Pixels: Integer): IPscText; overload;
    function Width: IPscText; overload;
  end;

  TPscButton = class(TPscText, IPscButton)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscButton;
    function BuildScreen: IPscButton;
    function Show: IPscButton;
  end;

  TPscCompoundButton = class(TPscButton, IPscCompoundButton)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscCompoundButton;
    function BuildScreen: IPscCompoundButton;
    function Show: IPscCompoundButton;
    function Checked(Value: Boolean): IPscCompoundButton; overload;
    function Checked: IPscCompoundButton; overload;
  end;

  TPscSwitch = class(TPscCompoundButton, IPscSwitch)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscSwitch;
    function BuildScreen: IPscSwitch;
    function Show: IPscSwitch;
    function ShowText(Value: Boolean): IPscSwitch; overload;
    function ShowText: IPscSwitch; overload;
    function SplitTrack(Value: Boolean): IPscSwitch; overload;
    function SplitTrack: IPscSwitch; overload;
    function SwitchMinWidth(Pixels: Integer): IPscSwitch; overload;
    function SwitchMinWidth: IPscSwitch; overload;
    function SwitchPadding(Pixels: Integer): IPscSwitch; overload;
    function SwitchPadding: IPscSwitch; overload;
    function TextOff(Value: String): IPscSwitch; overload;
    function TextOff: IPscSwitch; overload;
    function TextOn(Value: String): IPscSwitch; overload;
    function TextOn: IPscSwitch; overload;
    function ThumbTextPadding(Pixels: Integer): IPscSwitch; overload;
    function ThumbTextPadding: IPscSwitch; overload;
  end;

  TPscEdit = class(TPscText, IPscEdit)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscEdit;
    function BuildScreen: IPscEdit;
    function Show: IPscEdit;
    function Selection(StartIdx: Integer; StopIdx: Integer): IPscEdit; overload;
    function Selection: IPscEdit; overload;
    function Text(Value: String; TxtBufferType: TTextBuffer): IPscEdit; overload;
    function Text: IPscEdit; overload;
  end;

  TPscImage = class(TPscView, IPscImage)
  private
    procedure ApplyLayoutChangeListener;
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscImage;
    function BuildScreen: IPscImage;
    function Show: IPscImage;
    function AdjustViewBounds(Value: Boolean): IPscImage; overload;
    function AdjustViewBounds: IPscImage; overload;
    function Baseline(Value: Integer): IPscImage; overload;
    function Baseline: IPscImage; overload;
    function BaselineAlignBottom(Value: Boolean): IPscImage; overload;
    function BaselineAlignBottom: IPscImage; overload;
    function CropToPadding(Value: Boolean): IPscImage; overload;
    function CropToPadding: IPscImage; overload;
    function ImageAlpha(Value: Integer): IPscImage; overload;
    function ImageAlpha: IPscImage; overload;
    function ImageResource(ResName: String; Location: String): IPscImage; overload;
    function ImageResource: IPscImage; overload;
    function ScaleType: IPscImage; overload;
    function ScaleType(Value: TImageScaleType): IPscImage; overload;
  end;

  TPscPopupWindow = class(TInterfacedObject, IPscPopupWindow)
  private
    FPopupWindow: JPopupWindow;
    FContentView: JView;
    FWidth: Integer;
    FHeight: Integer;
    FOffsetX: Integer;
    FOffsetY: Integer;
    FOnDismiss: TProc;
    FDismissListener: JPopupWindow_OnDismissListener;
    procedure EnsurePopupWindow;
  public
    constructor Create;
    destructor Destroy; override;
    class function New: IPscPopupWindow;
    function Content(AView: JView): IPscPopupWindow;
    function Width(AValue: Integer): IPscPopupWindow;
    function Height(AValue: Integer): IPscPopupWindow;
    function Focusable(AValue: Boolean): IPscPopupWindow;
    function OutsideTouchable(AValue: Boolean): IPscPopupWindow;
    function ClippingEnabled(AValue: Boolean): IPscPopupWindow;
    function Elevation(AValue: Single): IPscPopupWindow;
    function BackgroundColor(AColor: Integer): IPscPopupWindow;
    function AnimationStyle(AStyle: Integer): IPscPopupWindow;
    function Offset(AX, AY: Integer): IPscPopupWindow;
    function OnDismiss(AProc: TProc): IPscPopupWindow;
    function ShowAsDropDown(AAnchor: JView): IPscPopupWindow; overload;
    function ShowAsDropDown(AAnchor: JView; AXOff, AYOff, AGravity: Integer): IPscPopupWindow; overload;
    function ShowAtLocation(AParent: JView; AGravity, AX, AY: Integer): IPscPopupWindow;
    function Update(AWidth, AHeight: Integer): IPscPopupWindow; overload;
    function Update(AX, AY, AWidth, AHeight: Integer): IPscPopupWindow; overload;
    function Dismiss: IPscPopupWindow;
    function IsShowing: Boolean;
    function GetPopupWindow: JPopupWindow;
  end;

implementation

uses
  Androidapi.JNI.JavaTypes,
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Androidapi.JNI.Util,
  Pisces.Utils,
  Pisces.Attributes;

{ TPscViewBase }

procedure TPscViewBase.ApplyAttributes;
begin
  TPscUtils.Log('for TPscViewBase', 'ApplyAttributes', TLogger.Info, Self);
  try
    Layout;
    Position;
    BackgroundColor;
    Visible;
    Elevation;
    Id;
    Padding;
    StatusbarColor;
    FullScreen;
    ScreenOrientation;
    DarkStatusBar;
    Clickable;
    Focusable;
    Enabled;
    LayoutDirection;
    AccessibilityHeading;
    AccessibilityLiveRegion;
    AccessibilityTraversalAfter;
    AccessibilityTraversalBefore;
    Activated;
    AllowClickWhenDisabled;
    Alpha;
    AutoHandwritingEnabled;
    BackgroundResource;
    Bottom;
    CameraDistance;
    ClipToOutline;
    ContextClickable;
    DefaultFocusHighlightEnabled;
    DrawingCacheBackgroundColor;
    DrawingCacheEnabled;
    DrawingCacheQuality;
    DuplicateParentStateEnabled;
    FadingEdgeLength;
    FilterTouchesWhenObscured;
    FitsSystemWindows;
    FocusableInTouchMode;
    FocusedByDefault;
    ForegroundGravity;
    HapticFeedbackEnabled;
    HasTransientState;
    HorizontalFadingEdgeEnabled;
    HorizontalScrollBarEnabled;
    Hovered;
    ImportantForAccessibility;
    ImportantForAutofill;
    ImportantForContentCapture;
    KeepScreenOn;
    KeyboardNavigationCluster;
    LabelFor;
    Left;
    LeftTopRightBottom;
    LongClickable;
    MinimumHeight;
    MinimumWidth;
    NestedScrollingEnabled;
    NextClusterForwardId;
    NextFocusDownId;
    NextFocusForwardId;
    NextFocusLeftId;
    NextFocusRightId;
    NextFocusUpId;
    OutlineAmbientShadowColor;
    OutlineSpotShadowColor;
    OverScrollMode;
    PaddingRelative;
    PivotX;
    PivotY;
    PreferKeepClear;
    Pressed;
    RevealOnFocusHint;
    Right;
    Rotation;
    RotationX;
    RotationY;
    SaveEnabled;
    SaveFromParentEnabled;
    ScaleX;
    ScaleY;
    ScreenReaderFocusable;
    ScrollBarDefaultDelayBeforeFade;
    ScrollBarFadeDuration;
    ScrollBarSize;
    ScrollBarStyle;
    ScrollCaptureHint;
    ScrollContainer;
    ScrollIndicators;
    ScrollX;
    ScrollY;
    ScrollbarFadingEnabled;
    Selected;
    SoundEffectsEnabled;
    TextAlignment;
    TextDirection;
    Top;
    TransitionAlpha;
    TransitionVisibility;
    TranslationX;
    TranslationY;
    TranslationZ;
    VerticalFadingEdgeEnabled;
    VerticalScrollBarEnabled;
    VerticalScrollbarPosition;
    Visibility;
    WillNotCacheDrawing;
    WillNotDraw;
    X;
    Y;
    Z;
    CornerRadius;
    BackgroundTintList;
    RippleColor;
    Orientation;
    MultiGradient;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscViewBase.VerticalFadingEdgeEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setVerticalFadingEdgeEnabled(Enabled);
end;

function TPscViewBase.VerticalFadingEdgeEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('VerticalFadingEdgeEnabledAttribute') then
    VerticalFadingEdgeEnabled(VerticalFadingEdgeEnabledAttribute(FAttributes['VerticalFadingEdgeEnabledAttribute']).Value);
end;

function TPscViewBase.VerticalScrollBarEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setVerticalScrollBarEnabled(Enabled);
end;

function TPscViewBase.VerticalScrollBarEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('VerticalScrollBarEnabledAttribute') then
    VerticalScrollBarEnabled(VerticalScrollBarEnabledAttribute(FAttributes['VerticalScrollBarEnabledAttribute']).Value);
end;

function TPscViewBase.VerticalScrollbarPosition(Position: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setVerticalScrollbarPosition(Position);
end;

function TPscViewBase.VerticalScrollbarPosition: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('VerticalScrollbarPositionAttribute') then
    VerticalScrollbarPosition(VerticalScrollbarPositionAttribute(FAttributes['VerticalScrollbarPositionAttribute']).Value);
end;

function TPscViewBase.Visibility(Visibility: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setVisibility(Visibility);
end;

function TPscViewBase.Visibility: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('VisibilityAttribute') then
    Visibility(VisibilityAttribute(FAttributes['VisibilityAttribute']).Value);
end;

function TPscViewBase.WillNotCacheDrawing(Value: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setWillNotCacheDrawing(Value);
end;

function TPscViewBase.WillNotCacheDrawing: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('WillNotCacheDrawingAttribute') then
    WillNotCacheDrawing(WillNotCacheDrawingAttribute(FAttributes['WillNotCacheDrawingAttribute']).Value);
end;

function TPscViewBase.WillNotDraw(Value: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setWillNotDraw(Value);
end;

function TPscViewBase.WillNotDraw: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('WillNotDrawAttribute') then
    WillNotDraw(WillNotDrawAttribute(FAttributes['WillNotDrawAttribute']).Value);
end;

function TPscViewBase.X(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setX(Value);
end;

function TPscViewBase.X: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('XAttribute') then
    X(XAttribute(FAttributes['XAttribute']).Value);
end;

function TPscViewBase.Y(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setY(Value);
end;

function TPscViewBase.Y: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('YAttribute') then
    Y(YAttribute(FAttributes['YAttribute']).Value);
end;

function TPscViewBase.Z(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setZ(Value);
end;

function TPscViewBase.Z: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ZAttribute') then
    Z(ZAttribute(FAttributes['ZAttribute']).Value);
end;

function TPscViewBase.ScrollbarFadingEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setScrollbarFadingEnabled(Enabled);
end;

function TPscViewBase.ScrollbarFadingEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollbarFadingEnabledAttribute') then
    ScrollbarFadingEnabled(ScrollbarFadingEnabledAttribute(FAttributes['ScrollbarFadingEnabledAttribute']).Value);
end;

function TPscViewBase.Selected(Selected: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setSelected(Selected);
end;

function TPscViewBase.Selected: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('SelectedAttribute') then
    Selected(SelectedAttribute(FAttributes['SelectedAttribute']).Value);
end;

function TPscViewBase.SoundEffectsEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setSoundEffectsEnabled(Enabled);
end;

function TPscViewBase.SoundEffectsEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('SoundEffectsEnabledAttribute') then
    SoundEffectsEnabled(SoundEffectsEnabledAttribute(FAttributes['SoundEffectsEnabledAttribute']).Value);
end;

function TPscViewBase.TextAlignment(Alignment: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setTextAlignment(Alignment);
end;

function TPscViewBase.TextAlignment: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextAlignmentAttribute') then
    TextAlignment(TextAlignmentAttribute(FAttributes['TextAlignmentAttribute']).Value);
end;

function TPscViewBase.TextDirection(Direction: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setTextDirection(Direction);
end;

function TPscViewBase.TextDirection: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextDirectionAttribute') then
    TextDirection(TextDirectionAttribute(FAttributes['TextDirectionAttribute']).Value);
end;

function TPscViewBase.Top(Top: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setTop(Top);
end;

function TPscViewBase.Top: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TopAttribute') then
    Top(TopAttribute(FAttributes['TopAttribute']).Value);
end;

function TPscViewBase.TransitionAlpha(Alpha: Single): IPscViewBase;
begin
  Result := Self;
  FView.setTransitionAlpha(Alpha);
end;

function TPscViewBase.TransitionAlpha: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TransitionAlphaAttribute') then
    TransitionAlpha(TransitionAlphaAttribute(FAttributes['TransitionAlphaAttribute']).Value);
end;

function TPscViewBase.TransitionVisibility(Visibility: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setTransitionVisibility(Visibility);
end;

function TPscViewBase.TransitionVisibility: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TransitionVisibilityAttribute') then
    TransitionVisibility(TransitionVisibilityAttribute(FAttributes['TransitionVisibilityAttribute']).Value);
end;

function TPscViewBase.TranslationX(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setTranslationX(Value);
end;

function TPscViewBase.TranslationX: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TranslationXAttribute') then
    TranslationX(TranslationXAttribute(FAttributes['TranslationXAttribute']).Value);
end;

function TPscViewBase.TranslationY(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setTranslationY(Value);
end;

function TPscViewBase.TranslationY: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TranslationYAttribute') then
    TranslationY(TranslationYAttribute(FAttributes['TranslationYAttribute']).Value);
end;

function TPscViewBase.TranslationZ(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setTranslationZ(Value);
end;

function TPscViewBase.TranslationZ: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('TranslationZAttribute') then
    TranslationZ(TranslationZAttribute(FAttributes['TranslationZAttribute']).Value);
end;

function TPscViewBase.ScreenReaderFocusable(Focusable: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setScreenReaderFocusable(Focusable);
end;

function TPscViewBase.ScreenOrientation(Orientation: TScreenOrientation): IPscViewBase;
begin
  Result := Self;
  TPscUtils.SetScreenOrientation(Orientation);
end;

function TPscViewBase.ScreenOrientation: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScreenOrientationAttribute') then
    ScreenOrientation(ScreenOrientationAttribute(FAttributes['ScreenOrientationAttribute']).Orientation);
end;

function TPscViewBase.ScreenReaderFocusable: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScreenReaderFocusableAttribute') then
    ScreenReaderFocusable(ScreenReaderFocusableAttribute(FAttributes['ScreenReaderFocusableAttribute']).Value);
end;

function TPscViewBase.ScrollBarDefaultDelayBeforeFade(Delay: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollBarDefaultDelayBeforeFade(Delay);
end;

function TPscViewBase.ScrollBarDefaultDelayBeforeFade: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollBarDefaultDelayBeforeFadeAttribute') then
    ScrollBarDefaultDelayBeforeFade(ScrollBarDefaultDelayBeforeFadeAttribute(FAttributes['ScrollBarDefaultDelayBeforeFadeAttribute']).Value);
end;

function TPscViewBase.ScrollBarFadeDuration(Duration: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollBarFadeDuration(Duration);
end;

function TPscViewBase.ScrollBarFadeDuration: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollBarFadeDurationAttribute') then
    ScrollBarFadeDuration(ScrollBarFadeDurationAttribute(FAttributes['ScrollBarFadeDurationAttribute']).Value);
end;

function TPscViewBase.ScrollBarSize(Size: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollBarSize(Size);
end;

function TPscViewBase.ScrollBarSize: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollBarSizeAttribute') then
    ScrollBarSize(ScrollBarSizeAttribute(FAttributes['ScrollBarSizeAttribute']).Value);
end;

function TPscViewBase.ScrollBarStyle(Style: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollBarStyle(Style);
end;

function TPscViewBase.ScrollBarStyle: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollBarStyleAttribute') then
    ScrollBarStyle(ScrollBarStyleAttribute(FAttributes['ScrollBarStyleAttribute']).Value);
end;

function TPscViewBase.ScrollCaptureHint(Hint: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollCaptureHint(Hint);
end;

function TPscViewBase.ScrollCaptureHint: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollCaptureHintAttribute') then
    ScrollCaptureHint(ScrollCaptureHintAttribute(FAttributes['ScrollCaptureHintAttribute']).Value);
end;

function TPscViewBase.ScrollContainer(IsContainer: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setScrollContainer(IsContainer);
end;

function TPscViewBase.ScrollContainer: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollContainerAttribute') then
    ScrollContainer(ScrollContainerAttribute(FAttributes['ScrollContainerAttribute']).Value);
end;

function TPscViewBase.ScrollIndicators(Indicators: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollIndicators(Indicators);
end;

function TPscViewBase.ScrollIndicators(Indicators, Mask: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollIndicators(Indicators, Mask);
end;

function TPscViewBase.ScrollIndicators: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollIndicatorsAttribute') then
    ScrollIndicators(ScrollIndicatorsAttribute(FAttributes['ScrollIndicatorsAttribute']).Indicators);
end;

function TPscViewBase.ScrollX(Value: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollX(Value);
end;

function TPscViewBase.ScrollX: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollXAttribute') then
    ScrollX(ScrollXAttribute(FAttributes['ScrollXAttribute']).Value);
end;

function TPscViewBase.ScrollY(Value: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setScrollY(Value);
end;

function TPscViewBase.ScrollY: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScrollYAttribute') then
    ScrollY(ScrollYAttribute(FAttributes['ScrollYAttribute']).Value);
end;

function TPscViewBase.PreferKeepClear(Prefer: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setPreferKeepClear(Prefer);
end;

function TPscViewBase.PreferKeepClear: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('PreferKeepClearAttribute') then
    PreferKeepClear(PreferKeepClearAttribute(FAttributes['PreferKeepClearAttribute']).Value);
end;

function TPscViewBase.Pressed(Pressed: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setPressed(Pressed);
end;

function TPscViewBase.Pressed: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('PressedAttribute') then
    Pressed(PressedAttribute(FAttributes['PressedAttribute']).Value);
end;

function TPscViewBase.RevealOnFocusHint(Reveal: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setRevealOnFocusHint(Reveal);
end;

function TPscViewBase.RevealOnFocusHint: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('RevealOnFocusHintAttribute') then
    RevealOnFocusHint(RevealOnFocusHintAttribute(FAttributes['RevealOnFocusHintAttribute']).Value);
end;

function TPscViewBase.Right(Right: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setRight(Right);
end;

function TPscViewBase.Right: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('RightAttribute') then
    Right(RightAttribute(FAttributes['RightAttribute']).Value);
end;

function TPscViewBase.RippleColor(Color: Integer): IPscViewBase;
var
  BackgroundColor: Integer; CornerRadius: Double;
  ResourceDrawable: JDrawable; ResName, ResLoc: String;
begin
  Result := Self;
  BackgroundColor := 0;
  CornerRadius := 0;

  if FAttributes.ContainsKey('BackgroundColorAttribute') then
    BackgroundColor := BackgroundColorAttribute(FAttributes['BackgroundColorAttribute']).Value;

  if FAttributes.ContainsKey('CornerRadiusAttribute') then
    CornerRadius := CornerRadiusAttribute(FAttributes['CornerRadiusAttribute']).Value;

  if FAttributes.ContainsKey('BackgroundResourceAttribute') then begin
    ResName := BackgroundResourceAttribute(FAttributes['BackgroundResourceAttribute']).ResourceName;
    ResLoc := BackgroundResourceAttribute(FAttributes['BackgroundResourceAttribute']).Location;
    ResourceDrawable := TPscUtils.GetDrawable(ResName, ResLoc);
    TPscUtils.SetBackgroundWithRipple(FView, ResourceDrawable, Color, CornerRadius);
  end else if FAttributes.ContainsKey('ImageResourceAttribute') then begin
    ResName := ImageResourceAttribute(FAttributes['ImageResourceAttribute']).ResourceName;
    ResLoc := ImageResourceAttribute(FAttributes['ImageResourceAttribute']).Location;
    ResourceDrawable := TPscUtils.GetDrawable(ResName, ResLoc);
    TPscUtils.SetForegroundRipple(FView, Color, CornerRadius);
  end else begin
    TPscUtils.SetBackgroundWithRipple(FView, BackgroundColor, Color, CornerRadius);
  end;
end;

function TPscViewBase.RippleColor: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('RippleColorAttribute') then
    RippleColor(RippleColorAttribute(FAttributes['RippleColorAttribute']).Value);
end;

function TPscViewBase.Rotation(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setRotation(Value);
end;

function TPscViewBase.Rotation: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('RotationAttribute') then
    Rotation(RotationAttribute(FAttributes['RotationAttribute']).Value);
end;

function TPscViewBase.RotationX(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setRotationX(Value);
end;

function TPscViewBase.RotationX: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('RotationXAttribute') then
    RotationX(RotationXAttribute(FAttributes['RotationXAttribute']).Value);
end;

function TPscViewBase.RotationY(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setRotationY(Value);
end;

function TPscViewBase.RotationY: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('RotationYAttribute') then
    RotationY(RotationYAttribute(FAttributes['RotationYAttribute']).Value);
end;

function TPscViewBase.SaveEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setSaveEnabled(Enabled);
end;

function TPscViewBase.SaveEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('SaveEnabledAttribute') then
    SaveEnabled(SaveEnabledAttribute(FAttributes['SaveEnabledAttribute']).Value);
end;

function TPscViewBase.SaveFromParentEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setSaveFromParentEnabled(Enabled);
end;

function TPscViewBase.SaveFromParentEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('SaveFromParentEnabledAttribute') then
    SaveFromParentEnabled(SaveFromParentEnabledAttribute(FAttributes['SaveFromParentEnabledAttribute']).Value);
end;

function TPscViewBase.ScaleX(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setScaleX(Value);
end;

function TPscViewBase.ScaleX: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScaleXAttribute') then
    ScaleX(ScaleXAttribute(FAttributes['ScaleXAttribute']).Value);
end;

function TPscViewBase.ScaleY(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setScaleY(Value);
end;

function TPscViewBase.ScaleY: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScaleYAttribute') then
    ScaleY(ScaleYAttribute(FAttributes['ScaleYAttribute']).Value);
end;

function TPscViewBase.OutlineAmbientShadowColor(Color: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setOutlineAmbientShadowColor(Color);
end;

function TPscViewBase.Orientation(Value: Integer): IPscViewBase;
begin
  Result := Self;
  TJLinearLayout.Wrap(FView).setOrientation(Value);
end;

function TPscViewBase.Orientation: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('OrientationAttribute') then
    Orientation(OrientationAttribute(FAttributes['OrientationAttribute']).Value);
end;

function TPscViewBase.OutlineAmbientShadowColor: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('OutlineAmbientShadowColorAttribute') then
    OutlineAmbientShadowColor(OutlineAmbientShadowColorAttribute(FAttributes['OutlineAmbientShadowColorAttribute']).Value);
end;

function TPscViewBase.OutlineSpotShadowColor(Color: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setOutlineSpotShadowColor(Color);
end;

function TPscViewBase.OutlineSpotShadowColor: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('OutlineSpotShadowColorAttribute') then
    OutlineSpotShadowColor(OutlineSpotShadowColorAttribute(FAttributes['OutlineSpotShadowColorAttribute']).Value);
end;

function TPscViewBase.OverScrollMode(Mode: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setOverScrollMode(Mode);
end;

function TPscViewBase.OverScrollMode: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('OverScrollModeAttribute') then
    OverScrollMode(OverScrollModeAttribute(FAttributes['OverScrollModeAttribute']).Mode);
end;

function TPscViewBase.PaddingRelative(Start, Top, End_, Bottom: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setPaddingRelative(Start, Top, End_, Bottom);
end;

function TPscViewBase.PaddingRelative: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('PaddingRelativeAttribute') then
    with PaddingRelativeAttribute(FAttributes['PaddingRelativeAttribute']) do
      PaddingRelative(
        PaddingAttribute(FAttributes['PaddingAttribute']).Left,
        PaddingAttribute(FAttributes['PaddingAttribute']).Top,
        PaddingAttribute(FAttributes['PaddingAttribute']).Right,
        PaddingAttribute(FAttributes['PaddingAttribute']).Bottom
      );
end;

function TPscViewBase.PivotX(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setPivotX(Value);
end;

function TPscViewBase.PivotX: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('PivotXAttribute') then
    PivotX(PivotXAttribute(FAttributes['PivotXAttribute']).Value);
end;

function TPscViewBase.PivotY(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setPivotY(Value);
end;

function TPscViewBase.PivotY: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('PivotYAttribute') then
    PivotY(PivotYAttribute(FAttributes['PivotYAttribute']).Value);
end;

function TPscViewBase.MinimumWidth(MinWidth: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setMinimumWidth(MinWidth);
end;

function TPscViewBase.MinimumWidth: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('MinimumWidthAttribute') then
    MinimumWidth(MinimumWidthAttribute(FAttributes['MinimumWidthAttribute']).Value);
end;

function TPscViewBase.MultiGradient(const ColorStops: TColorStopArray; Orientation: TGradientOrientation; CornerRadius, GradientRadius: Single; Shape: TGradientShape): IPscViewBase;
begin
  Result := Self;
  TPscUtils.SetMultiGradientBackground(FView, ColorStops, Orientation, CornerRadius, GradientRadius, Shape);
end;

function TPscViewBase.MultiGradient: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('MultiGradientAttribute') then
    with MultiGradientAttribute(FAttributes['MultiGradientAttribute']) do
      MultiGradient(ColorStops, Orientation, CornerRadius, GradientRadius, Shape);
end;

function TPscViewBase.NestedScrollingEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setNestedScrollingEnabled(Enabled);
end;

function TPscViewBase.NestedScrollingEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NestedScrollingEnabledAttribute') then
    NestedScrollingEnabled(NestedScrollingEnabledAttribute(FAttributes['NestedScrollingEnabledAttribute']).Value);
end;

function TPscViewBase.NextClusterForwardId(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setNextClusterForwardId(Id);
end;

function TPscViewBase.NextClusterForwardId: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NextClusterForwardIdAttribute') then
    NextClusterForwardId(NextClusterForwardIdAttribute(FAttributes['NextClusterForwardIdAttribute']).Value);
end;

function TPscViewBase.NextFocusDownId(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setNextFocusDownId(Id);
end;

function TPscViewBase.NextFocusDownId: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NextFocusDownIdAttribute') then
    NextFocusDownId(NextFocusDownIdAttribute(FAttributes['NextFocusDownIdAttribute']).Value);
end;

function TPscViewBase.NextFocusForwardId(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setNextFocusForwardId(Id);
end;

function TPscViewBase.NextFocusForwardId: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NextFocusForwardIdAttribute') then
    NextFocusForwardId(NextFocusForwardIdAttribute(FAttributes['NextFocusForwardIdAttribute']).Value);
end;

function TPscViewBase.NextFocusLeftId(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setNextFocusLeftId(Id);
end;

function TPscViewBase.NextFocusLeftId: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NextFocusLeftIdAttribute') then
    NextFocusLeftId(NextFocusLeftIdAttribute(FAttributes['NextFocusLeftIdAttribute']).Value);
end;

function TPscViewBase.NextFocusRightId(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setNextFocusRightId(Id);
end;

function TPscViewBase.NextFocusRightId: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NextFocusRightIdAttribute') then
    NextFocusRightId(NextFocusRightIdAttribute(FAttributes['NextFocusRightIdAttribute']).Value);
end;

function TPscViewBase.NextFocusUpId(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setNextFocusUpId(Id);
end;

function TPscViewBase.NextFocusUpId: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('NextFocusUpIdAttribute') then
    NextFocusUpId(NextFocusUpIdAttribute(FAttributes['NextFocusUpIdAttribute']).Value);
end;


function TPscViewBase.KeyboardNavigationCluster(IsCluster: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setKeyboardNavigationCluster(IsCluster);
end;

function TPscViewBase.KeyboardNavigationCluster: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('KeyboardNavigationClusterAttribute') then
    KeyboardNavigationCluster(KeyboardNavigationClusterAttribute(FAttributes['KeyboardNavigationClusterAttribute']).Value);
end;

function TPscViewBase.LabelFor(Id: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setLabelFor(Id);
end;

function TPscViewBase.LabelFor: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('LabelForAttribute') then
    LabelFor(LabelForAttribute(FAttributes['LabelForAttribute']).Value);
end;

function TPscViewBase.Left(Left: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setLeft(Left);
end;

function TPscViewBase.Left: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('LeftAttribute') then
    Left(LeftAttribute(FAttributes['LeftAttribute']).Value);
end;

function TPscViewBase.LeftTopRightBottom(ALeft, ATop, ARight, ABottom: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setLeftTopRightBottom(ALeft, ATop, ARight, ABottom);
end;

function TPscViewBase.LeftTopRightBottom: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('LeftTopRightBottomAttribute') then
    with LeftTopRightBottomAttribute(FAttributes['LeftTopRightBottomAttribute']) do
      LeftTopRightBottom(Left, Top, Right, Bottom);
end;

function TPscViewBase.LongClickable(LongClickable: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setLongClickable(LongClickable);
end;

function TPscViewBase.LongClickable: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('LongClickableAttribute') then
    LongClickable(LongClickableAttribute(FAttributes['LongClickableAttribute']).Value);
end;

function TPscViewBase.MinimumHeight(MinHeight: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setMinimumHeight(MinHeight);
end;

function TPscViewBase.MinimumHeight: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('MinimumHeightAttribute') then
    MinimumHeight(MinimumHeightAttribute(FAttributes['MinimumHeightAttribute']).Value);
end;


function TPscViewBase.HorizontalFadingEdgeEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setHorizontalFadingEdgeEnabled(Enabled);
end;

function TPscViewBase.HorizontalFadingEdgeEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('HorizontalFadingEdgeEnabledAttribute') then
    HorizontalFadingEdgeEnabled(HorizontalFadingEdgeEnabledAttribute(FAttributes['HorizontalFadingEdgeEnabledAttribute']).Value);
end;

function TPscViewBase.HorizontalScrollBarEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setHorizontalScrollBarEnabled(Enabled);
end;

function TPscViewBase.HorizontalScrollBarEnabled: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('HorizontalScrollBarEnabledAttribute') then
    HorizontalScrollBarEnabled(HorizontalScrollBarEnabledAttribute(FAttributes['HorizontalScrollBarEnabledAttribute']).Value);
end;

function TPscViewBase.Hovered(Hovered: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setHovered(Hovered);
end;

function TPscViewBase.Hovered: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('HoveredAttribute') then
    Hovered(HoveredAttribute(FAttributes['HoveredAttribute']).Value);
end;

function TPscViewBase.ImportantForAccessibility(Mode: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setImportantForAccessibility(Mode);
end;

function TPscViewBase.ImportantForAccessibility: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ImportantForAccessibilityAttribute') then
    ImportantForAccessibility(ImportantForAccessibilityAttribute(FAttributes['ImportantForAccessibilityAttribute']).Value);
end;

function TPscViewBase.ImportantForAutofill(Mode: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setImportantForAutofill(Mode);
end;

function TPscViewBase.ImportantForAutofill: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ImportantForAutofillAttribute') then
    ImportantForAutofill(ImportantForAutofillAttribute(FAttributes['ImportantForAutofillAttribute']).Value);
end;

function TPscViewBase.ImportantForContentCapture(Mode: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setImportantForContentCapture(Mode);
end;

function TPscViewBase.ImportantForContentCapture: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('ImportantForContentCaptureAttribute') then
    ImportantForContentCapture(ImportantForContentCaptureAttribute(FAttributes['ImportantForContentCaptureAttribute']).Value);
end;

function TPscViewBase.KeepScreenOn(KeepOn: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setKeepScreenOn(KeepOn);
end;

function TPscViewBase.KeepScreenOn: IPscViewBase;
begin
  Result := Self;
  if FAttributes.ContainsKey('KeepScreenOnAttribute') then
    KeepScreenOn(KeepScreenOnAttribute(FAttributes['KeepScreenOnAttribute']).Value);
end;

function TPscViewBase.ForegroundGravity(Gravity: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setForegroundGravity(Gravity);
end;

function TPscViewBase.ForegroundGravity: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ForegroundGravityAttribute')) then
    ForegroundGravity(ForegroundGravityAttribute(FAttributes['ForegroundGravityAttribute']).Value);
end;

function TPscViewBase.ForceDarkAllowed(Allow: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setForceDarkAllowed(Allow);
end;

function TPscViewBase.ForceDarkAllowed: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ForceDarkAllowedAttribute')) then
    ForceDarkAllowed(ForceDarkAllowedAttribute(FAttributes['ForceDarkAllowedAttribute']).Value);
end;

function TPscViewBase.FocusedByDefault(IsFocusedByDefault: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setFocusedByDefault(IsFocusedByDefault);
end;

function TPscViewBase.FocusedByDefault: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FocusedByDefaultAttribute')) then
    FocusedByDefault(FocusedByDefaultAttribute(FAttributes['FocusedByDefaultAttribute']).Value);
end;

function TPscViewBase.HapticFeedbackEnabled(HapticFeedbackEnabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setHapticFeedbackEnabled(HapticFeedbackEnabled);
end;

function TPscViewBase.HapticFeedbackEnabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('HapticFeedbackEnabledAttribute')) then
    HapticFeedbackEnabled(HapticFeedbackEnabledAttribute(FAttributes['HapticFeedbackEnabledAttribute']).Value);
end;

function TPscViewBase.HasTransientState(HasTransientState: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setHasTransientState(HasTransientState);
end;

function TPscViewBase.HasTransientState: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('HasTransientStateAttribute')) then
    HasTransientState(HasTransientStateAttribute(FAttributes['HasTransientStateAttribute']).Value);
end;

function TPscViewBase.DrawingCacheEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setDrawingCacheEnabled(Enabled);
end;

function TPscViewBase.DrawingCacheEnabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('DrawingCacheEnabledAttribute')) then
    DrawingCacheEnabled(DrawingCacheEnabledAttribute(FAttributes['DrawingCacheEnabledAttribute']).Value);
end;

function TPscViewBase.DrawingCacheQuality(Quality: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setDrawingCacheQuality(Quality);
end;

function TPscViewBase.DrawingCacheQuality: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('DrawingCacheQualityAttribute')) then
    DrawingCacheQuality(DrawingCacheQualityAttribute(FAttributes['DrawingCacheQualityAttribute']).Quality);
end;

function TPscViewBase.DuplicateParentStateEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setDuplicateParentStateEnabled(Enabled);
end;

function TPscViewBase.DuplicateParentStateEnabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('DuplicateParentStateEnabledAttribute')) then
    DuplicateParentStateEnabled(DuplicateParentStateEnabledAttribute(FAttributes['DuplicateParentStateEnabledAttribute']).Value);
end;

function TPscViewBase.FadingEdgeLength(Length: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setFadingEdgeLength(Length);
end;

function TPscViewBase.FadingEdgeLength: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FadingEdgeLengthAttribute')) then
    FadingEdgeLength(FadingEdgeLengthAttribute(FAttributes['FadingEdgeLengthAttribute']).Value);
end;

function TPscViewBase.FilterTouchesWhenObscured(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setFilterTouchesWhenObscured(Enabled);
end;

function TPscViewBase.FilterTouchesWhenObscured: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FilterTouchesWhenObscuredAttribute')) then
    FilterTouchesWhenObscured(FilterTouchesWhenObscuredAttribute(FAttributes['FilterTouchesWhenObscuredAttribute']).Value);
end;

function TPscViewBase.FitsSystemWindows(FitSystemWindows: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setFitsSystemWindows(FitSystemWindows);
end;

function TPscViewBase.FitsSystemWindows: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FitsSystemWindowsAttribute')) then
    FitsSystemWindows(FitsSystemWindowsAttribute(FAttributes['FitsSystemWindowsAttribute']).Value);
end;

function TPscViewBase.FocusableInTouchMode(Focusable: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setFocusable(Focusable);
end;

function TPscViewBase.FocusableInTouchMode: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FocusableInTouchModeAttribute')) then
    FocusableInTouchMode(FocusableInTouchModeAttribute(FAttributes['FocusableInTouchModeAttribute']).Mode);
end;

function TPscViewBase.Bottom(Bottom: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setBottom(Bottom);
end;

function TPscViewBase.Bottom: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('BottomAttribute')) then
    Bottom(BottomAttribute(FAttributes['BottomAttribute']).Value);
end;

function TPscViewBase.CameraDistance(Distance: Single): IPscViewBase;
begin
  Result := Self;
  FView.setCameraDistance(Distance);
end;

function TPscViewBase.CameraDistance: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('CameraDistanceAttribute')) then
    CameraDistance(CameraDistanceAttribute(FAttributes['CameraDistanceAttribute']).Value);
end;

function TPscViewBase.ClipToOutline(ClipToOutline: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setClipToOutline(ClipToOutline);
end;

function TPscViewBase.ClipToOutline: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ClipToOutlineAttribute')) then
    ClipToOutline(ClipToOutlineAttribute(FAttributes['ClipToOutlineAttribute']).Value);
end;

function TPscViewBase.ContextClickable(ContextClickable: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setContextClickable(ContextClickable);
end;

function TPscViewBase.ContextClickable: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ContextClickableAttribute')) then
    ContextClickable(ContextClickableAttribute(FAttributes['ContextClickableAttribute']).Value);
end;

function TPscViewBase.CornerRadius(Value: Double): IPscViewbase;
var
  BgColor: Integer;
begin
  Result := Self;
  BgColor := 0;

  if FAttributes.ContainsKey('BackgroundColorAttribute') then
    BgColor := BackgroundColorAttribute(FAttributes['BackgroundColorAttribute']).Value;

  if (FAttributes.ContainsKey('BackgroundResourceAttribute')) or (FAttributes.ContainsKey('ImageResourceAttribute')) then begin
    TPscUtils.SetRoundedCorners(FView, Value);
  end else begin
    TPscUtils.SetRoundedCorners(FView, Value, BgColor);
  end;
end;

function TPscViewBase.CornerRadius: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('CornerRadiusAttribute')) then
    CornerRadius(CornerRadiusAttribute(FAttributes['CornerRadiusAttribute']).Value);
end;

function TPscViewBase.DefaultFocusHighlightEnabled(DefaultFocusHighlightEnabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setDefaultFocusHighlightEnabled(DefaultFocusHighlightEnabled);
end;

function TPscViewBase.DefaultFocusHighlightEnabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('DefaultFocusHighlightEnabledAttribute')) then
    DefaultFocusHighlightEnabled(DefaultFocusHighlightEnabledAttribute(FAttributes['DefaultFocusHighlightEnabledAttribute']).Value);
end;

function TPscViewBase.DrawingCacheBackgroundColor(Color: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setDrawingCacheBackgroundColor(Color);
end;

function TPscViewBase.DrawingCacheBackgroundColor: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('DrawingCacheBackgroundColorAttribute')) then
    DrawingCacheBackgroundColor(DrawingCacheBackgroundColorAttribute(FAttributes['DrawingCacheBackgroundColorAttribute']).Value);
end;

function TPscViewBase.AutoHandwritingEnabled(Enabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setAutoHandwritingEnabled(Enabled);
end;

function TPscViewBase.AutoHandwritingEnabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AutoHandwritingEnabledAttribute')) then
    AutoHandwritingEnabled(AutoHandwritingEnabledAttribute(FAttributes['AutoHandwritingEnabledAttribute']).Value);
end;

function TPscViewBase.BackgroundResource(ResName, Location: String): IPscViewBase;
var
  ResId: Integer;
begin
  Result := Self;
  ResId := TPscUtils.FindResourceId(ResName, Location);
  FView.setBackgroundResource(ResId);
end;

function TPscViewBase.BackgroundResource: IPscViewBase;
var
  ResName, ResLocation: String;
begin
  Result := Self;
  if (FAttributes.ContainsKey('BackgroundResourceAttribute')) then
  begin
    ResName := BackgroundResourceAttribute(FAttributes['BackgroundResourceAttribute']).ResourceName;
    ResLocation := BackgroundResourceAttribute(FAttributes['BackgroundResourceAttribute']).Location;
    BackgroundResource(ResName, ResLocation);
  end;
end;

function TPscViewBase.BackgroundTintList(AColor: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setBackgroundTintList(TJColorStateList.JavaClass.valueOf(AColor));
end;

function TPscViewBase.BackgroundTintList: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('BackgroundTintListAttribute')) then
    BackgroundTintList(BackgroundTintListAttribute(FAttributes['BackgroundTintListAttribute']).Value);
end;

function TPscViewBase.BackgroundColor(AColor: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setBackgroundColor(AColor);
end;

function TPscViewBase.BackgroundColor: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('BackgroundColorAttribute')) then
    BackgroundColor(BackgroundColorAttribute(FAttributes['BackgroundColorAttribute']).Value);
end;

function TPscViewBase.Clickable: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ClickableAttribute')) then
    Clickable(ClickableAttribute(FAttributes['ClickableAttribute']).Value);
end;

function TPscViewBase.Clickable(IsClickable: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setClickable(IsClickable);
end;

constructor TPscViewBase.Create(Attributes: TArray<TCustomAttribute>);
begin
  try
    FAttributes := TDictionary<String, TCustomAttribute>.Create;
    FContext := TAndroidHelper.Context;
    TPscUtils.ConvertAttributesToDictionary(Attributes, FAttributes);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Create', TLogger.Error, Self);
  end;
end;

function TPscViewBase.DarkStatusBar: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('DarkStatusBarIconsAttribute')) then
    if (DarkStatusBarIconsAttribute(FAttributes['DarkStatusBarIconsAttribute']).Value = True) then
      TPscUtils.StatusBarDarkIcons(FView);
end;

destructor TPscViewBase.Destroy;
begin
  FAttributes.Free;
  inherited;
end;

function TPscViewBase.Elevation: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ElevationAttribute')) then
    Elevation(ElevationAttribute(FAttributes['ElevationAttribute']).Value);
end;

function TPscViewBase.Enabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('EnabledAttribute')) then
    Enabled(EnabledAttribute(FAttributes['EnabledAttribute']).Value);
end;

function TPscViewBase.Enabled(IsEnabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setEnabled(IsEnabled);
end;

function TPscViewBase.Layout(AWidth, AHeight: Integer): IPscViewBase;
begin
  Result := Self;
  FLayoutParams := TJViewGroup_LayoutParams.JavaClass.init(AWidth, AHeight);
  FView.setLayoutParams(FLayoutParams);
end;

function TPscViewBase.Padding(Left, Top, Right, Bottom: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setPadding(Left, Top, Right, Bottom);
end;

function TPscViewBase.Padding: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('PaddingAttribute')) then begin
    Padding(
      PaddingAttribute(FAttributes['PaddingAttribute']).Left,
      PaddingAttribute(FAttributes['PaddingAttribute']).Top,
      PaddingAttribute(FAttributes['PaddingAttribute']).Right,
      PaddingAttribute(FAttributes['PaddingAttribute']).Bottom
    );
  end;
end;

function TPscViewBase.Position: IPscViewBase;
var
  X, Y: Single;
begin
  Result := Self;
  if (FAttributes.ContainsKey('PositionAttribute')) then begin
    X := PositionAttribute(FAttributes['PositionAttribute']).X;
    Y := PositionAttribute(FAttributes['PositionAttribute']).Y;
    Position(X, Y);
  end;
end;

function TPscViewBase.Position(X, Y: Single): IPscViewBase;
begin
  Result := Self;
  FView.setX(X);
  FView.setY(Y);
end;

function TPscViewBase.GetView: JView;
begin
  if Assigned(FView) then begin
    Result := FView;
    TPscUtils.Log('', 'GetView', TLogger.Info, Self);
  end else
    TPscUtils.Log('View is not assigned (null)', 'GetView', TLogger.Error, Self);
end;

function TPscViewBase.Visible: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('VisibleAttribute')) then
    Visible(VisibleAttribute(FAttributes['HeightAttribute']).Value);
end;

function TPscViewBase.Visible(Visible: Boolean): IPscViewBase;
begin
  Result := Self;
  if Visible then
    FView.setVisibility(TJView.JavaClass.VISIBLE)
  else
    FView.setVisibility(TJView.JavaClass.INVISIBLE);
end;

function TPscViewBase.Elevation(Value: Single): IPscViewBase;
begin
  Result := Self;
  FView.setElevation(Value);
end;

function TPscViewBase.Focusable: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FocusableAttribute')) then
    Focusable(FocusableAttribute(FAttributes['FocusableAttribute']).Value);
end;

function TPscViewBase.Focusable(IsFocusable: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setFocusable(IsFocusable);
end;

function TPscViewBase.FullScreen: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('FullScreenAttribute')) then
    if (FullScreenAttribute(FAttributes['FullScreenAttribute']).Value = True) then
      TPscUtils.EnableFullScreenOnView(FView);
end;

function TPscViewBase.Id: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('IdAttribute')) then
    Id(IdAttribute(FAttributes['IdAttribute']).Value);
end;

function TPscViewBase.Id(AId: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setId(AId);
end;

function TPscViewBase.Layout: IPscViewBase;
var
  Width, Height: Integer;
  DisplayMetrics: JDisplayMetrics;
  ScreenWidth, ScreenHeight: Integer;
begin
  Result := Self;

  // Get screen dimensions for percentage calculations
  DisplayMetrics := TJDisplayMetrics.JavaClass.init;
  TAndroidHelper.Activity.getWindowManager.getDefaultDisplay.getMetrics(DisplayMetrics);
  ScreenWidth := DisplayMetrics.widthPixels;
  ScreenHeight := DisplayMetrics.heightPixels;

  // Handle Width
  if (FAttributes.ContainsKey('WidthPercentAttribute')) then
    Width := Round(ScreenWidth * WidthPercentAttribute(FAttributes['WidthPercentAttribute']).Value)
  else if (FAttributes.ContainsKey('WidthAttribute')) then
    Width := WidthAttribute(FAttributes['WidthAttribute']).Value
  else
    Width := TJViewGroup_LayoutParams.JavaClass.MATCH_PARENT;

  // Handle Height
  if (FAttributes.ContainsKey('HeightPercentAttribute')) then
    Height := Round(ScreenHeight * HeightPercentAttribute(FAttributes['HeightPercentAttribute']).Value)
  else if (FAttributes.ContainsKey('HeightAttribute')) then
    Height := HeightAttribute(FAttributes['HeightAttribute']).Value
  else
    Height := TJViewGroup_LayoutParams.JavaClass.MATCH_PARENT;

  Layout(Width, Height);
end;

function TPscViewBase.LayoutDirection: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('LayoutDirectionAttribute')) then
    LayoutDirection(LayoutDirectionAttribute(FAttributes['LayoutDirectionAttribute']).Value);
end;

function TPscViewBase.LayoutDirection(Direction: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setLayoutDirection(Direction);
end;

function TPscViewBase.StatusbarColor: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('StatusBarColorAttribute')) then
    StatusbarColor(StatusBarColorAttribute(FAttributes['StatusBarColorAttribute']).Value)
  else
    StatusbarColor(TJColor.JavaClass.TRANSPARENT);
end;

function TPscViewBase.StatusbarColor(Color: Integer): IPscViewBase;
begin
  Result := Self;
  TPscUtils.StatusBarColor(Color);
end;

function TPscViewBase.AccessibilityHeading(IsHeading: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setAccessibilityHeading(IsHeading);
end;

function TPscViewBase.AccessibilityHeading: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AccessibilityHeadingAttribute')) then
    AccessibilityHeading(AccessibilityHeadingAttribute(FAttributes['AccessibilityHeadingAttribute']).Value);
end;

function TPscViewBase.AccessibilityLiveRegion(Mode: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setAccessibilityLiveRegion(Mode);
end;

function TPscViewBase.AccessibilityLiveRegion: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AccessibilityLiveRegionAttribute')) then
    AccessibilityLiveRegion(AccessibilityLiveRegionAttribute(FAttributes['AccessibilityLiveRegionAttribute']).Value);
end;

function TPscViewBase.AccessibilityTraversalAfter(AfterId: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setAccessibilityTraversalAfter(AfterId);
end;

function TPscViewBase.AccessibilityTraversalAfter: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AccessibilityTraversalAfterAttribute')) then
    AccessibilityTraversalAfter(AccessibilityTraversalAfterAttribute(FAttributes['AccessibilityTraversalAfterAttribute']).Value);
end;

function TPscViewBase.AccessibilityTraversalBefore(BeforeId: Integer): IPscViewBase;
begin
  Result := Self;
  FView.setAccessibilityTraversalBefore(BeforeId);
end;

function TPscViewBase.AccessibilityTraversalBefore: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AccessibilityTraversalBeforeAttribute')) then
    AccessibilityTraversalBefore(AccessibilityTraversalBeforeAttribute(FAttributes['AccessibilityTraversalBeforeAttribute']).Value);
end;

function TPscViewBase.Activated(Activated: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setActivated(Activated);
end;

function TPscViewBase.Activated: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('ActivatedAttribute')) then
    Activated(ActivatedAttribute(FAttributes['ActivatedAttribute']).Value);
end;

function TPscViewBase.AllowClickWhenDisabled(ClickableWhenDisabled: Boolean): IPscViewBase;
begin
  Result := Self;
  FView.setAllowClickWhenDisabled(ClickableWhenDisabled);
end;

function TPscViewBase.AllowClickWhenDisabled: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AllowClickWhenDisabledAttribute')) then
    AllowClickWhenDisabled(AllowClickWhenDisabledAttribute(FAttributes['AllowClickWhenDisabledAttribute']).Value);
end;

function TPscViewBase.Alpha(Alpha: Single): IPscViewBase;
begin
  Result := Self;
  FView.setAlpha(Alpha);
end;

function TPscViewBase.Alpha: IPscViewBase;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AlphaAttribute')) then
    Alpha(AlphaAttribute(FAttributes['AlphaAttribute']).Value);
end;

{ TPscView }

function TPscView.BuildScreen: IPscView;
begin
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  Result := Self;
  FView := TJLinearLayout.JavaClass.init(FContext);
  ApplyAttributes;
end;

constructor TPscView.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscView', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscView.New(Attributes: TArray<TCustomAttribute>): IPscView;
begin
  Result :=  Self.Create(Attributes);
end;

function TPscView.OnClick(Proc: TProc<JView>): IPscView;
var
  EventListener: TPscViewClickListener;
begin
  Result := Self;
  EventListener := TPscViewClickListener.Create(FView);
  EventListener.Proc := Proc;
  FView.setOnClickListener(EventListener);
end;

function TPscView.OnLongClick(Proc: TProc<JView>): IPscView;
var
  EventListener: TPscLinearLayoutLongClickListener;
begin
  Result := Self;
  EventListener := TPscLinearLayoutLongClickListener.Create(FView);
  EventListener.Proc := Proc;
  FView.setOnLongClickListener(EventListener);
end;

function TPscView.OnSwipe(Proc: TProc<JView, TSwipeDirection, Single, Single>): IPscView;
var
  TouchListener: TPscViewTouchListener;
begin
  Result := Self;
  if Assigned(Proc) then
  begin
    TouchListener := TPscViewTouchListener.Create;
    TouchListener.Proc := Proc;
    FView.setOnTouchListener(TouchListener);
  end;
end;

function TPscView.Show: IPscView;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

{ TPscText }

function TPscText.AllCaps: IPscText;
begin
  Result := Self;
  if (FAttributes.ContainsKey('AllCapsAttribute')) then
    AllCaps(AllCapsAttribute(FAttributes['AllCapsAttribute']).Value);
end;

function TPscText.AllCaps(Value: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setAllCaps(Value);
end;

procedure TPscText.ApplyAttributes;
begin
  TPscUtils.Log('for TPscText', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Text;
    TextColor;
    TextSize;
    TextHintColor;
    Gravity;
    Justify;
    AutoLinkMask;
    CursorVisible;
    ElegantTextHeight;
    Ems;
    FallbackLineSpacing;
    FreezesText;
    Height;
    HighlightColor;
    Hint;
    HintTextColor;
    HorizontallyScrolling;
    IncludeFontPadding;
    InputExtras;
    InputType;
    LastBaselineToBottomHeight;
    LetterSpacing;
    LineBreakStyle;
    LineBreakWordStyle;
    LineHeight;
    LineSpacing;
    Lines;
    LinkTextColor;
    LinksClickable;
    MarqueeRepeatLimit;
    MaxEms;
    MaxHeight;
    MaxLines;
    MaxWidth;
    MinEms;
    MinHeight;
    MinLines;
    MinWidth;
    PaintFlags;
    SelectAllOnFocus;
    Selected;
    ShadowLayer;
    ShowSoftInputOnFocus;
    SingleLine;
    TextAppearance;
    TextIsSelectable;
    TextScaleX;
    Width;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscText.BuildScreen: IPscText;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  FView := TJTextView.JavaClass.init(FContext);
  ApplyAttributes;
end;

constructor TPscText.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscText', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

function TPscText.Gravity: IPscText;
begin
  Result := Self;
  if (FAttributes.ContainsKey('GravityAttribute')) then
    Gravity(GravityAttribute(FAttributes['GravityAttribute']).Value);
end;

function TPscText.Hyphenation(Value: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setHyphenationFrequency(Value);
end;

function TPscText.Justify: IPscText;
var
  Hyphen: THyphenStrg;
  TxtBreak: TBreakStrg;
begin
  Result := Self;
  if (FAttributes.ContainsKey('JustifyAttribute')) then
  begin
    if (JustifyAttribute(FAttributes['JustifyAttribute']).Justify = True) then
      Justify(TJLineBreaker.JavaClass.JUSTIFICATION_MODE_INTER_WORD)
    else
      Justify(TJLineBreaker.JavaClass.JUSTIFICATION_MODE_NONE);

    Hyphen := JustifyAttribute(FAttributes['JustifyAttribute']).HyphenStrategy;
    case Hyphen of
      THyphenStrg.Full: Hyphenation(TJLineBreaker.JavaClass.HYPHENATION_FREQUENCY_FULL);
      THyphenStrg.None: Hyphenation(TJLineBreaker.JavaClass.HYPHENATION_FREQUENCY_NONE);
      THyphenStrg.Normal: Hyphenation(TJLineBreaker.JavaClass.HYPHENATION_FREQUENCY_NORMAL);
    end;

    TxtBreak := JustifyAttribute(FAttributes['JustifyAttribute']).TextBreakStrategy;
    case TxtBreak of
      TBreakStrg.Balanced: TextBreak(TJLineBreaker.JavaClass.BREAK_STRATEGY_BALANCED);
      TBreakStrg.HighQuality: TextBreak(TJLineBreaker.JavaClass.BREAK_STRATEGY_HIGH_QUALITY);
      TBreakStrg.Simple: TextBreak(TJLineBreaker.JavaClass.BREAK_STRATEGY_SIMPLE);
    end;

  end;
end;

function TPscText.Justify(Value: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setJustificationMode(Value);
end;

function TPscText.Gravity(Value: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setGravity(Value);
end;

class function TPscText.New(Attributes: TArray<TCustomAttribute>): IPscText;
begin
  Result := Self.Create(Attributes);
end;

function TPscText.Show: IPscText;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscText.Text: IPscText;
begin
  Result := Self;
  if (FAttributes.ContainsKey('TextAttribute')) then
    Text(TextAttribute(FAttributes['TextAttribute']).Value);
end;

function TPscText.TextBreak(Value: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setBreakStrategy(Value);
end;

function TPscText.TextColor: IPscText;
begin
  Result := Self;
  if (FAttributes.ContainsKey('TextColorAttribute')) then
    TextColor(TextColorAttribute(FAttributes['TextColorAttribute']).Value);
end;

function TPscText.TextHintColor: IPscText;
begin
  Result := Self;
  if (FAttributes.ContainsKey('TextHintColorAttribute')) then
    TextHintColor(TextHintColorAttribute(FAttributes['TextHintColorAttribute']).Value);
end;

function TPscText.TextHintColor(HintColor: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setHintTextColor(HintColor);
end;

function TPscText.TextSize: IPscText;
begin
  Result := Self;
  if (FAttributes.ContainsKey('TextSizeAttribute')) then
    TextSize(TextSizeAttribute(FAttributes['TextSizeAttribute']).Value);
end;

function TPscText.TextSize(TxtSize: Single): IPscText;
begin
  Result := Self;
  JTextView(FView).setTextSize(TxtSize);
end;

function TPscText.TextColor(Value: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setTextColor(Value);
end;

function TPscText.Text(Value: String): IPscText;
begin
  Result := Self;
  JTextView(FView).setText(StrToJCharSequence(Value));
end;

function TPscText.AutoLinkMask(Mask: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setAutoLinkMask(Mask);
end;

function TPscText.AutoLinkMask: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('AutoLinkMaskAttribute') then
    AutoLinkMask(AutoLinkMaskAttribute(FAttributes['AutoLinkMaskAttribute']).Value);
end;

function TPscText.CursorVisible(Visible: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setCursorVisible(Visible);
end;

function TPscText.CursorVisible: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('CursorVisibleAttribute') then
    CursorVisible(CursorVisibleAttribute(FAttributes['CursorVisibleAttribute']).Value);
end;

function TPscText.ElegantTextHeight(Elegant: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setElegantTextHeight(Elegant);
end;

function TPscText.ElegantTextHeight: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('ElegantTextHeightAttribute') then
    ElegantTextHeight(ElegantTextHeightAttribute(FAttributes['ElegantTextHeightAttribute']).Value);
end;

function TPscText.Ems(Value: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setEms(Value);
end;

function TPscText.Ems: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('EmsAttribute') then
    Ems(EmsAttribute(FAttributes['EmsAttribute']).Value);
end;

function TPscText.FallbackLineSpacing(Enabled: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setFallbackLineSpacing(Enabled);
end;

function TPscText.FallbackLineSpacing: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('FallbackLineSpacingAttribute') then
    FallbackLineSpacing(FallbackLineSpacingAttribute(FAttributes['FallbackLineSpacingAttribute']).Value);
end;

function TPscText.FreezesText(Freezes: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setFreezesText(Freezes);
end;

function TPscText.FreezesText: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('FreezesTextAttribute') then
    FreezesText(FreezesTextAttribute(FAttributes['FreezesTextAttribute']).Value);
end;

function TPscText.Height(Pixels: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setHeight(Pixels);
end;

function TPscText.Height: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('HeightAttribute') then
    Height(HeightAttribute(FAttributes['HeightAttribute']).Value);
end;

function TPscText.HighlightColor(Color: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setHighlightColor(Color);
end;

function TPscText.HighlightColor: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('HighlightColorAttribute') then
    HighlightColor(HighlightColorAttribute(FAttributes['HighlightColorAttribute']).Value);
end;

function TPscText.Hint(Hint: String): IPscText;
begin
  Result := Self;
  JTextView(FView).setHint(StrToJCharSequence(Hint));
end;

function TPscText.Hint(ResId: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setHint(ResId);
end;

function TPscText.Hint: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('HintAttribute') then
    Hint(HintAttribute(FAttributes['HintAttribute']).Hint);
end;

function TPscText.HintTextColor(Color: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setHintTextColor(Color);
end;

function TPscText.HintTextColor: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('HintTextColorAttribute') then
    HintTextColor(HintTextColorAttribute(FAttributes['HintTextColorAttribute']).Value);
end;

function TPscText.HorizontallyScrolling(Whether: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setHorizontallyScrolling(Whether);
end;

function TPscText.HorizontallyScrolling: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('HorizontallyScrollingAttribute') then
    HorizontallyScrolling(HorizontallyScrollingAttribute(FAttributes['HorizontallyScrollingAttribute']).Value);
end;

function TPscText.IncludeFontPadding(IncludePad: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setIncludeFontPadding(IncludePad);
end;

function TPscText.IncludeFontPadding: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('IncludeFontPaddingAttribute') then
    IncludeFontPadding(IncludeFontPaddingAttribute(FAttributes['IncludeFontPaddingAttribute']).Value);
end;

function TPscText.InputExtras(XmlResId: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setInputExtras(XmlResId);
end;

function TPscText.InputExtras: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('InputExtrasAttribute') then
    InputExtras(InputExtrasAttribute(FAttributes['InputExtrasAttribute']).Value);
end;

function TPscText.InputType(Type_: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setInputType(Type_);
end;

function TPscText.InputType: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('InputTypeAttribute') then
    InputType(InputTypeAttribute(FAttributes['InputTypeAttribute']).Value);
end;

function TPscText.LastBaselineToBottomHeight(Height: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setLastBaselineToBottomHeight(Height);
end;

function TPscText.LastBaselineToBottomHeight: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LastBaselineToBottomHeightAttribute') then
    LastBaselineToBottomHeight(LastBaselineToBottomHeightAttribute(FAttributes['LastBaselineToBottomHeightAttribute']).Value);
end;

function TPscText.LetterSpacing(Spacing: Single): IPscText;
begin
  Result := Self;
  JTextView(FView).setLetterSpacing(Spacing);
end;

function TPscText.LetterSpacing: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LetterSpacingAttribute') then
    LetterSpacing(LetterSpacingAttribute(FAttributes['LetterSpacingAttribute']).Value);
end;

function TPscText.LineBreakStyle(Style: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setLineBreakStyle(Style);
end;

function TPscText.LineBreakStyle: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LineBreakStyleAttribute') then
    LineBreakStyle(LineBreakStyleAttribute(FAttributes['LineBreakStyleAttribute']).Value);
end;

function TPscText.LineBreakWordStyle(WordStyle: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setLineBreakWordStyle(WordStyle);
end;

function TPscText.LineBreakWordStyle: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LineBreakWordStyleAttribute') then
    LineBreakWordStyle(LineBreakWordStyleAttribute(FAttributes['LineBreakWordStyleAttribute']).Value);
end;

function TPscText.LineHeight(Height: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setLineHeight(Height);
end;

function TPscText.LineHeight: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LineHeightAttribute') then
    LineHeight(LineHeightAttribute(FAttributes['LineHeightAttribute']).Value);
end;

function TPscText.LineSpacing(Add: Single; Mult: Single): IPscText;
begin
  Result := Self;
  JTextView(FView).setLineSpacing(Add, Mult);
end;

function TPscText.LineSpacing: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LineSpacingAttribute') then
    with LineSpacingAttribute(FAttributes['LineSpacingAttribute']) do
      LineSpacing(_Add, Mult);
end;

function TPscText.Lines(Lines: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setLines(Lines);
end;

function TPscText.Lines: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LinesAttribute') then
    Lines(LinesAttribute(FAttributes['LinesAttribute']).Value);
end;

function TPscText.LinkTextColor(Color: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setLinkTextColor(Color);
end;

function TPscText.LinkTextColor: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LinkTextColorAttribute') then
    LinkTextColor(LinkTextColorAttribute(FAttributes['LinkTextColorAttribute']).Value);
end;

function TPscText.LinksClickable(Whether: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setLinksClickable(Whether);
end;

function TPscText.LinksClickable: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('LinksClickableAttribute') then
    LinksClickable(LinksClickableAttribute(FAttributes['LinksClickableAttribute']).Value);
end;

function TPscText.MarqueeRepeatLimit(MarqueeLimit: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMarqueeRepeatLimit(MarqueeLimit);
end;

function TPscText.MarqueeRepeatLimit: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MarqueeRepeatLimitAttribute') then
    MarqueeRepeatLimit(MarqueeRepeatLimitAttribute(FAttributes['MarqueeRepeatLimitAttribute']).Value);
end;

function TPscText.MaxEms(MaxEms: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMaxEms(MaxEms);
end;

function TPscText.MaxEms: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MaxEmsAttribute') then
    MaxEms(MaxEmsAttribute(FAttributes['MaxEmsAttribute']).Value);
end;

function TPscText.MaxHeight(MaxPixels: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMaxHeight(MaxPixels);
end;

function TPscText.MaxHeight: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MaxHeightAttribute') then
    MaxHeight(MaxHeightAttribute(FAttributes['MaxHeightAttribute']).Value);
end;

function TPscText.MaxLines(MaxLines: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMaxLines(MaxLines);
end;

function TPscText.MaxLines: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MaxLinesAttribute') then
    MaxLines(MaxLinesAttribute(FAttributes['MaxLinesAttribute']).Value);
end;

function TPscText.MaxWidth(MaxPixels: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMaxWidth(MaxPixels);
end;

function TPscText.MaxWidth: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MaxWidthAttribute') then
    MaxWidth(MaxWidthAttribute(FAttributes['MaxWidthAttribute']).Value);
end;

function TPscText.MinEms(MinEms: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMinEms(MinEms);
end;

function TPscText.MinEms: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MinEmsAttribute') then
    MinEms(MinEmsAttribute(FAttributes['MinEmsAttribute']).Value);
end;

function TPscText.MinHeight(MinPixels: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMinHeight(MinPixels);
end;

function TPscText.MinHeight: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MinHeightAttribute') then
    MinHeight(MinHeightAttribute(FAttributes['MinHeightAttribute']).Value);
end;

function TPscText.MinLines(MinLines: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMinLines(MinLines);
end;

function TPscText.MinLines: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MinLinesAttribute') then
    MinLines(MinLinesAttribute(FAttributes['MinLinesAttribute']).Value);
end;

function TPscText.MinWidth(MinPixels: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setMinWidth(MinPixels);
end;

function TPscText.MinWidth: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('MinWidthAttribute') then
    MinWidth(MinWidthAttribute(FAttributes['MinWidthAttribute']).Value);
end;

function TPscText.PaintFlags(Flags: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setPaintFlags(Flags);
end;

function TPscText.PaintFlags: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('PaintFlagsAttribute') then
    PaintFlags(PaintFlagsAttribute(FAttributes['PaintFlagsAttribute']).Value);
end;

function TPscText.SelectAllOnFocus(SelectAll: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setSelectAllOnFocus(SelectAll);
end;

function TPscText.SelectAllOnFocus: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('SelectAllOnFocusAttribute') then
    SelectAllOnFocus(SelectAllOnFocusAttribute(FAttributes['SelectAllOnFocusAttribute']).Value);
end;

function TPscText.Selected(Selected: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setSelected(Selected);
end;

function TPscText.Selected: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('SelectedAttribute') then
    Selected(SelectedAttribute(FAttributes['SelectedAttribute']).Value);
end;

function TPscText.ShadowLayer(Radius, DX, DY: Single; Color: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setShadowLayer(Radius, DX, DY, Color);
end;

function TPscText.ShadowLayer: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('ShadowLayerAttribute') then
    with ShadowLayerAttribute(FAttributes['ShadowLayerAttribute']) do
      ShadowLayer(Radius, DX, DY, Color);
end;

function TPscText.ShowSoftInputOnFocus(Show: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setShowSoftInputOnFocus(Show);
end;

function TPscText.ShowSoftInputOnFocus: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('ShowSoftInputOnFocusAttribute') then
    ShowSoftInputOnFocus(ShowSoftInputOnFocusAttribute(FAttributes['ShowSoftInputOnFocusAttribute']).Value);
end;

function TPscText.SingleLine: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('SingleLineAttribute') then
    SingleLine(SingleLineAttribute(FAttributes['SingleLineAttribute']).Value);
end;

function TPscText.SingleLine(Single: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setSingleLine(Single);
end;

function TPscText.Text(ResId: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setText(ResId);
end;

function TPscText.TextAppearance: IPscText;
begin
  if FAttributes.ContainsKey('TextAppearanceAttribute') then
    with TextAppearanceAttribute(FAttributes['TextAppearanceAttribute']) do
      TextAppearance(ResourceName, Location);
end;

function TPscText.TextAppearance(ResName, Location: String): IPscText;
var
  ResId: Integer;
begin
  Result := Self;
  ResId := TPscUtils.FindResourceId(ResName, Location);
  JTextView(FView).setTextAppearance(ResId);
end;

function TPscText.TextIsSelectable(Selectable: Boolean): IPscText;
begin
  Result := Self;
  JTextView(FView).setTextIsSelectable(Selectable);
end;

function TPscText.TextIsSelectable: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextIsSelectableAttribute') then
    TextIsSelectable(TextIsSelectableAttribute(FAttributes['TextIsSelectableAttribute']).Value);
end;

function TPscText.TextScaleX(Size: Single): IPscText;
begin
  Result := Self;
  JTextView(FView).setTextScaleX(Size);
end;

function TPscText.TextScaleX: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextScaleXAttribute') then
    TextScaleX(TextScaleXAttribute(FAttributes['TextScaleXAttribute']).Value);
end;

function TPscText.Width(Pixels: Integer): IPscText;
begin
  Result := Self;
  JTextView(FView).setWidth(Pixels);
end;

function TPscText.Width: IPscText;
begin
  Result := Self;
  if FAttributes.ContainsKey('WidthAttribute') then
    Width(WidthAttribute(FAttributes['WidthAttribute']).Value);
end;

{ TPscButton }

procedure TPscButton.ApplyAttributes;
begin
  TPscUtils.Log('for TPscButton', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
end;

function TPscButton.BuildScreen: IPscButton;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  FView := TJButton.JavaClass.init(FContext);
  ApplyAttributes;
end;

constructor TPscButton.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscButton', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscButton.New(Attributes: TArray<TCustomAttribute>): IPscButton;
begin
  Result := Self.Create(Attributes);
end;

function TPscButton.Show: IPscButton;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

{ TPscImage }

procedure TPscImage.ApplyAttributes;
begin
  TPscUtils.Log('for TPscImage', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    AdjustViewBounds;
    Baseline;
    BaselineAlignBottom;
    CropToPadding;
    ImageAlpha;
    ImageResource;
    ScaleType;
    ApplyLayoutChangeListener;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

procedure TPscImage.ApplyLayoutChangeListener;
var
  LayoutChangeListener: TPscLayoutChangeListener;
begin
  LayoutChangeListener := TPscLayoutChangeListener.Create(
    procedure(v: JView; left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom: Integer)
    var
      newWidth, newHeight: Integer;
      ratio: Single;
    begin
      newWidth := right - left;
      newHeight := bottom - top;
      if newHeight <> 0 then
      begin
        ratio := newWidth / newHeight;
        if ratio > 1.3 then
          ScaleType(TImageScaleType.CenterCrop)
        else
          ScaleType(TImageScaleType.FitCenter);
      end;
    end
  );
  JImageView(FView).addOnLayoutChangeListener(LayoutChangeListener);
end;

function TPscImage.BuildScreen: IPscImage;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  FView := TJImageView.JavaClass.init(FContext);
  ApplyAttributes;
end;

constructor TPscImage.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscImage', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscImage.New(Attributes: TArray<TCustomAttribute>): IPscImage;
begin
  Result := Self.Create(Attributes);
end;

function TPscImage.ScaleType(Value: TImageScaleType): IPscImage;
begin
  Result := Self;
  case Value of
    TImageScaleType.FitCenter: JImageView(FView).setScaleType(TJImageView_ScaleType.JavaClass.FIT_CENTER);
    TImageScaleType.CenterCrop: JImageView(FView).setScaleType(TJImageView_ScaleType.JavaClass.CENTER_CROP);
    TImageScaleType.CenterInside: JImageView(FView).setScaleType(TJImageView_ScaleType.JavaClass.CENTER_INSIDE);
  end;
end;

function TPscImage.ScaleType: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('ScaleTypeAttribute') then
    ScaleType(ScaleTypeAttribute(FAttributes['ScaleTypeAttribute']).Value);
end;

function TPscImage.Show: IPscImage;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscImage.AdjustViewBounds(Value: Boolean): IPscImage;
begin
  Result := Self;
  JImageView(FView).setAdjustViewBounds(Value);
end;

function TPscImage.AdjustViewBounds: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('AdjustViewBoundsAttribute') then
    AdjustViewBounds(AdjustViewBoundsAttribute(FAttributes['AdjustViewBoundsAttribute']).Value);
end;

function TPscImage.Baseline(Value: Integer): IPscImage;
begin
  Result := Self;
  JImageView(FView).setBaseline(Value);
end;

function TPscImage.Baseline: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('BaselineAttribute') then
    Baseline(BaselineAttribute(FAttributes['BaselineAttribute']).Value);
end;

function TPscImage.BaselineAlignBottom(Value: Boolean): IPscImage;
begin
  Result := Self;
  JImageView(FView).setBaselineAlignBottom(Value);
end;

function TPscImage.BaselineAlignBottom: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('BaselineAlignBottomAttribute') then
    BaselineAlignBottom(BaselineAlignBottomAttribute(FAttributes['BaselineAlignBottomAttribute']).Value);
end;

function TPscImage.CropToPadding(Value: Boolean): IPscImage;
begin
  Result := Self;
  JImageView(FView).setCropToPadding(Value);
end;

function TPscImage.CropToPadding: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('CropToPaddingAttribute') then
    CropToPadding(CropToPaddingAttribute(FAttributes['CropToPaddingAttribute']).Value);
end;

function TPscImage.ImageAlpha(Value: Integer): IPscImage;
begin
  Result := Self;
  JImageView(FView).setImageAlpha(Value);
end;

function TPscImage.ImageAlpha: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('ImageAlphaAttribute') then
    ImageAlpha(ImageAlphaAttribute(FAttributes['ImageAlphaAttribute']).Value);
end;

function TPscImage.ImageResource: IPscImage;
begin
  Result := Self;
  if FAttributes.ContainsKey('ImageResourceAttribute') then
    with ImageResourceAttribute(FAttributes['ImageResourceAttribute']) do
      ImageResource(ResourceName, Location);
end;

function TPscImage.ImageResource(ResName, Location: String): IPscImage;
var
  ResId: Integer;
begin
  Result := Self;
  ResId := TPscUtils.FindResourceId(ResName, Location);
  JImageView(FView).setImageResource(ResId);
end;
{ TPscEdit }

procedure TPscEdit.ApplyAttributes;
begin
  TPscUtils.Log('for TPscEdit', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Text;
    Selection;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscEdit.BuildScreen: IPscEdit;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  FView := TJEditText.JavaClass.init(FContext);
  ApplyAttributes;
end;

constructor TPscEdit.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscEdit', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscEdit.New(Attributes: TArray<TCustomAttribute>): IPscEdit;
begin
  Result := Self.Create(Attributes);
end;

function TPscEdit.Selection(StartIdx, StopIdx: Integer): IPscEdit;
begin
  Result := Self;
  JEditText(FView).setSelection(StartIdx, StopIdx);
end;

function TPscEdit.Selection: IPscEdit;
begin
  Result := Self;
  if FAttributes.ContainsKey('SelectionAttribute') then
    with SelectionAttribute(FAttributes['SelectionAttribute']) do
      Selection(Start, Stop);
end;

function TPscEdit.Show: IPscEdit;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscEdit.Text: IPscEdit;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextAttribute') then
    with TextAttribute(FAttributes['TextAttribute']) do
      Text(Value, BufferType);
end;

function TPscEdit.Text(Value: String; TxtBufferType: TTextBuffer): IPscEdit;
begin
  Result := Self;
  case TxtBufferType of
    TTextBuffer.Editable: JEditText(FView).setText(StrToJCharSequence(Value), TJTextView_BufferType.JavaClass.EDITABLE);  
    TTextBuffer.Normal: JEditText(FView).setText(StrToJCharSequence(Value), TJTextView_BufferType.JavaClass.NORMAL);  
    TTextBuffer.Spannable: JEditText(FView).setText(StrToJCharSequence(Value), TJTextView_BufferType.JavaClass.SPANNABLE);  
  end;
end;

{ TPscCompoundButton }

procedure TPscCompoundButton.ApplyAttributes;
begin
  TPscUtils.Log('for TPscCompoundButton', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Checked;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscCompoundButton.BuildScreen: IPscCompoundButton;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  FView := TJCompoundButton.JavaClass.init(TAndroidHelper.Context, nil);
  ApplyAttributes;
end;

function TPscCompoundButton.Checked: IPscCompoundButton;
begin
  Result := Self;
  if FAttributes.ContainsKey('CheckedAttribute') then
    Checked(CheckedAttribute(FAttributes['CheckedAttribute']).Value);
end;

function TPscCompoundButton.Checked(Value: Boolean): IPscCompoundButton;
begin
  Result := Self;
  JCompoundButton(FView).setChecked(Value);
end;

constructor TPscCompoundButton.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscCompoundButton', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscCompoundButton.New(Attributes: TArray<TCustomAttribute>): IPscCompoundButton;
begin
  Result := Self.Create(Attributes);
end;

function TPscCompoundButton.Show: IPscCompoundButton;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

{ TPscSwitch }

procedure TPscSwitch.ApplyAttributes;
begin
  TPscUtils.Log('for TPscSwitch', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Checked;
    ShowText;
    SplitTrack;
    SwitchMinWidth;
    SwitchPadding;
    TextOff;
    TextOn;
    ThumbTextPadding;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscSwitch.BuildScreen: IPscSwitch;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  FView := TJSwitch.JavaClass.init(TAndroidHelper.Context, nil);
  ApplyAttributes;
end;

constructor TPscSwitch.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscSwitch', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscSwitch.New(Attributes: TArray<TCustomAttribute>): IPscSwitch;
begin
  Result := Self.Create(Attributes);
end;

function TPscSwitch.Show: IPscSwitch;
begin
  Result := Self;
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(FView, FLayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscSwitch.ShowText(Value: Boolean): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setShowText(Value);
end;

function TPscSwitch.ShowText: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('ShowTextAttribute') then
    ShowText(ShowTextAttribute(FAttributes['ShowTextAttribute']).Value);
end;

function TPscSwitch.SplitTrack(Value: Boolean): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setSplitTrack(Value);
end;

function TPscSwitch.SplitTrack: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('SplitTrackAttribute') then
    SplitTrack(SplitTrackAttribute(FAttributes['SplitTrackAttribute']).Value);
end;

function TPscSwitch.SwitchMinWidth(Pixels: Integer): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setSwitchMinWidth(Pixels);
end;

function TPscSwitch.SwitchMinWidth: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('SwitchMinWidthAttribute') then
    SwitchMinWidth(SwitchMinWidthAttribute(FAttributes['SwitchMinWidthAttribute']).Value);
end;

function TPscSwitch.SwitchPadding(Pixels: Integer): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setSwitchPadding(Pixels);
end;

function TPscSwitch.SwitchPadding: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('SwitchPaddingAttribute') then
    SwitchPadding(SwitchPaddingAttribute(FAttributes['SwitchPaddingAttribute']).Value);
end;

function TPscSwitch.TextOff(Value: String): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setTextOff(StrToJCharSequence(Value));
end;

function TPscSwitch.TextOff: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextOffAttribute') then
    TextOff(TextOffAttribute(FAttributes['TextOffAttribute']).Value);
end;

function TPscSwitch.TextOn(Value: String): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setTextOn(StrToJCharSequence(Value));
end;

function TPscSwitch.TextOn: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('TextOnAttribute') then
    TextOn(TextOnAttribute(FAttributes['TextOnAttribute']).Value);
end;

function TPscSwitch.ThumbTextPadding(Pixels: Integer): IPscSwitch;
begin
  Result := Self;
  JSwitch(FView).setThumbTextPadding(Pixels);
end;

function TPscSwitch.ThumbTextPadding: IPscSwitch;
begin
  Result := Self;
  if FAttributes.ContainsKey('ThumbTextPaddingAttribute') then
    ThumbTextPadding(ThumbTextPaddingAttribute(FAttributes['ThumbTextPaddingAttribute']).Value);
end;

{ TPscPopupWindow }

constructor TPscPopupWindow.Create;
begin
  inherited Create;
  FPopupWindow := nil;
  FContentView := nil;
  FWidth := TJViewGroup_LayoutParams.JavaClass.WRAP_CONTENT;
  FHeight := TJViewGroup_LayoutParams.JavaClass.WRAP_CONTENT;
  FOffsetX := 0;
  FOffsetY := 0;
  FOnDismiss := nil;
  FDismissListener := nil;
end;

destructor TPscPopupWindow.Destroy;
begin
  // Don't dismiss - let the Java PopupWindow manage its own lifecycle
  // The popup stays visible until user taps outside or calls Dismiss explicitly
  FDismissListener := nil;
  inherited Destroy;
end;

class function TPscPopupWindow.New: IPscPopupWindow;
begin
  Result := TPscPopupWindow.Create;
end;

procedure TPscPopupWindow.EnsurePopupWindow;
begin
  if FPopupWindow = nil then
    FPopupWindow := TJPopupWindow.JavaClass.init;
end;

function TPscPopupWindow.Content(AView: JView): IPscPopupWindow;
var
  Parent: JViewGroup;
begin
  Result := Self;
  FContentView := AView;
  EnsurePopupWindow;

  // Remove from parent if already attached
  if AView.getParent <> nil then
  begin
    Parent := TJViewGroup.Wrap(AView.getParent);
    if Parent <> nil then
      Parent.removeView(AView);
  end;

  FPopupWindow.setContentView(AView);
end;

function TPscPopupWindow.Width(AValue: Integer): IPscPopupWindow;
begin
  Result := Self;
  FWidth := AValue;
  EnsurePopupWindow;
  FPopupWindow.setWidth(AValue);
end;

function TPscPopupWindow.Height(AValue: Integer): IPscPopupWindow;
begin
  Result := Self;
  FHeight := AValue;
  EnsurePopupWindow;
  FPopupWindow.setHeight(AValue);
end;

function TPscPopupWindow.Focusable(AValue: Boolean): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  FPopupWindow.setFocusable(AValue);
end;

function TPscPopupWindow.OutsideTouchable(AValue: Boolean): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  FPopupWindow.setOutsideTouchable(AValue);
end;

function TPscPopupWindow.ClippingEnabled(AValue: Boolean): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  FPopupWindow.setClippingEnabled(AValue);
end;

function TPscPopupWindow.Elevation(AValue: Single): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  FPopupWindow.setElevation(AValue);
end;

function TPscPopupWindow.BackgroundColor(AColor: Integer): IPscPopupWindow;
var
  Drawable: JColorDrawable;
begin
  Result := Self;
  EnsurePopupWindow;
  Drawable := TJColorDrawable.JavaClass.init(AColor);
  FPopupWindow.setBackgroundDrawable(Drawable);
end;

function TPscPopupWindow.AnimationStyle(AStyle: Integer): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  FPopupWindow.setAnimationStyle(AStyle);
end;

function TPscPopupWindow.Offset(AX, AY: Integer): IPscPopupWindow;
begin
  Result := Self;
  FOffsetX := AX;
  FOffsetY := AY;
end;

function TPscPopupWindow.OnDismiss(AProc: TProc): IPscPopupWindow;
begin
  Result := Self;
  FOnDismiss := AProc;
  EnsurePopupWindow;
  FDismissListener := TPscPopupWindowDismissListener.Create(AProc);
  FPopupWindow.setOnDismissListener(FDismissListener);
end;

function TPscPopupWindow.ShowAsDropDown(AAnchor: JView): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  if AAnchor <> nil then
  begin
    try
      if (FOffsetX <> 0) or (FOffsetY <> 0) then
        FPopupWindow.showAsDropDown(AAnchor, FOffsetX, FOffsetY)
      else
        FPopupWindow.showAsDropDown(AAnchor);
    except
      on E: Exception do
        TPscUtils.Log('Error showing popup: ' + E.Message, 'ShowAsDropDown', TLogger.Error, nil);
    end;
  end
  else
    TPscUtils.Log('Anchor view is nil', 'ShowAsDropDown', TLogger.Warning, nil);
end;

function TPscPopupWindow.ShowAsDropDown(AAnchor: JView; AXOff, AYOff, AGravity: Integer): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  if AAnchor <> nil then
  begin
    try
      FPopupWindow.showAsDropDown(AAnchor, AXOff, AYOff, AGravity);
    except
      on E: Exception do
        TPscUtils.Log('Error showing popup: ' + E.Message, 'ShowAsDropDown', TLogger.Error, nil);
    end;
  end
  else
    TPscUtils.Log('Anchor view is nil', 'ShowAsDropDown', TLogger.Warning, nil);
end;

function TPscPopupWindow.ShowAtLocation(AParent: JView; AGravity, AX, AY: Integer): IPscPopupWindow;
begin
  Result := Self;
  EnsurePopupWindow;
  if AParent <> nil then
  begin
    try
      FPopupWindow.showAtLocation(AParent, AGravity, AX, AY);
    except
      on E: Exception do
        TPscUtils.Log('Error showing popup at location: ' + E.Message, 'ShowAtLocation', TLogger.Error, nil);
    end;
  end
  else
    TPscUtils.Log('Parent view is nil', 'ShowAtLocation', TLogger.Warning, nil);
end;

function TPscPopupWindow.Update(AWidth, AHeight: Integer): IPscPopupWindow;
begin
  Result := Self;
  FWidth := AWidth;
  FHeight := AHeight;
  if FPopupWindow <> nil then
    FPopupWindow.update(AWidth, AHeight);
end;

function TPscPopupWindow.Update(AX, AY, AWidth, AHeight: Integer): IPscPopupWindow;
begin
  Result := Self;
  FWidth := AWidth;
  FHeight := AHeight;
  if FPopupWindow <> nil then
    FPopupWindow.update(AX, AY, AWidth, AHeight);
end;

function TPscPopupWindow.Dismiss: IPscPopupWindow;
begin
  Result := Self;
  if (FPopupWindow <> nil) and FPopupWindow.isShowing then
    FPopupWindow.dismiss;
end;

function TPscPopupWindow.IsShowing: Boolean;
begin
  if FPopupWindow <> nil then
    Result := FPopupWindow.isShowing
  else
    Result := False;
end;

function TPscPopupWindow.GetPopupWindow: JPopupWindow;
begin
  EnsurePopupWindow;
  Result := FPopupWindow;
end;

end.