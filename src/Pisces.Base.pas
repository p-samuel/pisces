unit Pisces.Base;

{$M+}

interface

uses
  System.Rtti,
  System.SysUtils,
  System.Generics.Collections,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Widget,
  Androidapi.JNI.App,
  Androidapi.JNI.Os,
  Pisces.Types,
  Pisces.Registry;

type

  TPisces = class(TInterfacedObject)
  private
    FView: IInterface;
    FViewId: Integer;
    FViewName: String;
    FViewGUID: String;
    FParent: TPisces;
    FOnClick: TProc<JView>;                                       // Views
    FOnLongClick: TProc<JView>;
    FOnBackPressed: TProc<JView>;                                 // Toolbars
    FOnTimeChange: TProc<JTimePicker, Integer, Integer>;          // Calendars, dates and time pickers
    FOnDateChange: TProc<JDatePicker, Integer, Integer, Integer>;
    FOnCalendarDateChange: TProc<JCalendarView, Integer, Integer, Integer>;
    FOnItemClick: TProc<JAdapterView, JView, Integer, Int64>;     // Adapters (list view)
    FOnItemLongClick: TProc<JAdapterView, JView, Integer, Int64>;
    FOnItemSelected: TProc<JAdapterView, JView, Integer, Int64>;
    FOnNothingSelected: TProc<JAdapterView>;
    FOnSwipe: TProc<JView, TSwipeDirection, Single, Single>;      // Gestures
    FChildren: TObjectDictionary<Integer, TPisces>;               // Dictionary to store child instances

    FViewLifecycleListener: TPscViewLifecycleListener;            // View's Life cycle events
    FWindowFocusListener: TPscWindowFocusChangeListener;
    FOnViewAttachedToWindow: TProc<JView>;
    FOnViewDetachedFromWindow: TProc<JView>;
    FOnWindowFocusChanged: TProc<Boolean>;

    FOnActivityCreate: TProc<JActivity, JBundle>;                // Activity lifecycle properties, for optional handlers
    FOnActivityStart: TProc<JActivity>;                          // you need to use direct assignments (See Lifecycle examples)
    FOnActivityResume: TProc<JActivity>;
    FOnActivityPause: TProc<JActivity>;
    FOnActivityStop: TProc<JActivity>;
    FOnActivityDestroy: TProc<JActivity>;
    FOnActivitySaveInstanceState: TProc<JActivity, JBundle>;
    FOnConfigurationChanged: TProc<JActivity>;

    procedure ReadAttributes;
    procedure ProcessFields(ParentClass: TObject);
    procedure ShowView;
    procedure BuildScreen;
    procedure AddAndroidChildView(ParentView: IInterface; View: IInterface; ClassInstance: TPisces);
    procedure AddChild(Child: TPisces);
    procedure RegisterView(const RegistrationInfo: TViewRegistrationInfo; AType: TRttiType);
    procedure CreateViewIdentification;
    procedure SetParent(const AParent: TPisces);
    procedure CheckAndAssignActivityLifecycleHandlers;
    function IsDescendantOfPisces(AType: TRttiType): Boolean;
    function GetAndroidView: JView;
    function GetParentView: JView;
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Show; virtual;
    procedure ShowAndHide; virtual;
    procedure Hide; virtual;
    procedure AfterCreate; virtual;

    // Screen lifecycle methods - called by ScreenManager during navigation
    procedure DoShow; virtual;   // Called when screen becomes visible (push target or pop back)
    procedure DoHide; virtual;   // Called when screen becomes hidden (push source or pop source)
    procedure DoCreate; virtual; // Called after screen is created and registered
    procedure DoDestroy; virtual; // Called before screen is destroyed

    // Static methods for activity lifecycle
    procedure SetLifecycles;
    procedure SetupViewLifecycle;
    procedure SetupWindowFocusListener;
    procedure SetupActivityLifecycle;

    // View's identification
    property AndroidParentView: JView read GetParentView;
    property AndroidView: JView read GetAndroidView;
    property Parent: TPisces read FParent;
    property Visible: Boolean read GetVisible write SetVisible;
    property ViewId: Integer read FViewId;
    property ViewName: String read FViewName;
    property ViewGUID: String read FViewGUID;

    // Basic event handlers
    property OnClick: TProc<JView> read FOnClick write FOnClick;
    property OnLongClick: TProc<JView> read FOnLongClick write FOnLongClick;
    property OnBackPressed: TProc<JView> read FOnBackPressed write FOnBackPressed;
    property OnTimeChange: TProc<JTimePicker, Integer, Integer> read FOnTimeChange write FOnTimeChange;
    property OnDateChange: TProc<JDatePicker, Integer, Integer, Integer> read FOnDateChange write FOnDateChange;
    property OnCalendarDateChange: TProc<JCalendarView, Integer, Integer, Integer> read FOnCalendarDateChange write FOnCalendarDateChange;
    property OnItemClick: TProc<JAdapterView, JView, Integer, Int64> read FOnItemClick write FOnItemClick;
    property OnItemLongClick: TProc<JAdapterView, JView, Integer, Int64> read FOnItemLongClick write FOnItemLongClick;
    property OnItemSelected: TProc<JAdapterView, JView, Integer, Int64> read FOnItemSelected write FOnItemSelected;
    property OnNothingSelected: TProc<JAdapterView> read FOnNothingSelected write FOnNothingSelected;
    property OnSwipe: TProc<JView, TSwipeDirection, Single, Single> read FOnSwipe write FOnSwipe;

    // Lifecycle properties
    property OnViewAttachedToWindow: TProc<JView> read FOnViewAttachedToWindow write FOnViewAttachedToWindow;
    property OnViewDetachedFromWindow: TProc<JView> read FOnViewDetachedFromWindow write FOnViewDetachedFromWindow;
    property OnWindowFocusChanged: TProc<Boolean> read FOnWindowFocusChanged write FOnWindowFocusChanged;
    property OnActivityCreate: TProc<JActivity, JBundle> read FOnActivityCreate write FOnActivityCreate;
    property OnActivityStart: TProc<JActivity> read FOnActivityStart write FOnActivityStart;
    property OnActivityResume: TProc<JActivity> read FOnActivityResume write FOnActivityResume;
    property OnActivityPause: TProc<JActivity> read FOnActivityPause write FOnActivityPause;
    property OnActivityStop: TProc<JActivity> read FOnActivityStop write FOnActivityStop;
    property OnActivityDestroy: TProc<JActivity> read FOnActivityDestroy write FOnActivityDestroy;
    property OnActivitySaveInstanceState: TProc<JActivity, JBundle> read FOnActivitySaveInstanceState write FOnActivitySaveInstanceState;
    property OnConfigurationChanged: TProc<JActivity> read FOnConfigurationChanged write FOnConfigurationChanged;
    class function GetLifecycleManager: TPscLifecycleManager;
  end;

