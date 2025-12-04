unit Pisces.ViewGroup;

interface

uses
  Pisces.Types,
  System.SysUtils,
  Pisces.View,
  Pisces.EventListeners,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.JavaTypes;

type
  IPscViewGroup = interface(IPscView)
    ['{9D32B0E4-71EC-409B-B1AD-6910799C32BF}']
    function AddChildView(AView: JView): IPscViewGroup;
    function Show: IPscViewGroup;
  end;

  IPscAdapterView = interface(IPscViewGroup)
    ['{9F17FCB5-E0BD-4BB2-B856-E21E2F725E74}']
    function BuildScreen: IPscAdapterView;
    function Show: IPscAdapterView;
    function OnItemClick(Proc: TProc<JAdapterView, JView, Integer, Int64>): IPscAdapterView;
    function OnItemLongClick(Proc: TProc<JAdapterView, JView, Integer, Int64>): IPscAdapterView;
    function OnItemSelected(Proc: TProc<JAdapterView, JView, Integer, Int64>; NothingSelectedProc: TProc<JAdapterView>): IPscAdapterView;
    function AddView(Child: JView): IPscAdapterView; overload;
  end;

  IPscAbsListView = interface(IPscAdapterView)
    ['{EB2B7497-CE30-461E-BF1D-7A1AC08DCAAD}']
    function BuildScreen: IPscAbsListView;
    function Show: IPscAbsListView;
  end;

  IPscListView = interface(IPscAbsListView)
    ['{5D82E3E5-F66B-4382-BC2F-B0145F1B5A1E}']
    function BuildScreen: IPscListView;
    function Show: IPscListView;
  end;

  IPscAbsoluteLayout = interface(IPscViewGroup)
    ['{3B03EBF2-19B5-4DC0-8228-263A31E4EA8E}']
    function BuildScreen: IPscAbsoluteLayout;
    function Show: IPscAbsoluteLayout;
  end;

  IPscLinearLayout = interface(IPscViewGroup)
    ['{E11D61BB-170B-47CA-AA7E-8BAC60AE416F}']
    function BuildScreen: IPscLinearLayout;
    function Show: IPscLinearLayout;
  end;

  IPscRelativeLayout = interface(IPscViewGroup)
    ['{3D38942A-A33C-4F61-872F-FC10C8029B8E}']
    function BuildScreen: IPscRelativeLayout;
    function Show: IPscRelativeLayout;
  end;

  IPscToolBar = interface(IPscViewGroup)
    ['{E5BB49EA-8A9C-407F-BD8C-31D97E67BFFA}']
    function BuildScreen: IPscToolBar;
    function Show: IPscToolBar;
    function OnNavigationClick(Proc: TProc<JView>): IPscToolBar;
  end;

  IPscFrameLayout = interface(IPscViewGroup)
    ['{DDD12706-6604-4BC2-B8A7-1FD50546060F}']
    function BuildScreen: IPscFrameLayout;
    function Show: IPscFrameLayout;
  end;

  IPscScrollView = interface(IPscFrameLayout)
    ['{EABA8F7D-9E21-4A22-9603-194AA25F4EAC}']
    function BuildScreen: IPscScrollView;
    function Show: IPscScrollView;
  end;

  IPscTimePicker = interface(IPscFrameLayout)
    ['{3AD5D0D1-BE66-4A60-A140-99E5295CE8AD}']
    function BuildScreen: IPscTimePicker;
    function Show: IPscTimePicker;
    function OnTimeChangeListener(Proc: TProc<JTimePicker, Integer, Integer>): IPscTimePicker;
  end;

  IPscDatePicker = interface(IPscFrameLayout)
    ['{4B9C7B21-61B0-4A27-A951-CF855F8AB6A9}']
    function BuildScreen: IPscDatePicker;
    function Show: IPscDatePicker;
    function OnDateChangeListener(Proc: TProc<JDatePicker, Integer, Integer, Integer>): IPscDatePicker;
  end;

  IPscCalendar = interface(IPscFrameLayout)
    ['{2E9F6B85-4173-45CE-9CEA-BC13A89AFC77}']
    function BuildScreen: IPscCalendar;
    function Show: IPscCalendar;
    function OnDateChangeListener(Proc: TProc<JCalendarView, Integer, Integer, Integer>): IPscCalendar;
  end;

  TPscViewGroup = class(TPscView, IPscViewGroup)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscViewGroup;
    function BuildScreen: IPscViewGroup;
    function Show: IPscViewGroup;
    function AddStatesFromChildren(Value: Boolean): IPscViewGroup; overload;
    function AddStatesFromChildren: IPscViewGroup; overload;
    function AlwaysDrawnWithCacheEnabled(Value: Boolean): IPscViewGroup; overload;
    function AlwaysDrawnWithCacheEnabled: IPscViewGroup; overload;
    function AnimationCacheEnabled(Value: Boolean): IPscViewGroup; overload;
    function AnimationCacheEnabled: IPscViewGroup; overload;
    function ClipChildren(Value: Boolean): IPscViewGroup; overload;
    function ClipChildren: IPscViewGroup; overload;
    function ClipToPadding(Value: Boolean): IPscViewGroup; overload;
    function ClipToPadding: IPscViewGroup; overload;
    function DescendantFocusability(Value: Integer): IPscViewGroup; overload;
    function DescendantFocusability: IPscViewGroup; overload;
    function LayoutMode(Value: Integer): IPscViewGroup; overload;
    function LayoutMode: IPscViewGroup; overload;
    function MotionEventSplittingEnabled(Value: Boolean): IPscViewGroup; overload;
    function MotionEventSplittingEnabled: IPscViewGroup; overload;
    function TouchscreenBlocksFocus(Value: Boolean): IPscViewGroup; overload;
    function TouchscreenBlocksFocus: IPscViewGroup; overload;
    function TransitionGroup(Value: Boolean): IPscViewGroup; overload;
    function TransitionGroup: IPscViewGroup; overload;
    function AddChildView(Child: JView): IPscViewGroup;
  end;

  TPscAdapterView = class(TPscViewGroup, IPscAdapterView)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscAdapterView;
    function BuildScreen: IPscAdapterView;
    function Show: IPscAdapterView;
    function AddView(Child: JView): IPscAdapterView; overload;
    function AddView(Child: JView; Index: Integer): IPscAdapterView; overload;
    function AddView(Child: JView; Params: JViewGroup_LayoutParams): IPscAdapterView; overload;
    function AddView(Child: JView; Index: Integer; Params: JViewGroup_LayoutParams): IPscAdapterView; overload;
    function PerformItemClick(View: JView; Position: Integer; Id: Int64): IPscAdapterView;
    function RemoveAllViews: IPscAdapterView;
    function RemoveView(Child: JView): IPscAdapterView;
    function RemoveViewAt(Index: Integer): IPscAdapterView;
    function Adapter(Adapter: JAdapter): IPscAdapterView;
    function EmptyView(EmptyView: JView): IPscAdapterView;
    function Focusable(Value: Integer): IPscAdapterView; overload;
    function Focusable: IPscAdapterView; overload;
    function FocusableInTouchMode(Value: Boolean): IPscAdapterView; overload;
    function FocusableInTouchMode: IPscAdapterView; overload;
    function OnItemClick(Proc: TProc<JAdapterView, JView, Integer, Int64>): IPscAdapterView;
    function OnItemLongClick(Proc: TProc<JAdapterView, JView, Integer, Int64>): IPscAdapterView;
    function OnItemSelected(Proc: TProc<JAdapterView, JView, Integer, Int64>; NothingSelectedProc: TProc<JAdapterView>): IPscAdapterView;
    function Selection(Position: Integer): IPscAdapterView; overload;
    function Selection: IPscAdapterView; overload;
  end;

  TPscAbsListView = class(TPscAdapterView, IPscAbsListView)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscAbsListView;
    function BuildScreen: IPscAbsListView;
    function Show: IPscAbsListView;
  end;

  TPscListView = class(TPscAbsListView, IPscListView)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscListView;
    function BuildScreen: IPscListView;
    function Show: IPscListView;
    function ItemsCanFocus: IPscListView; overload;
    function ItemsCanFocus(Value: Boolean): IPscListView; overload;
  end;

  TPscAbsoluteLayout = class(TPscViewGroup, IPscAbsoluteLayout)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscAbsoluteLayout;
    function BuildScreen: IPscAbsoluteLayout;
    function Show: IPscAbsoluteLayout;
  end;

  TPscLinearLayout = class(TPscViewGroup, IPscLinearLayout)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscLinearLayout;
    function BuildScreen: IPscLinearLayout;
    function Show: IPscLinearLayout;
    function BaselineAligned(Value: Boolean): IPscLinearLayout; overload;
    function BaselineAligned: IPscLinearLayout; overload;
    function BaselineAlignedChildIndex(Value: Integer): IPscLinearLayout; overload;
    function BaselineAlignedChildIndex: IPscLinearLayout; overload;
    function DividerPadding(Value: Integer): IPscLinearLayout; overload;
    function DividerPadding: IPscLinearLayout; overload;
    function Gravity(Value: Integer): IPscLinearLayout; overload;
    function Gravity: IPscLinearLayout; overload;
    function HorizontalGravity(Value: Integer): IPscLinearLayout; overload;
    function HorizontalGravity: IPscLinearLayout; overload;
    function MeasureWithLargestChildEnabled(Value: Boolean): IPscLinearLayout; overload;
    function MeasureWithLargestChildEnabled: IPscLinearLayout; overload;
    function Orientation(Value: Integer): IPscLinearLayout; overload;
    function Orientation: IPscLinearLayout; overload;
    function ShowDividers(Value: Integer): IPscLinearLayout; overload;
    function ShowDividers: IPscLinearLayout; overload;
    function VerticalGravity(Value: Integer): IPscLinearLayout; overload;
    function VerticalGravity: IPscLinearLayout; overload;
    function WeightSum(Value: Single): IPscLinearLayout; overload;
    function WeightSum: IPscLinearLayout; overload;
  end;

  TPscRelativeLayout = class(TPscViewGroup, IPscRelativeLayout)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscRelativeLayout;
    function BuildScreen: IPscRelativeLayout;
    function Show: IPscRelativeLayout;
    function Gravity(Value: Integer): IPscRelativeLayout; overload;
    function Gravity: IPscRelativeLayout; overload;
    function HorizontalGravity(Value: Integer): IPscRelativeLayout; overload;
    function HorizontalGravity: IPscRelativeLayout; overload;
    function VerticalGravity(Value: Integer): IPscRelativeLayout; overload;
    function VerticalGravity: IPscRelativeLayout; overload;
  end;

  TPscToolBar = class(TPscViewGroup, IPscToolBar)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscToolBar;
    function BuildScreen: IPscToolBar;
    function Show: IPscToolBar;
    function CollapseContentDescription(description: JCharSequence): IPscToolBar; overload;
    function CollapseContentDescription: IPscToolBar; overload;
    function CollapseIcon(ResName, Location: String): IPscToolBar; overload;
    function CollapseIcon: IPscToolBar; overload;
    function ContentInsetEndWithActions(insetEndWithActions: Integer): IPscToolBar; overload;
    function ContentInsetEndWithActions: IPscToolBar; overload;
    function ContentInsetStartWithNavigation(insetStartWithNavigation: Integer): IPscToolBar; overload;
    function ContentInsetStartWithNavigation: IPscToolBar; overload;
    function ContentInsetsAbsolute(contentInsetLeft, contentInsetRight: Integer): IPscToolBar; overload;
    function ContentInsetsAbsolute: IPscToolBar; overload;
    function ContentInsetsRelative(contentInsetStart, contentInsetEnd: Integer): IPscToolBar;overload;
    function ContentInsetsRelative: IPscToolBar; overload;
    function Logo(ResName, Location: String): IPscToolBar; overload;
    function Logo: IPscToolBar; overload;
    function LogoDescription(description: JCharSequence): IPscToolBar; overload;
    function LogoDescription: IPscToolBar; overload;
    function NavigationContentDescription(description: JCharSequence): IPscToolBar; overload;
    function NavigationContentDescription: IPscToolBar; overload;
    function NavigationIcon(ResName, Location: String): IPscToolBar; overload;
    function NavigationIcon: IPscToolBar; overload;
    function Subtitle(subtitle: JCharSequence): IPscToolBar; overload;
    function Subtitle: IPscToolBar; overload;
    function SubtitleTextAppearance(resId: Integer): IPscToolBar; overload;
    function SubtitleTextAppearance: IPscToolBar; overload;
    function SubtitleTextColor(color: Integer): IPscToolBar; overload;
    function SubtitleTextColor: IPscToolBar; overload;
    function Title(title: JCharSequence): IPscToolBar; overload;
    function Title: IPscToolBar; overload;
    function TitleMargin(start, top, end_, bottom: Integer): IPscToolBar; overload;
    function TitleMargin: IPscToolBar; overload;
    function TitleTextColor(color: Integer): IPscToolBar;overload;
    function TitleTextColor: IPscToolBar; overload;
    function OnNavigationClick(Proc: TProc<JView>): IPscToolBar;
  end;

  TPscFrameLayout = class(TPscViewGroup, IPscFrameLayout)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscFrameLayout;
    function BuildScreen: IPscFrameLayout;
    function Show: IPscFrameLayout;
    function MeasureAllChildren: IPscFrameLayout; overload;
    function MeasureAllChildren(Value: Boolean): IPscFrameLayout; overload;
  end;

  TPscScrollView = class(TPscFrameLayout, IPscScrollView)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscScrollView;
    function BuildScreen: IPscScrollView;
    function Show: IPscScrollView;
    function BottomEdgeEffectColor: IPscScrollView; overload;
    function BottomEdgeEffectColor(Color: Integer): IPscScrollView; overload;
    function EdgeEffectColor: IPscScrollView; overload;
    function EdgeEffectColor(Color: Integer): IPscScrollView; overload;
    function FillViewport: IPscScrollView; overload;
    function FillViewport(Value: Boolean): IPscScrollView; overload;
    function SmoothScrollingEnabled: IPscScrollView; overload;
    function SmoothScrollingEnabled(Value: Boolean): IPscViewGroup; overload;
    function TopEdgeEffectColor: IPscScrollView; overload;
    function TopEdgeEffectColor(Color: Integer): IPscScrollView; overload;
  end;

  TPscTimePicker = class(TPscFrameLayout, IPscTimePicker)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscTimePicker;
    function BuildScreen: IPscTimePicker;
    function Show: IPscTimePicker;
    function CurrentHour(Value: Integer): IPscTimePicker; overload;
    function CurrentHour: IPscTimePicker; overload;
    function CurrentMinute(Value: Integer): IPscTimePicker; overload;
    function CurrentMinute: IPscTimePicker; overload;
    function Hour(Value: Integer): IPscTimePicker; overload;
    function Hour: IPscTimePicker; overload;
    function Is24HourView(Value: Boolean): IPscTimePicker; overload;
    function Is24HourView: IPscTimePicker; overload;
    function Minute(Value: Integer): IPscTimePicker; overload;
    function Minute: IPscTimePicker; overload;
    function OnTimeChangeListener(Proc: TProc<JTimePicker, Integer, Integer>): IPscTimePicker;
  end;

  TPscDatePicker = class(TPscFrameLayout, IPscDatePicker)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscDatePicker;
    function BuildScreen: IPscDatePicker;
    function Show: IPscDatePicker;
    function FirstDayOfWeek(Value: Integer): IPscDatePicker; overload;
    function FirstDayOfWeek: IPscDatePicker; overload;
    function MaxDate(Value: Int64): IPscDatePicker; overload;
    function MaxDate: IPscDatePicker; overload;
    function MinDate(Value: Int64): IPscDatePicker; overload;
    function MinDate: IPscDatePicker; overload;
    function SpinnersShown(Value: Boolean): IPscDatePicker; overload;
    function SpinnersShown: IPscDatePicker; overload;
    function CalendarDate(Year, Month, Day: Integer): IPscDatePicker; overload;
    function CalendarDate: IPscDatePicker; overload;
    function OnDateChangeListener(Proc: TProc<JDatePicker, Integer, Integer, Integer>): IPscDatePicker;
  end;

  TPscCalendarView = class(TPscFrameLayout, IPscCalendar)
  public
    procedure ApplyAttributes; override;
    constructor Create(Attributes: TArray<TCustomAttribute>);
    class function New(Attributes: TArray<TCustomAttribute>): IPscCalendar;
    function BuildScreen: IPscCalendar;
    function Show: IPscCalendar;
    function Date(Value: Int64): IPscCalendar; overload;
    function Date(Value: Int64; Animate, Center: Boolean): IPscCalendar; overload;
    function Date: IPscCalendar; overload;
    function DateTextAppearance(ResourceId: Integer): IPscCalendar; overload;
    function DateTextAppearance: IPscCalendar; overload;
    function FirstDayOfWeek(Value: Integer): IPscCalendar; overload;
    function FirstDayOfWeek: IPscCalendar; overload;
    function MaxDate(Value: Int64): IPscCalendar; overload;
    function MaxDate: IPscCalendar; overload;
    function MinDate(Value: Int64): IPscCalendar; overload;
    function MinDate: IPscCalendar; overload;
    function OnDateChangeListener(Proc: TProc<JCalendarView, Integer, Integer, Integer>): IPscCalendar;
  end;


