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
  Pisces.Registry,
  Pisces.Keyboard;

type

  TPisces = class(TInterfacedObject)
  private
    FView: IInterface;
    FViewId: Integer;
    FViewName: String;
    FViewGUID: String;
    FParent: TPisces;
    FChildren: TObjectDictionary<Integer, TPisces>;               // Dictionary to store children instances
    FViewLifecycleListener: TPscViewLifecycleListener;            // View's Lifecycle events
    FWindowFocusListener: TPscWindowFocusChangeListener;
    FKeyboardHelper: TPscKeyboardHelper;

    procedure ReadAttributes;
    procedure ProcessFields(ParentClass: TObject);
    procedure ShowView;
    procedure BuildScreen;
    procedure AddAndroidChildView(ParentView: IInterface; View: IInterface; ClassInstance: TPisces);
    procedure AddChild(Child: TPisces);
    procedure RegisterView(const RegistrationInfo: TViewRegistrationInfo; AType: TRttiType);
    procedure CreateViewIdentification;
    procedure SetParent(const AParent: TPisces);
    function IsDescendantOfPisces(AType: TRttiType): Boolean;
    function HasListViewItemAttribute: Boolean;
    function GetAndroidView: JView;
    function GetParentView: JView;
    function GetVisible: Boolean;
    procedure SetVisible(const Value: Boolean);
    procedure SetKeyboardPadding;
  public
    constructor Create; virtual;
    destructor Destroy; override;
    procedure Initialize; virtual;
    procedure AfterInitialize; virtual;
    procedure Show; virtual;
    procedure ShowAndHide; virtual;
    procedure Hide; virtual;
    procedure AfterShow; virtual;

    // Screen lifecycle methods - called by ScreenManager during navigation
    procedure DoShow; virtual;   // Called when screen becomes visible (push target or pop back)
    procedure DoHide; virtual;   // Called when screen becomes hidden (push source or pop source)
    procedure DoCreate; virtual; // Called after screen is created and registered
    procedure DoDestroy; virtual; // Called before screen is destroyed

    // ListView helper methods - delegates to IPscListView if view supports it
    procedure SetListItems(const Items: TArray<String>);
    function GetManagedItems: TArray<TObject>;

    // Static methods for activity lifecycle
    procedure SetLifecycles(ParentClass: TObject);
    procedure SetActivityLifecycleHandlers(ParentClass: TObject);
    procedure SetViewLifecycleHandlers(ParentClass: TObject);
    procedure SetWindowFocusListenerHandlers(ParentClass: TObject);
    procedure InitializeActivityLifecycle;

    // View's identification
    property AndroidParentView: JView read GetParentView;
    property AndroidView: JView read GetAndroidView;
    property Parent: TPisces read FParent;
    property Visible: Boolean read GetVisible write SetVisible;
    property ViewId: Integer read FViewId;
    property ViewName: String read FViewName;
    property ViewGUID: String read FViewGUID;

    // Basic event handler methods (virtual - override in descendants)
    procedure OnClickHandler(AView: JView); virtual;
    procedure OnLongClickHandler(AView: JView); virtual;
    procedure OnBackPressedHandler(AView: JView); virtual;
    procedure OnTimeChangeHandler(ATimePicker: JTimePicker; AHour, AMinute: Integer); virtual;
    procedure OnDateChangeHandler(ADatePicker: JDatePicker; AYear, AMonth, ADay: Integer); virtual;
    procedure OnCalendarDateChangeHandler(ACalendarView: JCalendarView; AYear, AMonth, ADay: Integer); virtual;
    procedure OnItemClickHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64); virtual;
    procedure OnItemLongClickHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64); virtual;
    procedure OnItemSelectedHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64); virtual;
    procedure OnNothingSelectedHandler(AParent: JAdapterView); virtual;
    procedure OnTouchHandler(AView: JView; ADirection: TSwipeDirection; AVelocityX, AVelocityY: Single); virtual;
    procedure OnTextChangedHandler(AText: String); virtual;
    procedure OnTextChangingHandler(AText: String; AStart, ABefore, ACount: Integer); virtual;
    procedure OnBeforeTextChangedHandler(AText: String; AStart, ACount, AAfter: Integer); virtual;
    procedure OnEditorActionHandler(v: JTextView; actionId: Integer; event: JKeyEvent); virtual;
    function OnKeyHandler(AView: JView; AKeyCode: Integer; AEvent: JKeyEvent): Boolean; virtual;

    // Lifecycle handler methods (virtual - override in descendants)
    procedure OnViewAttachedToWindowHandler(AView: JView); virtual;
    procedure OnViewDetachedFromWindowHandler(AView: JView); virtual;
    procedure OnWindowFocusChangedHandler(AHasFocus: Boolean); virtual;
    procedure OnActivityCreateHandler(AActivity: JActivity; ASavedInstanceState: JBundle); virtual;
    procedure OnActivityStartHandler(AActivity: JActivity); virtual;
    procedure OnActivityResumeHandler(AActivity: JActivity); virtual;
    procedure OnActivityPauseHandler(AActivity: JActivity); virtual;
    procedure OnActivityStopHandler(AActivity: JActivity); virtual;
    procedure OnActivityDestroyHandler(AActivity: JActivity); virtual;
    procedure OnActivitySaveInstanceStateHandler(AActivity: JActivity; AOutState: JBundle); virtual;
    procedure OnActivityConfigurationChangedHandler(AActivity: JActivity); virtual;
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