implementation

uses
  System.DateUtils,
  System.Hash,
  System.TypInfo,
  Pisces.Utils,
  Pisces.Attributes,
  Pisces.ViewGroup,
  Pisces.View;

procedure TPisces.RegisterView(const RegistrationInfo: TViewRegistrationInfo;  AType: TRttiType);
var
  Id: Integer;
begin

  TPscUtils.Log(Format('Assigning view id %d for component name "%s" (class: %s, instance: %p)',
    [FViewId, FViewName, AType.Name, Pointer(Self)]), 'RegisterView', TLogger.Info, Self);

  Id := RegistrationInfo.ViewID;
  RegistrationInfo.View.setId(Id);
  TPscUtils.RegisterView(RegistrationInfo);

end;

procedure TPisces.ProcessFields(ParentClass: TObject);
var
  SubView: IInterface;
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RttiField: TRttiField;
  FieldValue: TValue;
  FieldInstance: TPisces;
  ClassAttributes, FieldAttributes: TArray<TCustomAttribute>;
  Attribute: TCustomAttribute;
  OnClickHandler, OnLongClickHandler, OnNavigationClickHandler: TProc<JView>;
  OnTimeChangeHandler: TProc<JTimePicker, Integer, Integer>;
  OnDateChangeHandler: TProc<JDatePicker, Integer, Integer, Integer>;
  OnCalendarDateChangeHandler: TProc<JCalendarView, Integer, Integer, Integer>;
  OnItemClickHandler: TProc<JAdapterView, JView, Integer, Int64>;
  OnItemLongClickHandler: TProc<JAdapterView, JView, Integer, Int64>;
  OnItemSelectedHandler: TProc<JAdapterView, JView, Integer, Int64>;
  OnNothingSelectedHandler: TProc<JAdapterView>;
  OnSwipeHandler: TProc<JView, TSwipeDirection, Single, Single>;
  RttiInstType: TRttiInstanceType;
  RttiMethod: TRttiMethod;
  InstanceObj: TObject;
  RegInfo: TViewRegistrationInfo;