implementation

uses
  Pisces.Utils,
  Pisces.Attributes,
  Androidapi.JNI.Widget,
  Androidapi.Helpers,
  Androidapi.JNI.App;

{ TPscViewGroup }

procedure TPscViewGroup.ApplyAttributes;
begin
  TPscUtils.Log('for TPscViewGroup', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    AddStatesFromChildren;
    AlwaysDrawnWithCacheEnabled;
    AnimationCacheEnabled;
    ClipChildren;
    ClipToPadding;
    DescendantFocusability;
    LayoutMode;
    MotionEventSplittingEnabled;
    TouchscreenBlocksFocus;
    TransitionGroup;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscViewGroup.BuildScreen: IPscViewGroup;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJViewGroup.JavaClass.init(Context);
  TPscUtils.Log('Here', 'BuildScreen', TLogger.Info, Self);
  ApplyAttributes;
end;

constructor TPscViewGroup.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscViewGroup', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscViewGroup.New(Attributes: TArray<TCustomAttribute>): IPscViewGroup;
begin
  Result := Self.Create(Attributes);
end;

function TPscViewGroup.Show: IPscViewGroup;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscViewGroup.AddStatesFromChildren(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setAddStatesFromChildren(Value);
end;

function TPscViewGroup.AddStatesFromChildren: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('AddStatesFromChildrenAttribute') then
    AddStatesFromChildren(AddStatesFromChildrenAttribute(Attributes['AddStatesFromChildrenAttribute']).Value);
end;

function TPscViewGroup.AddChildView(Child: JView): IPscViewGroup;
begin
  try
    TPscUtils.Log('', 'AddChildView', TLogger.Info, Self);
    Result := Self;
    JViewGroup(View).addView(Child);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'AddChildView', TLogger.Error, Self);
  end;
end;

function TPscViewGroup.AlwaysDrawnWithCacheEnabled(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setAlwaysDrawnWithCacheEnabled(Value);
end;

function TPscViewGroup.AlwaysDrawnWithCacheEnabled: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('AlwaysDrawnWithCacheEnabledAttribute') then
    AlwaysDrawnWithCacheEnabled(AlwaysDrawnWithCacheEnabledAttribute(Attributes['AlwaysDrawnWithCacheEnabledAttribute']).Value);
end;

function TPscViewGroup.AnimationCacheEnabled(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setAnimationCacheEnabled(Value);
end;

function TPscViewGroup.AnimationCacheEnabled: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('AnimationCacheEnabledAttribute') then
    AnimationCacheEnabled(AnimationCacheEnabledAttribute(Attributes['AnimationCacheEnabledAttribute']).Value);
end;

function TPscViewGroup.ClipChildren(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setClipChildren(Value);
end;

function TPscViewGroup.ClipChildren: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('ClipChildrenAttribute') then
    ClipChildren(ClipChildrenAttribute(Attributes['ClipChildrenAttribute']).Value);
end;

function TPscViewGroup.ClipToPadding(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setClipToPadding(Value);
end;

function TPscViewGroup.ClipToPadding: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('ClipToPaddingAttribute') then
    ClipToPadding(ClipToPaddingAttribute(Attributes['ClipToPaddingAttribute']).Value);
end;

function TPscViewGroup.DescendantFocusability(Value: Integer): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setDescendantFocusability(Value);
end;

function TPscViewGroup.DescendantFocusability: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('DescendantFocusabilityAttribute') then
    DescendantFocusability(DescendantFocusabilityAttribute(Attributes['DescendantFocusabilityAttribute']).Value);
end;

function TPscViewGroup.LayoutMode(Value: Integer): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setLayoutMode(Value);
end;

function TPscViewGroup.LayoutMode: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('LayoutModeAttribute') then
    LayoutMode(LayoutModeAttribute(Attributes['LayoutModeAttribute']).Value);
end;

function TPscViewGroup.MotionEventSplittingEnabled(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setMotionEventSplittingEnabled(Value);
end;

function TPscViewGroup.MotionEventSplittingEnabled: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('MotionEventSplittingEnabledAttribute') then
    MotionEventSplittingEnabled(MotionEventSplittingEnabledAttribute(Attributes['MotionEventSplittingEnabledAttribute']).Value);
end;

function TPscViewGroup.TouchscreenBlocksFocus(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setTouchscreenBlocksFocus(Value);
end;

function TPscViewGroup.TouchscreenBlocksFocus: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('TouchscreenBlocksFocusAttribute') then
    TouchscreenBlocksFocus(TouchscreenBlocksFocusAttribute(Attributes['TouchscreenBlocksFocusAttribute']).Value);
end;

function TPscViewGroup.TransitionGroup(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JViewGroup(View).setTransitionGroup(Value);
end;

function TPscViewGroup.TransitionGroup: IPscViewGroup;
begin
  Result := Self;
  if Attributes.ContainsKey('TransitionGroupAttribute') then
    TransitionGroup(TransitionGroupAttribute(Attributes['TransitionGroupAttribute']).Value);
end;

{ TPscAdapterView }

procedure TPscAdapterView.ApplyAttributes;
begin
  TPscUtils.Log('for TPscAdapterView', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Focusable;
    FocusableInTouchMode;
    Selection;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscAdapterView.BuildScreen: IPscAdapterView;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  TPscUtils.Log('Creating view', 'BuildScreen', TLogger.Info, Self);
  View := TJAdapterView.JavaClass.init(Context);
  TPscUtils.Log('View as created', 'BuildScreen', TLogger.Info, Self);
  ApplyAttributes;
end;

constructor TPscAdapterView.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscAdapterView', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscAdapterView.New(Attributes: TArray<TCustomAttribute>): IPscAdapterView;
begin
  Result := Self.Create(Attributes);
end;

function TPscAdapterView.Selection: IPscAdapterView;
var
  Position: Integer;
begin
  Result := Self;
  if Attributes.ContainsKey('SelectionAttribute') then
    for Position := SelectionAttribute(Attributes['SelectionAttribute']).Start to SelectionAttribute(Attributes['SelectionAttribute']).Stop do
      Selection(Position);
end;

function TPscAdapterView.Show: IPscAdapterView;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscAdapterView.AddView(Child: JView): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).addView(Child);
end;

function TPscAdapterView.AddView(Child: JView; Index: Integer): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).addView(Child, Index);
end;

function TPscAdapterView.AddView(Child: JView; Params: JViewGroup_LayoutParams): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).addView(Child, Params);
end;

function TPscAdapterView.AddView(Child: JView; Index: Integer; Params: JViewGroup_LayoutParams): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).addView(Child, Index, Params);
end;

function TPscAdapterView.PerformItemClick(View: JView; Position: Integer; Id: Int64): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(Self.View).performItemClick(View, Position, Id);
end;

function TPscAdapterView.RemoveAllViews: IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).removeAllViews;
end;

function TPscAdapterView.RemoveView(Child: JView): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).removeView(Child);
end;

function TPscAdapterView.RemoveViewAt(Index: Integer): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).removeViewAt(Index);
end;

function TPscAdapterView.Adapter(Adapter: JAdapter): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).setAdapter(Adapter);
end;

function TPscAdapterView.EmptyView(EmptyView: JView): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).setEmptyView(EmptyView);
end;