type
  // Record to capture all event handlers with proper value semantics.
  // Passing Instance as a parameter prevents closure from capturing loop variable by reference.
  // When an anonymous method is created within a loop, it captures the variable itself,
  // not a copy of its value at the time of creation. As a result, if the variable's value
  // changes before the anonymous method executes, the method will use the updated value,
  // potentially leading to incorrect behavior.
  THandlers = record
    // Basic event handlers
    OnClick: TProc<JView>;
    OnLongClick: TProc<JView>;
    OnBackPressed: TProc<JView>;
    OnTimeChange: TProc<JTimePicker, Integer, Integer>;
    OnDateChange: TProc<JDatePicker, Integer, Integer, Integer>;
    OnCalendarDateChange: TProc<JCalendarView, Integer, Integer, Integer>;
    OnItemClick: TProc<JAdapterView, JView, Integer, Int64>;
    OnItemLongClick: TProc<JAdapterView, JView, Integer, Int64>;
    OnItemSelected: TProc<JAdapterView, JView, Integer, Int64>;
    OnNothingSelected: TProc<JAdapterView>;
    OnTouch: TProc<JView, TSwipeDirection, Single, Single>;
    OnTextChanged: TProc<String>;
    OnTextChanging: TProc<String, Integer, Integer, Integer>;
    OnBeforeTextChanged: TProc<String, Integer, Integer, Integer>;
    OnEditorAction: TProc<JTextView, Integer, JKeyEvent>;
    OnKey: TFunc<JView, Integer, JKeyEvent, Boolean>;
    // Lifecycle handlers
    OnViewAttachedToWindow: TProc<JView>;
    OnViewDetachedFromWindow: TProc<JView>;
    OnWindowFocusChanged: TProc<Boolean>;
    OnActivityCreate: TProc<JActivity, JBundle>;
    OnActivityStart: TProc<JActivity>;
    OnActivityResume: TProc<JActivity>;
    OnActivityPause: TProc<JActivity>;
    OnActivityStop: TProc<JActivity>;
    OnActivityDestroy: TProc<JActivity>;
    OnActivitySaveInstanceState: TProc<JActivity, JBundle>;
    OnConfigurationChanged: TProc<JActivity>;
    class function From(Inst: TPisces): THandlers; static;
  end;