begin
  TPscUtils.Log('', 'ProcessFields', TLogger.Info, Self);
  try
    RttiContext := TRttiContext.Create;
    try
      RttiType := RttiContext.GetType(ParentClass.ClassType);

      for RttiField in RttiType.GetFields do begin
        // Skip fields that are clearly framework/system fields
        if RttiField.Name.StartsWith('FRef') or
           RttiField.Name.StartsWith('FInterface') or
           RttiField.Name.StartsWith('FView') or
           RttiField.Name.StartsWith('FViewId') or
           RttiField.Name.StartsWith('FViewName') or
           RttiField.Name.StartsWith('FViewGUID') or
           RttiField.Name.StartsWith('FParent') or
           RttiField.Name.StartsWith('FChildren') or
           RttiField.Name.StartsWith('FOn') then // Skip event handlers
          Continue;

        // Additional check: skip if field name suggests it's a parent reference
        if RttiField.Name.ToLower.Contains('parent') then
          Continue;
          
        if IsDescendantOfPisces(RttiField.FieldType) then begin

          FieldValue := RttiField.GetValue(ParentClass);

          if FieldValue.IsObject and (FieldValue.AsObject <> nil) then begin
            FieldInstance := TPisces(FieldValue.AsObject);
            
            // Critical check: Skip if this field instance is the same as any of our ancestors
            // This prevents circular references
            if FieldInstance = ParentClass then begin
              TPscUtils.Log(Format('Skipping self-reference field %s in %s', [RttiField.Name, ParentClass.ClassName]), 'ProcessFields', TLogger.Info, Self);
              Continue;
            end;
            
            // Check if this field instance is already our parent (prevents circular parent-child relationships)
            if (ParentClass is TPisces) and (FieldInstance = TPisces(ParentClass).FParent) then begin
              TPscUtils.Log(Format('Skipping parent reference field %s in %s', [RttiField.Name, ParentClass.ClassName]), 'ProcessFields', TLogger.Info, Self);
              Continue;
            end;
            
          end else begin
            RttiInstType := TRttiInstanceType(RttiField.FieldType);
            RttiMethod:= RttiInstType.GetMethod('Create');
            InstanceObj := RttiMethod.Invoke(RttiInstType.MetaclassType, []).AsObject;
            FieldInstance := TPisces(InstanceObj);
            RttiField.SetValue(ParentClass, FieldInstance);
          end;

          TPscUtils.Log('Retrieving field event handlers for: ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
          // Retrieve event handlers if they exist
          OnClickHandler := FieldInstance.OnClick;
          OnLongClickHandler := FieldInstance.OnLongClick;
          OnTimeChangeHandler := FieldInstance.OnTimeChange;
          OnNavigationClickHandler := FieldInstance.OnBackPressed;
          OnDateChangeHandler := FieldInstance.OnDateChange;
          OnCalendarDateChangeHandler := FieldInstance.OnCalendarDateChange;
          OnItemClickHandler := FieldInstance.OnItemClick;
          OnItemLongClickHandler := FieldInstance.OnItemLongClick;
          OnItemSelectedHandler := FieldInstance.OnItemSelected;
          OnNothingSelectedHandler := FieldInstance.OnNothingSelected;
          OnSwipeHandler := FieldInstance.OnSwipe;

          TPscUtils.Log('Retrieving class and fields attributes for: ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
          // Process class-level and field-level attributes
          ClassAttributes := RttiField.FieldType.GetAttributes;
          FieldAttributes := RttiField.GetAttributes;

          TPscUtils.Log('Performing search through class and field attributes for: ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
          // Combine class and field attributes
          for Attribute in ClassAttributes + FieldAttributes do begin
            if Attribute is SwitchButtonAttribute then begin
              TPscUtils.Log('Creating sub child as IPscSwitch of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscSwitch(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ButtonAttribute then begin
              TPscUtils.Log('Creating sub child as IPscButton of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscButton(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is EditAttribute then begin
              TPscUtils.Log('Creating sub child as IPscEdit of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscEdit(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is TextViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscText of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscText(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ImageViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscImage of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscImage(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ListViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscListView of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscListView(FieldInstance.FView)
                .BuildScreen
                .OnItemClick(OnItemClickHandler)
                .OnItemLongClick(OnItemLongClickHandler)
                .OnItemSelected(OnItemSelectedHandler, OnNothingSelectedHandler)
                .GetView;
            end else if Attribute is CalendarAttribute then begin
              TPscUtils.Log('Creating sub child as IPscCalendar of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscCalendar(FieldInstance.FView)
                .BuildScreen
                .OnDateChangeListener(OnCalendarDateChangeHandler)
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is DatePickerAttribute then begin
              TPscUtils.Log('Creating sub child as IPscDatePicker of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscDatePicker(FieldInstance.FView)
                .BuildScreen
                .OnDateChangeListener(OnDateChangeHandler)
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ScrollViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscScrollView of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscScrollView(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is TimePickerAttribute then begin
              TPscUtils.Log('Creating sub child as IPscTimePicker of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscTimePicker(FieldInstance.FView)
                .BuildScreen
                .OnTimeChangeListener(OnTimeChangeHandler)
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is FrameLayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscFrameLayout of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscFrameLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is LinearLayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscLinearLayout of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscLinearLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is RelativelayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscRelativeLayout of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscRelativeLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is AbsoluteLayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscAbsoluteLayout of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscAbsoluteLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ToolBarAttribute then begin
              TPscUtils.Log('Creating sub child as IPscToolBar of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscToolBar(FieldInstance.FView)
                .BuildScreen
                .OnNavigationClick(OnNavigationClickHandler)
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ViewGroupAttribute then begin
              TPscUtils.Log('Creating sub child as IPscViewGroup of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscViewGroup(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end else if Attribute is ViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscView of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscView(FieldInstance.FView)
                .BuildScreen
                .OnClick(OnClickHandler)
                .OnLongClick(OnLongClickHandler)
                .GetView;
            end;
          end;

          IPscView(FieldInstance.FView).OnSwipe(OnSwipeHandler);

          // Add the Android view to the Android parent view
          AddAndroidChildView(FView, SubView, FieldInstance);

          // Add the Pisces instance to the list of children
          AddChild(FieldInstance);

          // Recursively set view lifecycle
          FieldInstance.SetLifecycles;

          // Recursively process fields of the class
          FieldInstance.ProcessFields(FieldInstance);

          // Register the view using IPscView regardless of the inheritance
          RegInfo.ViewName := FieldInstance.FViewName;  // Child's name, not parent's
          RegInfo.ViewGUID := FieldInstance.FViewGUID;  // Child's GUID, not parent's
          RegInfo.ViewID := FieldInstance.FViewId;      // Child's ID, not parent's
          RegInfo.View := IPscView(FieldInstance.FView).GetView;
          RegInfo.Instance := FieldInstance;  // Store reference to TPisces instance
          FieldInstance.RegisterView(RegInfo, RttiContext.GetType(FieldInstance.ClassType));

          // Calls after create for user defined settings
          FieldInstance.AfterCreate;

        end;
      end;
    finally
      RttiContext.Free;
    end;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ProcessFields', TLogger.Error, Self);
  end;
end;

procedure TPisces.AddChild(Child: TPisces);
var
  UniqueId: Integer;
begin
  if Assigned(Child) then
  begin
    UniqueId := Abs(THashBobJenkins.GetHashValue(Child.ClassName));
    FChildren.AddOrSetValue(UniqueId, Child);
    Child.SetParent(Self);
  end;
end;

procedure TPisces.AddAndroidChildView(ParentView: IInterface; View: IInterface; ClassInstance: TPisces);
var
  RttiContext: TRttiContext;
begin
  RttiContext := TRttiContext.Create;
  try
    if Supports(ParentView, IPscSwitch) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscSwitch ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscButton) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscButton ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscEdit) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscEdit ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscText) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscText ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscImage) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscImage ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscAdapterView) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscAdapterView ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscCalendar) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscCalendar ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscDatePicker) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscDatePicker ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscScrollView) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscScrollView ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscTimePicker) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscTimePicker ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscFrameLayout) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscFrameLayout ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscLinearLayout) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscLinearLayout ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscRelativeLayout) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscRelativeLayout ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscAbsoluteLayout) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscAbsoluteLayout ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscToolBar) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscToolBar ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscViewGroup) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscViewGroup ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscView) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscView ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IPscViewBase) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscViewBase ', 'AddChildView', TLogger.Info, Self)
    else if Supports(ParentView, IInterface) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IInterface ', 'AddChildView', TLogger.Info, Self);

    if Supports(ParentView, IPscViewGroup) then begin
      IPscViewGroup(ParentView).AddChildView(JView(View));
      TPscUtils.Log('Child view added successfully as IPscViewGroup', 'AddChildView', TLogger.Info, Self);
    end else begin
      TPscUtils.Log('Parent does not support adding children', 'AddChildView', TLogger.Warning, Self);
    end;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'AddChildView', TLogger.Error, Self);
  end;
  RttiContext.Free;