function TPscAdapterView.Focusable(Value: Integer): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).setFocusable(Value);
end;

function TPscAdapterView.Focusable: IPscAdapterView;
begin
  Result := Self;
  if Attributes.ContainsKey('FocusableAttribute') then
    Focusable(FocusableAttribute(Attributes['FocusableAttribute']).Value);
end;

function TPscAdapterView.FocusableInTouchMode: IPscAdapterView;
begin
  Result := Self;
  if Attributes.ContainsKey('FocusableInTouchModeAttribute') then
    FocusableInTouchMode(FocusableInTouchModeAttribute(Attributes['FocusableInTouchModeAttribute']).Mode);
end;

function TPscAdapterView.FocusableInTouchMode(Value: Boolean): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).setFocusableInTouchMode(Value);
end;

function TPscAdapterView.OnItemClick(Proc: TProc<JAdapterView, JView, Integer, Int64>): IPscAdapterView;
var
  Listener: TPscAdapterItemClickListener;
begin
  Result := Self;
  Listener := TPscAdapterItemClickListener.Create(Proc);
  JAdapterView(View).setOnItemClickListener(Listener);
end;

function TPscAdapterView.OnItemLongClick(Proc: TProc<JAdapterView, JView, Integer, Int64>): IPscAdapterView;
var
  Listener: TPscAdapterItemLongClickListener;