class function THandlers.From(Inst: TPisces): THandlers;
begin
  // Basic event handlers
  Result.OnClick := Inst.OnClickHandler;
  Result.OnLongClick := Inst.OnLongClickHandler;
  Result.OnBackPressed := Inst.OnBackPressedHandler;
  Result.OnTimeChange := Inst.OnTimeChangeHandler;
  Result.OnDateChange := Inst.OnDateChangeHandler;
  Result.OnCalendarDateChange := Inst.OnCalendarDateChangeHandler;
  Result.OnItemClick := Inst.OnItemClickHandler;
  Result.OnItemLongClick := Inst.OnItemLongClickHandler;
  Result.OnItemSelected := Inst.OnItemSelectedHandler;
  Result.OnNothingSelected := Inst.OnNothingSelectedHandler;
  Result.OnTouch := Inst.OnTouchHandler;
  Result.OnTextChanged := Inst.OnTextChangedHandler;
  Result.OnTextChanging := Inst.OnTextChangingHandler;
  Result.OnBeforeTextChanged := Inst.OnBeforeTextChangedHandler;
  Result.OnEditorAction := Inst.OnEditorActionHandler;
  Result.OnKey := Inst.OnKeyHandler;
  // Lifecycle handlers
  Result.OnViewAttachedToWindow := Inst.OnViewAttachedToWindowHandler;
  Result.OnViewDetachedFromWindow := Inst.OnViewDetachedFromWindowHandler;
  Result.OnWindowFocusChanged := Inst.OnWindowFocusChangedHandler;
  Result.OnActivityCreate := Inst.OnActivityCreateHandler;
  Result.OnActivityStart := Inst.OnActivityStartHandler;
  Result.OnActivityResume := Inst.OnActivityResumeHandler;
  Result.OnActivityPause := Inst.OnActivityPauseHandler;
  Result.OnActivityStop := Inst.OnActivityStopHandler;
  Result.OnActivityDestroy := Inst.OnActivityDestroyHandler;
  Result.OnActivitySaveInstanceState := Inst.OnActivitySaveInstanceStateHandler;
  Result.OnConfigurationChanged := Inst.OnActivityConfigurationChangedHandler;