end;

procedure TPisces.AfterCreate;
begin
  TPscUtils.Log('', 'AfterCreate', TLogger.Info, Self);
end;

procedure TPisces.DoShow;
var
  Child: TPisces;
begin
  TPscUtils.Log('Screen becoming visible', 'DoShow', TLogger.Info, Self);
  // Propagate to children
  for Child in FChildren.Values do
    if Assigned(Child) then
      Child.DoShow;
end;

procedure TPisces.DoHide;
var
  Child: TPisces;
begin
  TPscUtils.Log('Screen becoming hidden', 'DoHide', TLogger.Info, Self);
  // Propagate to children
  for Child in FChildren.Values do
    if Assigned(Child) then
      Child.DoHide;
end;

procedure TPisces.DoCreate;
begin
  TPscUtils.Log('Screen created', 'DoCreate', TLogger.Info, Self);
end;

procedure TPisces.DoDestroy;
begin
  TPscUtils.Log('Screen being destroyed', 'DoDestroy', TLogger.Info, Self);
end;

procedure TPisces.BuildScreen;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  RegInfo: TViewRegistrationInfo;
begin
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  try
    // Check for the most specific type first, respecting hierarchy to avoid duplicate creates
    if Supports(FView, IPscSwitch) then begin
      IPscSwitch(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscButton) then begin
      IPscButton(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscEdit) then begin
      IPscEdit(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscText) then begin
      IPscText(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscImage) then begin
      IPscImage(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPsclistView) then begin
      IPsclistView(FView)
        .BuildScreen
        .OnItemClick(FOnItemClick)
        .OnItemLongClick(FOnItemLongClick)
        .OnItemSelected(FOnItemSelected, FOnNothingSelected);
    end else if Supports(FView, IPscCalendar) then begin
      IPscCalendar(FView)
        .BuildScreen
        .OnDateChangeListener(FOnCalendarDateChange)
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscDatePicker) then begin
      IPscDatePicker(FView)
        .BuildScreen
        .OnDateChangeListener(FOnDateChange)
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscScrollView) then begin
      IPscScrollView(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick)
    end else if Supports(FView, IPscTimePicker) then begin
      IPscTimePicker(FView)
        .BuildScreen
        .OnTimeChangeListener(FOnTimeChange)
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscFrameLayout) then begin
      IPscFrameLayout(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick)
    end else if Supports(FView, IPscLinearLayout) then begin
      IPscLinearLayout(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscRelativeLayout) then begin
      IPscRelativeLayout(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscAbsoluteLayout) then begin
      IPscAbsoluteLayout(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscToolBar) then begin
      IPscToolBar(FView)
        .BuildScreen
        .OnNavigationClick(FOnBackPressed)
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscViewGroup) then begin
      IPscViewGroup(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end else if Supports(FView, IPscView) then begin
      IPscView(FView)
        .BuildScreen
        .OnClick(FOnClick)
        .OnLongClick(FOnLongClick);
    end;

    // Swipe handler special case
    IPscView(FView).OnSwipe(FOnSwipe);

    // When the native view is fully built, we register it
    RttiContext := TRttiContext.Create;
    try
      RttiType := RttiContext.GetType(Self.ClassType);
      RegInfo.ViewName := FViewName;
      RegInfo.ViewGUID := FViewGUID;
      RegInfo.ViewID := FViewId;
      RegInfo.View := IPscView(FView).GetView;
      RegInfo.Instance := Self;  // Store reference to TPisces instance
      RegisterView(RegInfo, RttiType);
    finally
      RttiContext.Free;
    end;

  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'BuildScreen', TLogger.Error, Self);
  end;