begin
  Result := Self;
  Listener := TPscAdapterItemLongClickListener.Create(Proc);
  JAdapterView(View).setOnItemLongClickListener(Listener);
end;

function TPscAdapterView.OnItemSelected(Proc: TProc<JAdapterView, JView, Integer, Int64>; NothingSelectedProc: TProc<JAdapterView>): IPscAdapterView;
var
  Listener: TPscAdapterItemSelectedListener;
begin
  Result := Self;
  Listener := TPscAdapterItemSelectedListener.Create(Proc, NothingSelectedProc);
  JAdapterView(View).setOnItemSelectedListener(Listener);
end;

function TPscAdapterView.Selection(Position: Integer): IPscAdapterView;
begin
  Result := Self;
  JAdapterView(View).setSelection(Position);
end;

{ TPscAbsoluteLayout }

procedure TPscAbsoluteLayout.ApplyAttributes;
begin
  TPscUtils.Log('for TPscAbsoluteLayout', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
end;

function TPscAbsoluteLayout.BuildScreen: IPscAbsoluteLayout;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJAbsoluteLayout.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscAbsoluteLayout.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscAbsoluteLayout', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscAbsoluteLayout.New(Attributes: TArray<TCustomAttribute>): IPscAbsoluteLayout;
begin
  Result := Self.Create(Attributes);
end;

function TPscAbsoluteLayout.Show: IPscAbsoluteLayout;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

{ TPscLinearLayout }

procedure TPscLinearLayout.ApplyAttributes;
begin
  TPscUtils.Log('for TPscLinearLayout', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    BaselineAligned;
    BaselineAlignedChildIndex;
    DividerPadding;
    Gravity;
    HorizontalGravity;
    MeasureWithLargestChildEnabled;
    Orientation;
    ShowDividers;
    VerticalGravity;
    WeightSum;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscLinearLayout.BuildScreen: IPscLinearLayout;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJLinearLayout.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscLinearLayout.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscLinearLayout', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscLinearLayout.New(Attributes: TArray<TCustomAttribute>): IPscLinearLayout;
begin
  Result := Self.Create(Attributes);
end;

function TPscLinearLayout.Show: IPscLinearLayout;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscLinearLayout.BaselineAligned(Value: Boolean): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setBaselineAligned(Value);
end;

function TPscLinearLayout.BaselineAligned: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('BaselineAlignedAttribute') then
    BaselineAligned(BaselineAlignedAttribute(Attributes['BaselineAlignedAttribute']).Value);
end;

function TPscLinearLayout.BaselineAlignedChildIndex(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setBaselineAlignedChildIndex(Value);
end;

function TPscLinearLayout.BaselineAlignedChildIndex: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('BaselineAlignedChildIndexAttribute') then
    BaselineAlignedChildIndex(BaselineAlignedChildIndexAttribute(Attributes['BaselineAlignedChildIndexAttribute']).Value);
end;

function TPscLinearLayout.DividerPadding(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setDividerPadding(Value);
end;

function TPscLinearLayout.DividerPadding: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('DividerPaddingAttribute') then
    DividerPadding(DividerPaddingAttribute(Attributes['DividerPaddingAttribute']).Value);
end;

function TPscLinearLayout.Gravity(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setGravity(Value);
end;

function TPscLinearLayout.Gravity: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('GravityAttribute') then
    Gravity(GravityAttribute(Attributes['GravityAttribute']).Value);
end;

function TPscLinearLayout.HorizontalGravity(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setHorizontalGravity(Value);
end;

function TPscLinearLayout.HorizontalGravity: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('HorizontalGravityAttribute') then
    HorizontalGravity(HorizontalGravityAttribute(Attributes['HorizontalGravityAttribute']).Value);
end;

function TPscLinearLayout.MeasureWithLargestChildEnabled(Value: Boolean): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setMeasureWithLargestChildEnabled(Value);
end;

function TPscLinearLayout.MeasureWithLargestChildEnabled: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('MeasureWithLargestChildEnabledAttribute') then
    MeasureWithLargestChildEnabled(MeasureWithLargestChildEnabledAttribute(Attributes['MeasureWithLargestChildEnabledAttribute']).Value);
end;

function TPscLinearLayout.Orientation(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setOrientation(Value);
end;

function TPscLinearLayout.Orientation: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('OrientationAttribute') then
    Orientation(OrientationAttribute(Attributes['OrientationAttribute']).Value);
end;

function TPscLinearLayout.ShowDividers(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setShowDividers(Value);
end;

function TPscLinearLayout.ShowDividers: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('ShowDividersAttribute') then
    ShowDividers(ShowDividersAttribute(Attributes['ShowDividersAttribute']).Value);
end;

function TPscLinearLayout.VerticalGravity(Value: Integer): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setVerticalGravity(Value);
end;

function TPscLinearLayout.VerticalGravity: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('VerticalGravityAttribute') then
    VerticalGravity(VerticalGravityAttribute(Attributes['VerticalGravityAttribute']).Value);
end;

function TPscLinearLayout.WeightSum(Value: Single): IPscLinearLayout;
begin
  Result := Self;
  JLinearLayout(View).setWeightSum(Value);
end;

function TPscLinearLayout.WeightSum: IPscLinearLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('WeightSumAttribute') then
    WeightSum(WeightSumAttribute(Attributes['WeightSumAttribute']).Value);
end;

{ TPscRelativeLayout }

procedure TPscRelativeLayout.ApplyAttributes;
begin
  TPscUtils.Log('for TPscRelativeLayout', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Gravity;
    HorizontalGravity;
    VerticalGravity;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscRelativeLayout.BuildScreen: IPscRelativeLayout;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJRelativeLayout.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscRelativeLayout.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscRelativeLayout', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscRelativeLayout.New(Attributes: TArray<TCustomAttribute>): IPscRelativeLayout;
begin
  Result := Self.Create(Attributes);
end;

function TPscRelativeLayout.Show: IPscRelativeLayout;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscRelativeLayout.Gravity(Value: Integer): IPscRelativeLayout;
begin
  Result := Self;
  JRelativeLayout(View).setGravity(Value);
end;

function TPscRelativeLayout.Gravity: IPscRelativeLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('GravityAttribute') then
    Gravity(GravityAttribute(Attributes['GravityAttribute']).Value);
end;

function TPscRelativeLayout.HorizontalGravity(Value: Integer): IPscRelativeLayout;
begin
  Result := Self;
  JRelativeLayout(View).setHorizontalGravity(Value);
end;

function TPscRelativeLayout.HorizontalGravity: IPscRelativeLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('HorizontalGravityAttribute') then
    HorizontalGravity(HorizontalGravityAttribute(Attributes['HorizontalGravityAttribute']).Value);
end;

function TPscRelativeLayout.VerticalGravity(Value: Integer): IPscRelativeLayout;
begin
  Result := Self;
  JRelativeLayout(View).setVerticalGravity(Value);
end;

function TPscRelativeLayout.VerticalGravity: IPscRelativeLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('VerticalGravityAttribute') then
    VerticalGravity(VerticalGravityAttribute(Attributes['VerticalGravityAttribute']).Value);
end;

{ TPscToolBar }

procedure TPscToolBar.ApplyAttributes;
begin
  TPscUtils.Log('for TPscToolBar', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    CollapseContentDescription;
    CollapseIcon;
    ContentInsetEndWithActions;
    ContentInsetStartWithNavigation;
    ContentInsetsAbsolute;
    ContentInsetsRelative;
    Logo;
    LogoDescription;
    NavigationContentDescription;
    NavigationIcon;
    Subtitle;
    SubtitleTextAppearance;
    SubtitleTextColor;
    Title;
    TitleMargin;
    TitleTextColor;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscToolBar.BuildScreen: IPscToolBar;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJToolbar.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscToolBar.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscToolBar', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscToolBar.New(
  Attributes: TArray<TCustomAttribute>): IPscToolBar;
begin
  Result := Self.Create(Attributes);
end;

function TPscToolBar.OnNavigationClick(Proc: TProc<JView>): IPscToolBar;
var
  EventListener: TPscViewClickListener;
begin
  Result := Self;
  EventListener := TPscViewClickListener.Create(View);
  EventListener.Proc := Proc;
  JToolbar(View).setNavigationOnClickListener(EventListener);
end;

function TPscToolBar.Show: IPscToolBar;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    if View = nil then
    begin
      TPscUtils.Log('Toolbar view is not initialized', 'Show', TLogger.Error, Self);
      Exit;
    end;
    TAndroidHelper.Activity.setActionBar(JToolbar(View));
    if TAndroidHelper.Activity.getActionBar <> nil then begin
      TAndroidHelper.Activity.addContentView(View, LayoutParams);
      TAndroidHelper.Activity.getActionBar.setDisplayShowHomeEnabled(True);
      TAndroidHelper.Activity.getActionBar.setDisplayHomeAsUpEnabled(True);
    end else begin
      TPscUtils.Log('Failed to set action bar', 'Show', TLogger.Error, Self);
    end;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscToolBar.CollapseContentDescription(description: JCharSequence): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setCollapseContentDescription(description);
end;

function TPscToolBar.CollapseContentDescription: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('CollapseContentDescriptionAttribute') then
    CollapseContentDescription(StrToJCharSequence(CollapseContentDescriptionAttribute(Attributes['CollapseContentDescriptionAttribute']).Value));
end;

function TPscToolBar.CollapseIcon(ResName, Location: String): IPscToolBar;
var
  ResId: Integer;
begin
  Result := Self;
  ResId := TPscUtils.FindResourceId(ResName, Location);
  JToolBar(View).setCollapseIcon(ResId);
end;

function TPscToolBar.CollapseIcon: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('CollapseIconAttribute') then
    CollapseIcon(CollapseIconAttribute(Attributes['CollapseIconAttribute']).ResourceName, CollapseIconAttribute(Attributes['CollapseIconAttribute']).Location);
end;

function TPscToolBar.ContentInsetEndWithActions(insetEndWithActions: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setContentInsetEndWithActions(insetEndWithActions);
end;

function TPscToolBar.ContentInsetEndWithActions: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('ContentInsetEndWithActionsAttribute') then
    ContentInsetEndWithActions(ContentInsetEndWithActionsAttribute(Attributes['ContentInsetEndWithActionsAttribute']).Value);
end;

function TPscToolBar.ContentInsetStartWithNavigation(insetStartWithNavigation: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setContentInsetStartWithNavigation(insetStartWithNavigation);
end;

function TPscToolBar.ContentInsetStartWithNavigation: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('ContentInsetStartWithNavigationAttribute') then
    ContentInsetStartWithNavigation(ContentInsetStartWithNavigationAttribute(Attributes['ContentInsetStartWithNavigationAttribute']).Value);
end;

function TPscToolBar.ContentInsetsAbsolute(contentInsetLeft, contentInsetRight: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setContentInsetsAbsolute(contentInsetLeft, contentInsetRight);
end;

function TPscToolBar.ContentInsetsAbsolute: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('ContentInsetsAbsoluteAttribute') then
    ContentInsetsAbsolute(ContentInsetsAbsoluteAttribute(Attributes['ContentInsetsAbsoluteAttribute']).Left, ContentInsetsAbsoluteAttribute(Attributes['ContentInsetsAbsoluteAttribute']).Right);
end;

function TPscToolBar.ContentInsetsRelative(contentInsetStart, contentInsetEnd: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setContentInsetsRelative(contentInsetStart, contentInsetEnd);
end;

function TPscToolBar.ContentInsetsRelative: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('ContentInsetsRelativeAttribute') then
    ContentInsetsRelative(ContentInsetsRelativeAttribute(Attributes['ContentInsetsRelativeAttribute']).Left, ContentInsetsRelativeAttribute(Attributes['ContentInsetsRelativeAttribute']).Right);
end;

function TPscToolBar.Logo(ResName, Location: String): IPscToolBar;
var
  ResId: Integer;
begin
  Result := Self;
  ResId := TPscUtils.FindResourceId(ResName, Location);
  JToolBar(View).setLogo(ResId);
end;

function TPscToolBar.Logo: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('LogoAttribute') then
    Logo(LogoAttribute(Attributes['LogoAttribute']).ResourceName, LogoAttribute(Attributes['LogoAttribute']).Location);
end;

function TPscToolBar.LogoDescription(description: JCharSequence): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setLogoDescription(description);
end;

function TPscToolBar.LogoDescription: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('LogoDescriptionAttribute') then
    LogoDescription(StrToJCharSequence(LogoDescriptionAttribute(Attributes['LogoDescriptionAttribute']).Value));
end;

function TPscToolBar.NavigationContentDescription(description: JCharSequence): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setNavigationContentDescription(description);
end;

function TPscToolBar.NavigationContentDescription: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('NavigationContentDescriptionAttribute') then
    NavigationContentDescription(StrToJCharSequence(NavigationContentDescriptionAttribute(Attributes['NavigationContentDescriptionAttribute']).Value));
end;

function TPscToolBar.NavigationIcon(ResName, Location: String): IPscToolBar;
var
  ResId: Integer;
begin
  Result := Self;
  ResId := TPscUtils.FindResourceId(ResName, Location);
  JToolBar(View).setNavigationIcon(ResId);
end;

function TPscToolBar.NavigationIcon: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('NavigationIconAttribute') then
    NavigationIcon(NavigationIconAttribute(Attributes['NavigationIconAttribute']).ResourceName,
    NavigationIconAttribute(Attributes['NavigationIconAttribute']).Location);
end;

function TPscToolBar.Subtitle(subtitle: JCharSequence): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setSubtitle(subtitle);
end;

function TPscToolBar.Subtitle: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('SubtitleAttribute') then
    Subtitle(StrToJCharSequence(SubtitleAttribute(Attributes['SubtitleAttribute']).Value));
end;

function TPscToolBar.SubtitleTextAppearance(resId: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setSubtitleTextAppearance(Context, resId);
end;

function TPscToolBar.SubtitleTextAppearance: IPscToolBar;
var
  ResId: Integer; ResName, ResLoc: String;
begin
  Result := Self;
  if Attributes.ContainsKey('SubtitleTextAppearanceAttribute') then begin
    ResName := SubtitleTextAppearanceAttribute(Attributes['SubtitleTextAppearanceAttribute']).ResourceName;
    ResLoc := SubtitleTextAppearanceAttribute(Attributes['SubtitleTextAppearanceAttribute']).Location;
    ResId := TPscUtils.FindResourceId(ResName, ResLoc);
    SubtitleTextAppearance(ResId);
  end;
end;

function TPscToolBar.SubtitleTextColor(color: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setSubtitleTextColor(color);
end;

function TPscToolBar.SubtitleTextColor: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('SubtitleTextColorAttribute') then
    SubtitleTextColor(SubtitleTextColorAttribute(Attributes['SubtitleTextColorAttribute']).Value);
end;

function TPscToolBar.Title(title: JCharSequence): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setTitle(title);
end;

function TPscToolBar.Title: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('TitleAttribute') then
    Title(StrToJCharSequence(TitleAttribute(Attributes['TitleAttribute']).Value));
end;

function TPscToolBar.TitleMargin(start, top, end_, bottom: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setTitleMargin(start, top, end_, bottom);
end;

function TPscToolBar.TitleMargin: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('TitleMarginAttribute') then
    TitleMargin(TitleMarginAttribute(Attributes['TitleMarginAttribute']).Left, TitleMarginAttribute(Attributes['TitleMarginAttribute']).Top, TitleMarginAttribute(Attributes['TitleMarginAttribute']).Right, TitleMarginAttribute(Attributes['TitleMarginAttribute']).Bottom);
end;

function TPscToolBar.TitleTextColor(color: Integer): IPscToolBar;
begin
  Result := Self;
  JToolBar(View).setTitleTextColor(color);
end;

function TPscToolBar.TitleTextColor: IPscToolBar;
begin
  Result := Self;
  if Attributes.ContainsKey('TitleTextColorAttribute') then
    TitleTextColor(TitleTextColorAttribute(Attributes['TitleTextColorAttribute']).Value);
end;
{ TPscFrameLayout }

procedure TPscFrameLayout.ApplyAttributes;
begin
  TPscUtils.Log('for TPscFrameLayout', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    MeasureAllChildren;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscFrameLayout.BuildScreen: IPscFrameLayout;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJFrameLayout.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscFrameLayout.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscFrameLayout', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

function TPscFrameLayout.MeasureAllChildren(Value: Boolean): IPscFrameLayout;
begin
  Result := Self;
  JFrameLayout(View).setMeasureAllChildren(Value);
end;

function TPscFrameLayout.MeasureAllChildren: IPscFrameLayout;
begin
  Result := Self;
  if Attributes.ContainsKey('MeasureAllChildrenAttribute') then
    MeasureAllChildren(MeasureAllChildrenAttribute(Attributes['TitleTextColorAttribute']).Value);
end;

class function TPscFrameLayout.New(Attributes: TArray<TCustomAttribute>): IPscFrameLayout;
begin
  Result := Self.Create(Attributes);
end;

function TPscFrameLayout.Show: IPscFrameLayout;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

{ TPscScrollView }

procedure TPscScrollView.ApplyAttributes;
begin
  TPscUtils.Log('for TPscScrollView', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    BottomEdgeEffectColor;
    EdgeEffectColor;
    FillViewport;
    SmoothScrollingEnabled;
    TopEdgeEffectColor;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscScrollView.BottomEdgeEffectColor(Color: Integer): IPscScrollView;
begin
  Result := Self;
  JScrollView(View).setBottomEdgeEffectColor(Color);
end;

function TPscScrollView.BottomEdgeEffectColor: IPscScrollView;
begin
  Result := Self;
  if Attributes.ContainsKey('BottomEdgeEffectColorAttribute') then
    BottomEdgeEffectColor(BottomEdgeEffectColorAttribute(Attributes['BottomEdgeEffectColorAttribute']).Value);
end;

function TPscScrollView.BuildScreen: IPscScrollView;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJScrollView.JavaClass.init(Context);
  ApplyAttributes;
end;

function TPscScrollView.EdgeEffectColor(Color: Integer): IPscScrollView;
begin
  Result := Self;
  JScrollView(View).setEdgeEffectColor(Color);
end;

function TPscScrollView.FillViewport(Value: Boolean): IPscScrollView;
begin
  Result := Self;
  JScrollView(View).setFillViewport(Value);
end;

function TPscScrollView.FillViewport: IPscScrollView;
begin
  Result := Self;
  if Attributes.ContainsKey('FillViewportAttribute') then
    FillViewport(FillViewportAttribute(Attributes['FillViewportAttribute']).Value);
end;

function TPscScrollView.EdgeEffectColor: IPscScrollView;
begin
  Result := Self;
  if Attributes.ContainsKey('EdgeEffectColorAttribute') then
    EdgeEffectColor(EdgeEffectColorAttribute(Attributes['EdgeEffectColorAttribute']).Value);
end;

class function TPscScrollView.New(Attributes: TArray<TCustomAttribute>): IPscScrollView;
begin
  Result := Self.Create(Attributes);
end;

function TPscScrollView.Show: IPscScrollView;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscScrollView.SmoothScrollingEnabled(Value: Boolean): IPscViewGroup;
begin
  Result := Self;
  JScrollView(View).setSmoothScrollingEnabled(Value);
end;

function TPscScrollView.TopEdgeEffectColor(Color: Integer): IPscScrollView;
begin
  Result := Self;
  JScrollView(View).setTopEdgeEffectColor(Color);
end;

function TPscScrollView.TopEdgeEffectColor: IPscScrollView;
begin
  Result := Self;
  if Attributes.ContainsKey('TopEdgeEffectColorAttribute') then
    TopEdgeEffectColor(TopEdgeEffectColorAttribute(Attributes['TopEdgeEffectColorAttribute']).Value);
end;

function TPscScrollView.SmoothScrollingEnabled: IPscScrollView;
begin
  Result := Self;
  if Attributes.ContainsKey('SmoothScrollingEnabledAttribute') then
    SmoothScrollingEnabled(SmoothScrollingEnabledAttribute(Attributes['SmoothScrollingEnabledAttribute']).Value);
end;

{ TPscTimePicker }

procedure TPscTimePicker.ApplyAttributes;
begin
  TPscUtils.Log('for TPscTimePicker', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    CurrentHour;
    CurrentMinute;
    Hour;
    Is24HourView;
    Minute;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscTimePicker.BuildScreen: IPscTimePicker;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJTimePicker.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscScrollView.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscScrollView', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscTimePicker.New(Attributes: TArray<TCustomAttribute>): IPscTimePicker;
begin
  Result := Self.Create(Attributes);
end;

function TPscTimePicker.OnTimeChangeListener(Proc: TProc<JTimePicker, Integer, Integer>): IPscTimePicker;
var
  EventListener: TPscTimeChangedListener;
begin
  Result := Self;
  EventListener := TPscTimeChangedListener.Create(Proc);
  JTimePicker(View).setOnTimeChangedListener(EventListener);
end;

function TPscTimePicker.Show: IPscTimePicker;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscTimePicker.CurrentHour(Value: Integer): IPscTimePicker;
begin
  Result := Self;
  JTimePicker(View).setCurrentHour(TJInteger.JavaClass.valueOf(Value));
end;

constructor TPscTimePicker.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscTimePicker', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

function TPscTimePicker.CurrentHour: IPscTimePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('CurrentHourAttribute') then
    CurrentHour(CurrentHourAttribute(Attributes['CurrentHourAttribute']).Value);
end;

function TPscTimePicker.CurrentMinute(Value: Integer): IPscTimePicker;
begin
  Result := Self;
  JTimePicker(View).setCurrentMinute(TJInteger.JavaClass.valueOf(Value));
end;

function TPscTimePicker.CurrentMinute: IPscTimePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('CurrentMinuteAttribute') then
    CurrentMinute(CurrentMinuteAttribute(Attributes['CurrentMinuteAttribute']).Value);
end;

function TPscTimePicker.Hour(Value: Integer): IPscTimePicker;
begin
  Result := Self;
  JTimePicker(View).setHour(Value);
end;

function TPscTimePicker.Hour: IPscTimePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('HourAttribute') then
    Hour(HourAttribute(Attributes['HourAttribute']).Value);
end;

function TPscTimePicker.Is24HourView(Value: Boolean): IPscTimePicker;
begin
  Result := Self;
  JTimePicker(View).setIs24HourView(TJBoolean.JavaClass.valueOf(Value));
end;

function TPscTimePicker.Is24HourView: IPscTimePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('Is24HourViewAttribute') then
    Is24HourView(Is24HourViewAttribute(Attributes['Is24HourViewAttribute']).Value);
end;

function TPscTimePicker.Minute(Value: Integer): IPscTimePicker;
begin
  Result := Self;
  JTimePicker(View).setMinute(Value);
end;

function TPscTimePicker.Minute: IPscTimePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('MinuteAttribute') then
    Minute(MinuteAttribute(Attributes['MinuteAttribute']).Value);
end;

{ TPscDatePicker }

procedure TPscDatePicker.ApplyAttributes;
begin
  TPscUtils.Log('for TPscDatePicker', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    FirstDayOfWeek;
    MaxDate;
    MinDate;
    SpinnersShown;
    CalendarDate;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscDatePicker.BuildScreen: IPscDatePicker;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJDatePicker.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscDatePicker.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscDatePicker', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscDatePicker.New(Attributes: TArray<TCustomAttribute>): IPscDatePicker;
begin
  Result := Self.Create(Attributes);
end;

function TPscDatePicker.OnDateChangeListener(Proc: TProc<JDatePicker, Integer, Integer, Integer>): IPscDatePicker;
var
  EventListener: TPscDateChangedListener;
begin
  Result := Self;
  EventListener := TPscDateChangedListener.Create(Proc);
  JDatePicker(View).setOnDateChangedListener(EventListener);
end;


function TPscDatePicker.Show: IPscDatePicker;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscDatePicker.FirstDayOfWeek(Value: Integer): IPscDatePicker;
begin
  Result := Self;
  JDatePicker(View).setFirstDayOfWeek(Value);
end;

function TPscDatePicker.FirstDayOfWeek: IPscDatePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('FirstDayOfWeekAttribute') then
    FirstDayOfWeek(FirstDayOfWeekAttribute(Attributes['FirstDayOfWeekAttribute']).Value);
end;

function TPscDatePicker.MaxDate(Value: Int64): IPscDatePicker;
begin
  Result := Self;
  JDatePicker(View).setMaxDate(Value);
end;

function TPscDatePicker.MaxDate: IPscDatePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('MaxDateAttribute') then
    MaxDate(MaxDateAttribute(Attributes['MaxDateAttribute']).Value);
end;

function TPscDatePicker.MinDate(Value: Int64): IPscDatePicker;
begin
  Result := Self;
  JDatePicker(View).setMinDate(Value);
end;

function TPscDatePicker.MinDate: IPscDatePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('MinDateAttribute') then
    MinDate(MinDateAttribute(Attributes['MinDateAttribute']).Value);
end;

function TPscDatePicker.SpinnersShown(Value: Boolean): IPscDatePicker;
begin
  Result := Self;
  JDatePicker(View).setSpinnersShown(Value);
end;

function TPscDatePicker.SpinnersShown: IPscDatePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('SpinnersShownAttribute') then
    SpinnersShown(SpinnersShownAttribute(Attributes['SpinnersShownAttribute']).Value);
end;

function TPscDatePicker.CalendarDate(Year, Month, Day: Integer): IPscDatePicker;
begin
  Result := Self;
  JDatePicker(View).updateDate(Year, Month, Day);
end;

function TPscDatePicker.CalendarDate: IPscDatePicker;
begin
  Result := Self;
  if Attributes.ContainsKey('CalendarDateAttribute') then
    with CalendarDateAttribute(Attributes['CalendarDateAttribute']) do
      CalendarDate(Year, Month, Day);
end;

{ TPscCalendarView }

procedure TPscCalendarView.ApplyAttributes;
begin
  TPscUtils.Log('for TPscDatePicker', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    Date;
    DateTextAppearance;
    FirstDayOfWeek;
    MaxDate;
    MinDate;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscCalendarView.BuildScreen: IPscCalendar;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJCalendarView.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscCalendarView.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscDatePicker', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscCalendarView.New(Attributes: TArray<TCustomAttribute>): IPscCalendar;
begin
  Result := Self.Create(Attributes);
end;

function TPscCalendarView.Show: IPscCalendar;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

function TPscCalendarView.Date(Value: Int64): IPscCalendar;
begin
  Result := Self;
  JCalendarView(View).setDate(Value);
end;

function TPscCalendarView.Date(Value: Int64; Animate, Center: Boolean): IPscCalendar;
begin
  Result := Self;
  JCalendarView(View).setDate(Value, Animate, Center);
end;

function TPscCalendarView.Date: IPscCalendar;
var
  Calendar: JCalendar;
  TimeInMillis: Int64;
begin
  Result := Self;
  if Attributes.ContainsKey('CalendarDateAttribute') then
    with CalendarDateAttribute(Attributes['CalendarDateAttribute']) do begin
      TimeInMillis := TPscUtils.DateToMillis(Year, Month, Day);
      Date(TimeInMillis);
    end;
end;

function TPscCalendarView.DateTextAppearance(ResourceId: Integer): IPscCalendar;
begin
  Result := Self;
  JCalendarView(View).setDateTextAppearance(ResourceId);
end;

function TPscCalendarView.DateTextAppearance: IPscCalendar;
var
  ResId: Integer;
begin
  Result := Self;
  if Attributes.ContainsKey('DateTextAppearanceAttribute') then begin
    with DateTextAppearanceAttribute(Attributes['DateTextAppearanceAttribute']) do begin
      ResId := TPscUtils.FindResourceId(ResourceName, Location);
      DateTextAppearance(ResId);
    end;
  end;
end;

function TPscCalendarView.FirstDayOfWeek(Value: Integer): IPscCalendar;
begin
  Result := Self;
  JCalendarView(View).setFirstDayOfWeek(Value);
end;

function TPscCalendarView.FirstDayOfWeek: IPscCalendar;
begin
  Result := Self;
  if Attributes.ContainsKey('FirstDayOfWeekAttribute') then
    FirstDayOfWeek(FirstDayOfWeekAttribute(Attributes['FirstDayOfWeekAttribute']).Value);
end;

function TPscCalendarView.MaxDate(Value: Int64): IPscCalendar;
begin
  Result := Self;
  JCalendarView(View).setMaxDate(Value);
end;

function TPscCalendarView.MaxDate: IPscCalendar;
begin
  Result := Self;
  if Attributes.ContainsKey('MaxDateAttribute') then
    MaxDate(MaxDateAttribute(Attributes['MaxDateAttribute']).Value);
end;

function TPscCalendarView.MinDate(Value: Int64): IPscCalendar;
begin
  Result := Self;
  JCalendarView(View).setMinDate(Value);
end;

function TPscCalendarView.MinDate: IPscCalendar;
begin
  Result := Self;
  if Attributes.ContainsKey('MinDateAttribute') then
    MinDate(MinDateAttribute(Attributes['MinDateAttribute']).Value);
end;

function TPscCalendarView.OnDateChangeListener(Proc: TProc<JCalendarView, Integer, Integer, Integer>): IPscCalendar;
var
  EventListener: TPscCalendarDateChangedListener;
begin
  Result := Self;
  EventListener := TPscCalendarDateChangedListener.Create(Proc);
  JCalendarView(View).setOnDateChangeListener(EventListener);
end;

{ TPscAbsListView }

procedure TPscAbsListView.ApplyAttributes;
begin
  TPscUtils.Log('for TPscAbsListView', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
end;

function TPscAbsListView.BuildScreen: IPscAbsListView;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJAbsListView.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscAbsListView.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscAbsListView', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

class function TPscAbsListView.New(Attributes: TArray<TCustomAttribute>): IPscAbsListView;
begin
  Result := Self.Create(Attributes);
end;

function TPscAbsListView.Show: IPscAbsListView;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

{ TPscListView }

procedure TPscListView.ApplyAttributes;
begin
  TPscUtils.Log('for TPscListView', 'ApplyAttributes', TLogger.Info, Self);
  inherited;
  try
    ItemsCanFocus;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ApplyAttributes', TLogger.Error, Self);
  end;
end;

function TPscListView.BuildScreen: IPscListView;
begin
  Result := Self;
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  View := TJListView.JavaClass.init(Context);
  ApplyAttributes;
end;

constructor TPscListView.Create(Attributes: TArray<TCustomAttribute>);
begin
  TPscUtils.Log('of TPscListView', 'Create', TLogger.Info, Self);
  inherited Create(Attributes);
end;

function TPscListView.ItemsCanFocus(Value: Boolean): IPscListView;
begin
  Result := Self;
  JListView(View).setItemsCanFocus(Value);
end;

function TPscListView.ItemsCanFocus: IPscListView;
begin
  Result := Self;
  if Attributes.ContainsKey('ItemsCanFocusAttribute') then
    ItemsCanFocus(ItemsCanFocusAttribute(Attributes['ItemsCanFocusAttribute']).Value);
end;

class function TPscListView.New(Attributes: TArray<TCustomAttribute>): IPscListView;
begin
  Result := Self.Create(Attributes);
end;

function TPscListView.Show: IPscListView;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    TAndroidHelper.Activity.addContentView(View, LayoutParams);
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

end.