end;

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
  H: THandlers;
  RttiInstType: TRttiInstanceType;
  RttiMethod: TRttiMethod;
  InstanceObj: TObject;
  RegInfo: TViewRegistrationInfo;
  IsChildListViewItem: Boolean;
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

          TPscUtils.Log(Format('Processing field: %s, Instance: %p, ClassName: %s',
            [RttiField.Name, Pointer(FieldInstance), FieldInstance.ClassName]),'ProcessFields', TLogger.Info, Self);

          // Check if this child has ListViewItem attribute - skip handlers if so
          IsChildListViewItem := FieldInstance.HasListViewItemAttribute;
          if IsChildListViewItem then
            TPscUtils.Log('Child ' + FieldInstance.ClassName + ' is a ListViewItem - skipping touch handlers', 'ProcessFields', TLogger.Info, Self);

          TPscUtils.Log('Retrieving field event handlers for: ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
          // Retrieve event handlers if they exist
          H := THandlers.From(FieldInstance);

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
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ButtonAttribute then begin
              TPscUtils.Log('Creating sub child as IPscButton of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscButton(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is EditAttribute then begin
              TPscUtils.Log('Creating sub child as IPscEdit of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscEdit(FieldInstance.FView)
                .BuildScreen
                .OnTextChanged(H.OnTextChanged)
                .OnBeforeTextChanged(H.OnBeforeTextChanged)
                .OnTextChanging(H.OnTextChanging)
                .OnEditorAction(H.OnEditorAction)
                .OnKey(H.OnKey)
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is TextViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscText of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscText(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ImageViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscImage of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscImage(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ListViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscListView of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscListView(FieldInstance.FView)
                .BuildScreen
                .OnItemClick(H.OnItemClick)
                .OnItemLongClick(H.OnItemLongClick)
                .OnItemSelected(H.OnItemSelected, H.OnNothingSelected)
                .GetView;
            end else if Attribute is CalendarAttribute then begin
              TPscUtils.Log('Creating sub child as IPscCalendar of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscCalendar(FieldInstance.FView)
                .BuildScreen
                .OnDateChangeListener(H.OnCalendarDateChange)
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is DatePickerAttribute then begin
              TPscUtils.Log('Creating sub child as IPscDatePicker of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscDatePicker(FieldInstance.FView)
                .BuildScreen
                .OnDateChangeListener(H.OnDateChange)
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ScrollViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscScrollView of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscScrollView(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is HorizontalScrollViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscHorizontalScrollView of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscHorizontalScrollView(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is TimePickerAttribute then begin
              TPscUtils.Log('Creating sub child as IPscTimePicker of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscTimePicker(FieldInstance.FView)
                .BuildScreen
                .OnTimeChangeListener(H.OnTimeChange)
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is FrameLayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscFrameLayout of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscFrameLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is LinearLayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscLinearLayout of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscLinearLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is RelativelayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscRelativeLayout of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscRelativeLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is AbsoluteLayoutAttribute then begin
              TPscUtils.Log('Creating sub child as IPscAbsoluteLayout of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscAbsoluteLayout(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ToolBarAttribute then begin
              TPscUtils.Log('Creating sub child as IPscToolBar of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscToolBar(FieldInstance.FView)
                .BuildScreen
                .OnNavigationClick(H.OnBackPressed)
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ViewGroupAttribute then begin
              TPscUtils.Log('Creating sub child as IPscViewGroup of type ' + FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscViewGroup(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end else if Attribute is ViewAttribute then begin
              TPscUtils.Log('Creating sub child as IPscView of type '+ FieldInstance.ClassName, 'ProcessFields', TLogger.Info, Self);
              SubView := IPscView(FieldInstance.FView)
                .BuildScreen
                .OnClick(H.OnClick)
                .OnLongClick(H.OnLongClick)
                .GetView;
            end;
          end;

          // Touch handler special case - skip for ListView items
          if not IsChildListViewItem then
            IPscView(FieldInstance.FView).OnTouch(H.OnTouch);

          // Add the Android view to the Android parent view
          AddAndroidChildView(FView, SubView, FieldInstance);

          // Add the Pisces instance to the list of children
          AddChild(FieldInstance);

          // Recursively set view lifecycle
          FieldInstance.SetLifecycles(FieldInstance);

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
          FieldInstance.AfterShow;

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
    else if Supports(ParentView, IPscHorizontalScrollView) then
      TPscUtils.Log(ClassInstance.ClassName + ' view is of type IPscHorizontalScrollView ', 'AddChildView', TLogger.Info, Self)
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

procedure TPisces.AfterShow;
begin
  TPscUtils.Log('', 'AfterShow', TLogger.Info, Self);
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
  IsListViewItem: Boolean;
begin
  TPscUtils.Log('', 'BuildScreen', TLogger.Info, Self);
  try
    // Check if this is a ListView item - if so, skip touch handlers
    IsListViewItem := HasListViewItemAttribute;
    if IsListViewItem then
      TPscUtils.Log('Detected ListViewItem attribute - skipping touch handlers', 'BuildScreen', TLogger.Info, Self);

    // Check for the most specific type first, respecting hierarchy to avoid duplicate creates
    if Supports(FView, IPscSwitch) then begin
      IPscSwitch(FView).BuildScreen;
      if not IsListViewItem then
        IPscSwitch(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscButton) then begin
      IPscButton(FView).BuildScreen;
      if not IsListViewItem then
        IPscButton(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscEdit) then begin
      IPscEdit(FView)
        .BuildScreen
        .OnTextChanged(OnTextChangedHandler)
        .OnTextChanging(OnTextChangingHandler)
        .OnBeforeTextChanged(OnBeforeTextChangedHandler)
        .OnEditorAction(OnEditorActionHandler)
        .OnKey(OnKeyHandler);
      if not IsListViewItem then
        IPscEdit(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscText) then begin
      IPscText(FView).BuildScreen;
      if not IsListViewItem then
        IPscText(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscImage) then begin
      IPscImage(FView).BuildScreen;
      if not IsListViewItem then
        IPscImage(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPsclistView) then begin
      IPsclistView(FView)
        .BuildScreen
        .OnItemClick(OnItemClickHandler)
        .OnItemLongClick(OnItemLongClickHandler)
        .OnItemSelected(OnItemSelectedHandler, OnNothingSelectedHandler);
    end else if Supports(FView, IPscCalendar) then begin
      IPscCalendar(FView)
        .BuildScreen
        .OnDateChangeListener(OnCalendarDateChangeHandler);
      if not IsListViewItem then
        IPscCalendar(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscDatePicker) then begin
      IPscDatePicker(FView)
        .BuildScreen
        .OnDateChangeListener(OnDateChangeHandler);
      if not IsListViewItem then
        IPscDatePicker(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscScrollView) then begin
      IPscScrollView(FView).BuildScreen;
      if not IsListViewItem then
        IPscScrollView(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscHorizontalScrollView) then begin
      IPscHorizontalScrollView(FView).BuildScreen;
      if not IsListViewItem then
        IPscHorizontalScrollView(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscTimePicker) then begin
      IPscTimePicker(FView)
        .BuildScreen
        .OnTimeChangeListener(OnTimeChangeHandler);
      if not IsListViewItem then
        IPscTimePicker(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscFrameLayout) then begin
      IPscFrameLayout(FView).BuildScreen;
      if not IsListViewItem then
        IPscFrameLayout(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscLinearLayout) then begin
      IPscLinearLayout(FView).BuildScreen;
      if not IsListViewItem then
        IPscLinearLayout(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscRelativeLayout) then begin
      IPscRelativeLayout(FView).BuildScreen;
      if not IsListViewItem then
        IPscRelativeLayout(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscAbsoluteLayout) then begin
      IPscAbsoluteLayout(FView).BuildScreen;
      if not IsListViewItem then
        IPscAbsoluteLayout(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscToolBar) then begin
      IPscToolBar(FView)
        .BuildScreen
        .OnNavigationClick(OnBackPressedHandler);
      if not IsListViewItem then
        IPscToolBar(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscViewGroup) then begin
      IPscViewGroup(FView).BuildScreen;
      if not IsListViewItem then
        IPscViewGroup(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end else if Supports(FView, IPscView) then begin
      IPscView(FView).BuildScreen;
      if not IsListViewItem then
        IPscView(FView)
          .OnClick(OnClickHandler)
          .OnLongClick(OnLongClickHandler);
    end;

    // Touch handler special case - skip for ListView items and AdapterViews
    if not IsListViewItem and not Supports(FView, IPscAdapterView) then
      IPscView(FView).OnTouch(OnTouchHandler);

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

  if Assigned(FKeyboardHelper) then
    FKeyboardHelper.Free;

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

function TPisces.HasListViewItemAttribute: Boolean;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Attribute: TCustomAttribute;
begin
  Result := False;
  RttiContext := TRttiContext.Create;
  try
    RttiType := RttiContext.GetType(Self.ClassType);
    for Attribute in RttiType.GetAttributes do begin
      if (Attribute is ListViewItemAttribute) and
         TPiscesBooleanAttribute(Attribute).Value then begin
        Result := True;
        Exit;
      end;
    end;
  finally
    RttiContext.Free;
  end;
end;

procedure TPisces.SetListItems(const Items: TArray<String>);
var
  ListView: IPscListView;
begin
  if Supports(FView, IPscListView, ListView) then
    ListView.SetListItems(Items)
  else
    TPscUtils.Log('SetListItems called on non-ListView view', 'SetListItems', TLogger.Error, Self);
end;

function TPisces.GetManagedItems: TArray<TObject>;
var
  ListView: IPscListView;
begin
  Result := nil;
  if Supports(FView, IPscListView, ListView) then
    Result := ListView.GetManagedItems;
end;

procedure TPisces.OnClickHandler(AView: JView);
begin
  // Override in descendants to handle click events
end;

procedure TPisces.OnLongClickHandler(AView: JView);
begin
  // Override in descendants to handle long click events
end;

procedure TPisces.OnBackPressedHandler(AView: JView);
begin
  // Override in descendants to handle back pressed events
end;

procedure TPisces.OnTimeChangeHandler(ATimePicker: JTimePicker; AHour, AMinute: Integer);
begin
  // Override in descendants to handle time change events
end;

procedure TPisces.OnDateChangeHandler(ADatePicker: JDatePicker; AYear, AMonth, ADay: Integer);
begin
  // Override in descendants to handle date change events
end;

procedure TPisces.OnCalendarDateChangeHandler(ACalendarView: JCalendarView; AYear, AMonth, ADay: Integer);
begin
  // Override in descendants to handle calendar date change events
end;

procedure TPisces.OnItemClickHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64);
begin
  // Override in descendants to handle item click events
end;

procedure TPisces.OnItemLongClickHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64);
begin
  // Override in descendants to handle item long click events
end;

procedure TPisces.OnItemSelectedHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64);
begin
  // Override in descendants to handle item selected events
end;

procedure TPisces.OnNothingSelectedHandler(AParent: JAdapterView);
begin
  // Override in descendants to handle nothing selected events
end;

procedure TPisces.OnTouchHandler(AView: JView; ADirection: TSwipeDirection; AVelocityX, AVelocityY: Single);
begin
  // Override in descendants to handle swipe events
end;

procedure TPisces.OnTextChangedHandler(AText: String);
begin
  // Override in descendants to handle text change events (after text changed)
end;

procedure TPisces.OnTextChangingHandler(AText: String; AStart, ABefore, ACount: Integer);
begin
  // Override in descendants to handle text changing events (while text is changing)
end;

procedure TPisces.OnBeforeTextChangedHandler(AText: String; AStart, ACount, AAfter: Integer);
begin
  // Override in descendants to handle before text change events
end;

procedure TPisces.OnEditorActionHandler(v: JTextView; actionId: Integer; event: JKeyEvent);
begin
  // Hides keyboard by default.
  TPscUtils.HideKeyboard(v);
  // Override in descendants to handle editor action events
end;

function TPisces.OnKeyHandler(AView: JView; AKeyCode: Integer; AEvent: JKeyEvent): Boolean;
begin
  // Override in descendants to handle key events (return True to consume)
  Result := False;
end;

procedure TPisces.OnViewAttachedToWindowHandler(AView: JView);
begin
  // Override in descendants to handle view attached to window events
end;

procedure TPisces.OnViewDetachedFromWindowHandler(AView: JView);
begin
  // Override in descendants to handle view detached from window events
end;

procedure TPisces.OnWindowFocusChangedHandler(AHasFocus: Boolean);
begin
  if (not AHasFocus) and Assigned(FKeyboardHelper) then
    FKeyboardHelper.ResetPadding;
end;

procedure TPisces.OnActivityCreateHandler(AActivity: JActivity; ASavedInstanceState: JBundle);
begin
  // Override in descendants to handle activity create events
end;

procedure TPisces.OnActivityStartHandler(AActivity: JActivity);
begin
  // Override in descendants to handle activity start events
end;

procedure TPisces.OnActivityResumeHandler(AActivity: JActivity);
begin
  // Override in descendants to handle activity resume events
end;

procedure TPisces.OnActivityPauseHandler(AActivity: JActivity);
begin
  if Assigned(FKeyboardHelper) then
    FKeyboardHelper.ResetPadding;
end;

procedure TPisces.OnActivityStopHandler(AActivity: JActivity);
begin
  if Assigned(FKeyboardHelper) then
    FKeyboardHelper.ResetPadding;
end;

procedure TPisces.OnActivityDestroyHandler(AActivity: JActivity);
begin
  // Override in descendants to handle activity destroy events
end;

procedure TPisces.OnActivitySaveInstanceStateHandler(AActivity: JActivity; AOutState: JBundle);
begin
  // Override in descendants to handle activity save instance state events
end;

procedure TPisces.OnActivityConfigurationChangedHandler(AActivity: JActivity);
begin
  // Override in descendants to handle configuration changed events
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

          if Attribute is HorizontalScrollViewAttribute then
            FView := TPscHorizontalScrollView.New(AttributesList);

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

procedure TPisces.SetLifecycles(ParentClass: TObject);
begin

  // Setup view lifecycle - always setup since we can't detect if virtual methods are overridden
  TPscUtils.Log('Setting up view lifecycle in Show method', 'Show', TLogger.Info, Self);
  SetViewLifecycleHandlers(Self);

  TPscUtils.Log('Setting up window focus listener in Show method', 'Show', TLogger.Info, Self);
  SetWindowFocusListenerHandlers(Self);

end;

procedure TPisces.SetParent(const AParent: TPisces);
begin
  FParent := AParent;
  if Assigned(FParent) then
    TPscUtils.Log(Format('Parent set for %s to %s', [Self.ClassName, AParent.ClassName]), 'SetParent', TLogger.Info, Self)
end;

procedure TPisces.Initialize;
begin
  BuildScreen;
  SetLifecycles(Self);
  InitializeActivityLifecycle;
  SetActivityLifecycleHandlers(Self);
  ProcessFields(Self);
  SetKeyboardPadding;
  AfterInitialize;
end;

procedure TPisces.AfterInitialize;
begin
  // Override in descendants to perform setup after Initialize completes
end;

procedure TPisces.InitializeActivityLifecycle;
begin
  try
    TPscUtils.Log('Initializing up activity lifecycle callbacks', 'InitializeActivityLifecycle', TLogger.Info, nil);
    TPiscesApplication.GetLifecycleManager;
    TPscUtils.Log('Activity lifecycle initialization completed', 'InitializeActivityLifecycle', TLogger.Info, nil);
  except
    on E: Exception do
      TPscUtils.Log('Failed to setup activity lifecycle: ' + E.Message, 'InitializeActivityLifecycle', TLogger.Error, nil);
  end;
end;

procedure TPisces.SetViewLifecycleHandlers(ParentClass: TObject);
var
  Instance: TPisces;
  H: THandlers;
begin
  if not Assigned(FViewLifecycleListener) then begin
    try
      H := THandlers.From(TPisces(ParentClass));
      Instance := TPisces(ParentClass);  // Capture Self for anonymous methods
      FViewLifecycleListener := TPscViewLifecycleListener.Create;

      // Wrap virtual methods and properties
      FViewLifecycleListener.OnAttachedToWindow := H.OnViewAttachedToWindow;
      FViewLifecycleListener.OnDetachedFromWindow := H.OnViewDetachedFromWindow;

      if Assigned(FView) and Supports(FView, IPscView) then begin
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

procedure TPisces.SetWindowFocusListenerHandlers(ParentClass: TObject);
var
  ViewTreeObserver: JViewTreeObserver;
  Instance: TPisces;
  H: THandlers;
begin
  if not Assigned(FWindowFocusListener) then begin
    H := THandlers.From(TPisces(ParentClass));
    FWindowFocusListener := TPscWindowFocusChangeListener.Create;

    // Wrap virtual method and property
    FWindowFocusListener._OnWindowFocusChanged := H.OnWindowFocusChanged;

    if Assigned(FView) and Supports(FView, IPscView) then begin
      ViewTreeObserver := IPscView(FView).GetView.getViewTreeObserver;
      if Assigned(ViewTreeObserver) then begin
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
    Initialize;
    ShowView;
    AfterShow;
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

procedure TPisces.SetActivityLifecycleHandlers(ParentClass: TObject);
var
  Manager: TPscLifecycleManager;
  Instance: TPisces;
begin
  Instance := TPisces(ParentClass);
  try
    Manager := TPiscesApplication.GetLifecycleManager;

    if not Assigned(Manager) then
      TPscUtils.Log('Warning! Activity manager has not been created.', 'SetActivityLifecycleHandlers', TLogger.Warning, Self);

    if not Assigned(Manager.ActivityLifecycleListener) then
      TPscUtils.Log('Warning! Activity lifecycle listener has not been created.', 'SetActivityLifecycleHandlers', TLogger.Warning, Self);

    if Assigned(Manager) and Assigned(Manager.ActivityLifecycleListener) then begin
      TPscUtils.Log('Assigning activity lifecycle handlers', 'SetActivityLifecycleHandlers', TLogger.Info, Self);
      Manager.ActivityLifecycleListener.OnCreate := OnActivityCreateHandler;
      Manager.ActivityLifecycleListener.OnStart := OnActivityStartHandler;
      Manager.ActivityLifecycleListener.OnResume := OnActivityResumeHandler;
      Manager.ActivityLifecycleListener.OnPause := OnActivityPauseHandler;
      Manager.ActivityLifecycleListener.OnStop := OnActivityStopHandler;
      Manager.ActivityLifecycleListener.OnDestroy := OnActivityDestroyHandler;
      Manager.ActivityLifecycleListener.OnConfigurationChanged := OnActivityConfigurationChangedHandler;
      Manager.ActivityLifecycleListener.OnSaveInstanceState := OnActivitySaveInstanceStateHandler;
      TPscUtils.Log('Activity lifecycle handlers assigned', 'SetActivityLifecycleHandlers', TLogger.Info, Self);
    end;
  except on E: Exception do
      TPscUtils.Log('Error assigning activity lifecycle handlers: ' + E.Message, 'SetActivityLifecycleHandlers', TLogger.Warning, Self);
  end;
end;

procedure TPisces.SetKeyboardPadding;
var
  RttiContext: TRttiContext;
  RttiType: TRttiType;
  Attribute: TCustomAttribute;
  AttributesList: TArray<TCustomAttribute>;
begin
  TPscUtils.Log('', 'SetKeyboardPadding', TLogger.Info, Self);
  try
    RttiContext := TRttiContext.Create;
    try
      try
        RttiType := RttiContext.GetType(Self.ClassType);
        AttributesList := RttiType.GetAttributes;
        for Attribute in AttributesList do begin
          if (Attribute is EnableKeyboardPadding)then begin
            if TPiscesBooleanAttribute(Attribute).Value then begin
              FKeyboardHelper := TPscKeyboardHelper.Create(AndroidView.getRootView, 0);
              FKeyboardHelper.Enable;
              TPscUtils.Log('Keyboard helper created and enabled', 'SetKeyboardPadding', TLogger.Info, Self);
            end;
          end;
        end;
      except
        on E: Exception do
          TPscUtils.Log(E.Message, 'SetKeyboardPadding', TLogger.Fatal, Self);
      end;
    finally
      RttiContext.Free;
    end;
  except
    on E: Exception do
      TPscUtils.Log(E.Message, 'SetKeyboardPadding', TLogger.Fatal, Self);
  end;
end;

end.