end;

constructor TPisces.Create;
begin
  try
    TPscUtils.Log('', 'Create', TLogger.Info, Self);
    CreateViewIdentification;
    ReadAttributes;
    FChildren := TObjectDictionary<Integer, TPisces>.Create;

  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Create', TLogger.Fatal, Self);
  end;
end;

procedure TPisces.CreateViewIdentification;
var
  GUID: TGUID;
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Attribute: TCustomAttribute;
  AttributesList: TArray<TCustomAttribute>;
begin
  TPscUtils.Log('', 'CreateViewIdentification', TLogger.Info, Self);
  try
    CreateGUID(GUID);
    FViewGUID := GUIDToString(GUID);
    FViewId := Abs(THashBobJenkins.GetHashValue(FViewGUID));
    RttiContext := TRttiContext.Create;
    try
      RttiType := RttiContext.GetType(Self.ClassType);
      AttributesList := RttiType.GetAttributes;
      for Attribute in AttributesList do begin
        if Attribute is TPiscesViewAttribute then begin
          FViewName := TPiscesViewAttribute(Attribute).Value;
        end;
      end;
      TPscUtils.Log(Format('Name: %s, Id: %d, GUID: %s', [FViewName, FViewId, FViewGUID]),
        'CreateViewIdentification', TLogger.Info, Self);
    finally
      RttiContext.Free;
    end;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'CreateViewIdentification', TLogger.Fatal, Self);
  end;
end;

destructor TPisces.Destroy;
var
  Child: TPisces;
begin
  TPscUtils.Log('', 'Destroy', TLogger.Info, Self);

  // Clean up lifecycle listeners
  if Assigned(FViewLifecycleListener) then begin
    if Assigned(FView) and Supports(FView, IPscView) then
      IPscView(FView).GetView.removeOnAttachStateChangeListener(FViewLifecycleListener);
    FViewLifecycleListener.Free;
  end;

  if Assigned(FWindowFocusListener) then begin
    if Assigned(FView) and Supports(FView, IPscView) then begin
      var ViewTreeObserver := IPscView(FView).GetView.getViewTreeObserver;
      if Assigned(ViewTreeObserver) then
        ViewTreeObserver.removeOnWindowFocusChangeListener(FWindowFocusListener);
    end;
    FWindowFocusListener.Free;
  end;

  // Manually free children to control destruction order
  for Child in FChildren.Values do begin
    if Assigned(Child) then begin
      Child.SetParent(nil);
      Child.Free;
    end;
  end;

  FParent := nil;
  FChildren.Clear;
  FChildren.Free;
  inherited Destroy;
end;

function TPisces.GetAndroidView: JView;
begin
  Result := IPscView(FView).GetView;
  TPscUtils.Log('', 'GetAndroidView', TLogger.Info, Self);
end;

class function TPisces.GetLifecycleManager: TPscLifecycleManager;
begin
  Result := TPiscesApplication.GetLifecycleManager;
end;

function TPisces.GetParentView: JView;
begin
  Result := nil;
  if Assigned(FParent) then begin
    Result := FParent.AndroidView;
    TPscUtils.Log(Format('Retrieved parent view for %s', [Self.ClassName]), 'GetParentView', TLogger.Info, Self);
  end else begin
    TPscUtils.Log(Format('No parent available for %s', [Self.ClassName]), 'GetParentView', TLogger.Warning, Self);
  end;
end;

procedure TPisces.Hide;
begin
  GetAndroidView.setVisibility(TJView.JavaClass.GONE);
end;

function TPisces.GetVisible: Boolean;
begin
  Result := GetAndroidView.getVisibility = TJView.JavaClass.VISIBLE;
end;

procedure TPisces.SetVisible(const Value: Boolean);
begin
  if Value then
    GetAndroidView.setVisibility(TJView.JavaClass.VISIBLE)
  else
    GetAndroidView.setVisibility(TJView.JavaClass.GONE);
end;

function TPisces.IsDescendantOfPisces(AType: TRttiType): Boolean;
begin
  Result := False;
  while AType <> nil do begin
    if AType.Handle = TypeInfo(TPisces) then
      Exit(True);
    AType := AType.BaseType;
  end;
end;

procedure TPisces.ReadAttributes;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Attribute: TCustomAttribute;
  AttributesList: TArray<TCustomAttribute>;
begin
  TPscUtils.Log('', 'ReadAttributes', TLogger.Info, Self);
  try
    RttiContext := TRttiContext.Create;
    try
      try
        RttiType := RttiContext.GetType(Self.ClassType);
        AttributesList := RttiType.GetAttributes;

        for Attribute in AttributesList do begin

          if Attribute is ViewAttribute then
            FView := TPscView.New(AttributesList);

          if Attribute is TextViewAttribute then
            FView := TPscText.New(AttributesList);

          if Attribute is ButtonAttribute then
            FView := TPscButton.New(AttributesList);

          if Attribute is SwitchButtonAttribute then
            FView := TPscSwitch.New(AttributesList);

          if Attribute is EditAttribute then
            FView := TPscEdit.New(AttributesList);

          if Attribute is ImageViewAttribute then
            FView := TPscImage.New(AttributesList);

          if Attribute is ViewGroupAttribute then
            FView := TPscViewGroup.New(AttributesList);

          if Attribute is LinearLayoutAttribute then
            FView := TPscLinearLayout.New(AttributesList);

          if Attribute is RelativelayoutAttribute then
            FView := TPscRelativeLayout.New(AttributesList);

          if Attribute is ToolBarAttribute then
            FView := TPscToolBar.New(AttributesList);

          if Attribute is FrameLayoutAttribute then
            FView := TPscFrameLayout.New(AttributesList);

          if Attribute is ScrollViewAttribute then
            FView := TPscScrollView.New(AttributesList);

          if Attribute is AbsoluteLayoutAttribute then
            FView := TPscAbsoluteLayout.New(AttributesList);

          if Attribute is TimePickerAttribute then
            FView := TPscTimePicker.New(AttributesList);

          if Attribute is DatePickerAttribute then
            FView := TPscDatePicker.New(AttributesList);

          if Attribute is CalendarAttribute then
            FView := TPscCalendarView.New(AttributesList);

          if Attribute is ListViewAttribute then
            FView := TPscListView.New(AttributesList);

        end;
      except
        on E: Exception do
          TPscUtils.Log(E.Message, 'ReadAttributes', TLogger.Fatal, Self);
      end;
    finally
      RttiContext.Free;
    end;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ReadAttributes', TLogger.Fatal, Self);
  end;
end;

procedure TPisces.SetLifecycles;
begin

  SetupActivityLifecycle;

  // Setup view lifecycle after the view is built and before showing
  if Assigned(FOnViewAttachedToWindow) or Assigned(FOnViewDetachedFromWindow) then begin
    TPscUtils.Log('Setting up view lifecycle in Show method', 'Show', TLogger.Info, Self);
    SetupViewLifecycle;
  end;

  if Assigned(FOnWindowFocusChanged) then begin
    TPscUtils.Log('Setting up window focus listener in Show method', 'Show', TLogger.Info, Self);
    SetupWindowFocusListener;
  end;

  CheckAndAssignActivityLifecycleHandlers;
end;

procedure TPisces.SetParent(const AParent: TPisces);
begin
  FParent := AParent;
  if Assigned(FParent) then
    TPscUtils.Log(Format('Parent set for %s to %s', [Self.ClassName, AParent.ClassName]), 'SetParent', TLogger.Info, Self)
end;

procedure TPisces.SetupActivityLifecycle;
begin
  try
    TPscUtils.Log('Setting up activity lifecycle callbacks', 'SetupActivityLifecycle', TLogger.Info, nil);
    TPiscesApplication.GetLifecycleManager;
    TPscUtils.Log('Activity lifecycle setup completed', 'SetupActivityLifecycle', TLogger.Info, nil);
  except
    on E: Exception do
      TPscUtils.Log('Failed to setup activity lifecycle: ' + E.Message, 'SetupActivityLifecycle', TLogger.Error, nil);
  end;
end;

procedure TPisces.SetupViewLifecycle;
begin
  if not Assigned(FViewLifecycleListener) then
  begin
    try
      FViewLifecycleListener := TPscViewLifecycleListener.Create;
      FViewLifecycleListener.OnAttachedToWindow := FOnViewAttachedToWindow;
      FViewLifecycleListener.OnDetachedFromWindow := FOnViewDetachedFromWindow;
      
      if Assigned(FView) and Supports(FView, IPscView) then
      begin
        var AndroidView := IPscView(FView).GetView;
        if Assigned(AndroidView) then begin
          AndroidView.addOnAttachStateChangeListener(FViewLifecycleListener);
          TPscUtils.Log('View lifecycle listener attached successfully', 'SetupViewLifecycle', TLogger.Info, Self);
        end else begin
          TPscUtils.Log('Android view is nil, cannot attach lifecycle listener', 'SetupViewLifecycle', TLogger.Warning, Self);
        end;
      end else begin
        TPscUtils.Log('FView is not IPscView compatible', 'SetupViewLifecycle', TLogger.Warning, Self);
      end;
    except
      on E: Exception do
        TPscUtils.Log('Error setting up view lifecycle: ' + E.Message, 'SetupViewLifecycle', TLogger.Error, Self);
    end;
  end else begin
    TPscUtils.Log('View lifecycle listener already exists', 'SetupViewLifecycle', TLogger.Info, Self);
  end;
end;

procedure TPisces.SetupWindowFocusListener;
var
  ViewTreeObserver: JViewTreeObserver;
begin
  if not Assigned(FWindowFocusListener) then
  begin
    FWindowFocusListener := TPscWindowFocusChangeListener.Create;
    FWindowFocusListener._OnWindowFocusChanged := FOnWindowFocusChanged;
    if Assigned(FView) and Supports(FView, IPscView) then
    begin
      ViewTreeObserver := IPscView(FView).GetView.getViewTreeObserver;
      if Assigned(ViewTreeObserver) then
      begin
        ViewTreeObserver.addOnWindowFocusChangeListener(FWindowFocusListener);
        TPscUtils.Log('Window focus listener attached', 'SetupWindowFocusListener', TLogger.Info, Self);
      end;
    end;
  end;
end;

procedure TPisces.Show;
begin
  TPscUtils.Log('', 'Show', TLogger.Info, Self);
  try
    BuildScreen;
    SetLifecycles;
    ProcessFields(Self);
    ShowView;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'Show', TLogger.Error, Self);
  end;
end;

procedure TPisces.ShowAndHide;
begin
  Show;
  Hide;
end;

procedure TPisces.ShowView;
begin
  TPscUtils.Log('', 'ShowView', TLogger.Info, Self);
  try
    if Supports(FView, IPscView) then
      IPscView(FView).Show;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'ShowView', TLogger.Error, Self);
  end;
end;

procedure TPisces.CheckAndAssignActivityLifecycleHandlers;
var
  Manager: TPscLifecycleManager;
begin

  // Assign activity lifecycle handlers here ***
  try
    Manager := TPiscesApplication.GetLifecycleManager;
    if Assigned(Manager) and Assigned(Manager.ActivityLifecycleListener) then
    begin
      TPscUtils.Log('Checking for pending activity lifecycle handlers in BuildScreen', 'BuildScreen', TLogger.Info, Self);

      // Check if this instance has lifecycle handlers that need to be assigned
      if Assigned(FOnActivityCreate) then begin
        Manager.ActivityLifecycleListener.OnCreate := FOnActivityCreate;
        TPscUtils.Log('Assigned OnCreate handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnActivityStart) then begin
        Manager.ActivityLifecycleListener.OnStart := FOnActivityStart;
        TPscUtils.Log('Assigned OnStart handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnActivityResume) then begin
        Manager.ActivityLifecycleListener.OnResume := FOnActivityResume;
        TPscUtils.Log('Assigned OnResume handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnActivityPause) then begin
        Manager.ActivityLifecycleListener.OnPause := FOnActivityPause;
        TPscUtils.Log('Assigned OnPause handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnActivityStop) then begin
        Manager.ActivityLifecycleListener.OnStop := FOnActivityStop;
        TPscUtils.Log('Assigned OnStop handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnActivityDestroy) then begin
        Manager.ActivityLifecycleListener.OnDestroy := FOnActivityDestroy;
        TPscUtils.Log('Assigned OnDestroy handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnConfigurationChanged) then begin
        Manager.ActivityLifecycleListener.OnConfigurationChanged := OnConfigurationChanged;
        TPscUtils.Log('Assgined OnConfiguration handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;

      if Assigned(FOnActivitySaveInstanceState) then begin
        Manager.ActivityLifecycleListener.OnSaveInstanceState := FOnActivitySaveInstanceState;
        TPscUtils.Log('Assigned OnSaveInstanceState handler from property', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);
      end;
    end;
  except on E: Exception do
      TPscUtils.Log('Error checking activity lifecycle handlers: ' + E.Message, 'BuildScreen', TLogger.Warning, Self);
  end;

  TPscUtils.Log('Checking and assigning activity lifecycle handlers', 'CheckAndAssignActivityLifecycleHandlers', TLogger.Info, Self);

end;

end.
