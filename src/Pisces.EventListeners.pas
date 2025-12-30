unit Pisces.EventListeners;

{$M+}

interface

uses
  Androidapi.JNI.GraphicsContentViewText,Androidapi.JNI.App,
  Androidapi.JNI.Os,Androidapi.Helpers,
  FMX.Helpers.Android,
  System.SysUtils,
  Androidapi.JNIBridge,
  Androidapi.JNI.Widget,
  Pisces.Types;

type

  TPscViewClickListener = class(TJavaLocal, JView_OnClickListener)
  private
    FView: JView;
    FProc: TProc<JView>;
  public
    constructor Create(v: JView);
    procedure OnClick(v: JView); cdecl;
  published
    property Proc: TProc<JView> read FProc write FProc;
  end;

  TPscLinearLayoutLongClickListener = class(TJavaLocal, JView_OnLongClickListener)
  private
    FProc: TProc<JView>;
    FView: JView;
  public
    constructor Create(v: JView);
    function onLongClick(v: JView): Boolean; cdecl;
    function onLongClickUseDefaultHapticFeedback(v: JView): Boolean;
  published
    property Proc: TProc<JView> read FProc write FProc;
  end;

  TPscToolBarMenuItemClickListener = class(TJavaLocal, JToolBar_OnMenuItemClickListener)
  private
    FProc: TProc<JMenuItem>;
  public
    constructor Create(AProc: TProc<JMenuItem>);
    function onMenuItemClick(item: JMenuItem): Boolean; cdecl;
  published
    property Proc: TProc<JMenuItem> read FProc write FProc;
  end;

  TPscTimeChangedListener = class(TJavaLocal, JTimePicker_OnTimeChangedListener)
  private
    FProc: TProc<JTimePicker, Integer, Integer>;
  public
    constructor Create(AProc: TProc<JTimePicker, Integer, Integer>);
    procedure onTimeChanged(timePicker: JTimePicker; hourOfDay: Integer; minute: Integer); cdecl;
  published
    property Proc: TProc<JTimePicker, Integer, Integer> read FProc write FProc;
  end;

  TPscDateChangedListener = class(TJavaLocal, JDatePicker_OnDateChangedListener)
  private
    FProc: TProc<JDatePicker, Integer, Integer, Integer>;
  public
    constructor Create(AProc: TProc<JDatePicker, Integer, Integer, Integer>);
    procedure onDateChanged(datePicker: JDatePicker; year, month, day: Integer); cdecl;
  published
    property Proc: TProc<JDatePicker, Integer, Integer, Integer> read FProc write FProc;
  end;

  TPscCalendarDateChangedListener = class(TJavaLocal, JCalendarView_OnDateChangeListener)
  private
    FProc: TProc<JCalendarView, Integer, Integer, Integer>;
  public
    constructor Create(AProc: TProc<JCalendarView, Integer, Integer, Integer>);
    procedure onSelectedDayChange(view: JCalendarView; year, month, dayOfMonth: Integer); cdecl;
  published
    property Proc: TProc<JCalendarView, Integer, Integer, Integer> read FProc write FProc;
  end;

  TPscAdapterItemClickListener = class(TJavaLocal, JAdapterView_OnItemClickListener)
  private
    FProc: TProc<JAdapterView, JView, Integer, Int64>;
  public
    constructor Create(AProc: TProc<JAdapterView, JView, Integer, Int64>);
    procedure onItemClick(parent: JAdapterView; view: JView; position: Integer; id: Int64); cdecl;
  published
    property Proc: TProc<JAdapterView, JView, Integer, Int64> read FProc write FProc;
  end;

  TPscAdapterItemLongClickListener = class(TJavaLocal, JAdapterView_OnItemLongClickListener)
  private
    FProc: TProc<JAdapterView, JView, Integer, Int64>;
  public
    constructor Create(AProc: TProc<JAdapterView, JView, Integer, Int64>);
    function onItemLongClick(parent: JAdapterView; view: JView; position: Integer; id: Int64): Boolean; cdecl;
  published
    property Proc: TProc<JAdapterView, JView, Integer, Int64> read FProc write FProc;
  end;

  TPscAdapterItemSelectedListener = class(TJavaLocal, JAdapterView_OnItemSelectedListener)
  private
    FProc: TProc<JAdapterView, JView, Integer, Int64>;
    FNothingSelectedProc: TProc<JAdapterView>;
  public
    constructor Create(AProc: TProc<JAdapterView, JView, Integer, Int64>; ANothingSelectedProc: TProc<JAdapterView>);
    procedure onItemSelected(parent: JAdapterView; view: JView; position: Integer; id: Int64); cdecl;
    procedure onNothingSelected(parent: JAdapterView); cdecl;
  published
    property Proc: TProc<JAdapterView, JView, Integer, Int64> read FProc write FProc;
    property NothingSelectedProc: TProc<JAdapterView> read FNothingSelectedProc write FNothingSelectedProc;
  end;

  TPscPopupWindowDismissListener = class(TJavaLocal, JPopupWindow_OnDismissListener)
  private
    FOnDismiss: TProc;
  public
    constructor Create(AOnDismiss: TProc);
    procedure onDismiss; cdecl;
  end;

  TPscLayoutChangeListener = class(TJavaLocal, JView_OnLayoutChangeListener)
  private
    FProc: TProc<JView, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer>;
  public
    constructor Create(AProc: TProc<JView, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer>);
    procedure onLayoutChange(v: JView; left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom: Integer); cdecl;
  published
    property Proc: TProc<JView, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer> read FProc write FProc;
  end;

  TPscViewTouchListener = class(TJavaLocal, JView_OnTouchListener)
  private
    FStartX, FStartY: Single;
    FMinDistance: Single;
    FProc: TProc<JView, TSwipeDirection, Single, Single>;
    FHasDetectedSwipe: Boolean;
    // Interactive pop gesture support
    FLastX, FLastY: Single;
    FLastEventTime: Int64;
    FVelocityX, FVelocityY: Single;
    FPeakVelocityX: Single;  // Track peak velocity during gesture
    FEdgeThreshold: Single;
    FIsEdgeGesture: Boolean;
    FInteractivePopProc: TProc<JView, TPscInteractivePopState>;
    // Store raw (screen-absolute) coordinates for interactive pop
    // This prevents coordinate drift when view translates during gesture
    FRawStartX, FRawStartY: Single;
    procedure UpdateVelocity(CurrentX, CurrentY: Single; EventTime: Int64);
    function IsWithinEdge(X: Single): Boolean;
  public
    constructor Create;
    function onTouch(v: JView; event: JMotionEvent): Boolean; cdecl;
    property Proc: TProc<JView, TSwipeDirection, Single, Single> read FProc write FProc;
    property InteractivePopProc: TProc<JView, TPscInteractivePopState> read FInteractivePopProc write FInteractivePopProc;
    property EdgeThreshold: Single read FEdgeThreshold write FEdgeThreshold;
  end;

  TPscViewKeyListener = class(TJavaLocal, JView_OnKeyListener)
  private
    FProc: TFunc<JView, Integer, JKeyEvent, Boolean>;
  public
    constructor Create(AProc: TFunc<JView, Integer, JKeyEvent, Boolean>);
    function onKey(v: JView; keyCode: Integer; event: JKeyEvent): Boolean; cdecl;
  published
    property Proc: TFunc<JView, Integer, JKeyEvent, Boolean> read FProc write FProc;
  end;

  // AlertDialog listeners
  TPscDialogClickListener = class(TJavaLocal, JDialogInterface_OnClickListener)
  private
    FProc: TProc;
    FIndexProc: TProc<Integer>;
  public
    constructor Create(AProc: TProc); overload;
    constructor Create(AIndexProc: TProc<Integer>); overload;
    procedure onClick(dialog: JDialogInterface; which: Integer); cdecl;
  end;

  TPscDialogDismissListener = class(TJavaLocal, JDialogInterface_OnDismissListener)
  private
    FProc: TProc;
  public
    constructor Create(AProc: TProc);
    procedure onDismiss(dialog: JDialogInterface); cdecl;
  end;

  TPscDialogCancelListener = class(TJavaLocal, JDialogInterface_OnCancelListener)
  private
    FProc: TProc;
  public
    constructor Create(AProc: TProc);
    procedure onCancel(dialog: JDialogInterface); cdecl;
  end;

  TPscDialogMultiChoiceClickListener = class(TJavaLocal, JDialogInterface_OnMultiChoiceClickListener)
  private
    FProc: TProc<Integer, Boolean>;
  public
    constructor Create(AProc: TProc<Integer, Boolean>);
    procedure onClick(dialog: JDialogInterface; which: Integer; isChecked: Boolean); cdecl;
  end;

  TPscTextWatcherListener = class(TJavaLocal, JTextWatcher)
  private
    FProcAfter: TProc<String>;
    FProcChanging: TProc<String, Integer, Integer, Integer>;
    FProcBefore: TProc<String, Integer, Integer, Integer>;
  public
    constructor Create(AAfterProc: TProc<String>; AChangingProc: TProc<String, Integer, Integer, Integer>; ABeforeProc: TProc<String, Integer, Integer, Integer>);
    procedure beforeTextChanged(s: JCharSequence; start, count, after: Integer); cdecl;
    procedure onTextChanged(s: JCharSequence; start, before, count: Integer); cdecl;
    procedure afterTextChanged(s: JEditable); cdecl;
  published
    property ProcAfter: TProc<String> read FProcAfter write FProcAfter;
    property ProcChanging: TProc<String, Integer, Integer, Integer> read FProcChanging write FProcChanging;
    property ProcBefore: TProc<String, Integer, Integer, Integer> read FProcBefore write FProcBefore;
  end;

  TKeyboardLayoutProc = reference to procedure (ARootView: JView; ARootHeight, AVisibleHeight: Integer);

  TPscGlobalLayoutListener = class(TJavaLocal, JViewTreeObserver_OnGlobalLayoutListener)
  private
    FRootView: JView;
    FProc: TKeyboardLayoutProc;
  public
    constructor Create(ARootView: JView);
    procedure onGlobalLayout; cdecl;
  published
    property Proc: TKeyboardLayoutProc read FProc write FProc;
  end;

  TPscEditorActionListener = class(TJavaLocal, JTextView_OnEditorActionListener)
  private
    FProc: TProc<JTextView, Integer, JKeyEvent>;
  public
    constructor Create(AProc: TProc<JTextView, Integer, JKeyEvent>);
    function onEditorAction(v: JTextView; actionId: Integer; event: JKeyEvent): Boolean; cdecl;
  published
    property Proc: TProc<JTextView, Integer, JKeyEvent> read FProc write FProc;
  end;

implementation

uses
  System.Math, Pisces.Utils, Androidapi.JNI.Util;

{ TPscViewClickListener }

constructor TPscViewClickListener.Create(v: JView);
begin
  inherited Create;
  FView := v;
end;

procedure TPscViewClickListener.OnClick(v: JView);
begin
  if Assigned(FProc) then
    FProc(FView);
end;

{ TPscLinearLayoutLongClickListener }

constructor TPscLinearLayoutLongClickListener.Create(v: JView);
begin
  inherited Create;
  FView := v;
end;

function TPscLinearLayoutLongClickListener.onLongClick(v: JView): Boolean;
begin
  Result := True;
  if Assigned(FProc) then
    FProc(FView);
end;

function TPscLinearLayoutLongClickListener.onLongClickUseDefaultHapticFeedback(
  v: JView): Boolean;
begin
  Result := True;
end;

{ TPscToolBarMenuItemClickListener }

constructor TPscToolBarMenuItemClickListener.Create(AProc: TProc<JMenuItem>);
begin
  inherited Create;
  FProc := AProc;
end;

function TPscToolBarMenuItemClickListener.onMenuItemClick(item: JMenuItem): Boolean;
begin
  Result := False;
  if Assigned(FProc) then
  begin
    FProc(item);
    Result := True;
  end;
end;

constructor TPscTimeChangedListener.Create(AProc: TProc<JTimePicker, Integer, Integer>);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscTimeChangedListener.onTimeChanged(timePicker: JTimePicker; hourOfDay: Integer; minute: Integer); cdecl;
begin
  if Assigned(FProc) then
    FProc(timePicker, hourOfDay, minute);
end;

{ TPscDateChangedListener }

constructor TPscDateChangedListener.Create(AProc: TProc<JDatePicker, Integer, Integer, Integer>);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscDateChangedListener.onDateChanged(datePicker: JDatePicker; year, month, day: Integer);
begin
  if Assigned(FProc) then
    FProc(datePicker, year, month, day);
end;

{ TPscCalendarDateChangedListener }

constructor TPscCalendarDateChangedListener.Create(AProc: TProc<JCalendarView, Integer, Integer, Integer>);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscCalendarDateChangedListener.onSelectedDayChange(view: JCalendarView; year, month, dayOfMonth: Integer);
begin
  if Assigned(FProc) then
    FProc(view, year, month, dayOfMonth);
end;

{ TPscAdapterItemSelectedListener }

constructor TPscAdapterItemSelectedListener.Create(AProc: TProc<JAdapterView, JView, Integer, Int64>; ANothingSelectedProc: TProc<JAdapterView>);
begin
  inherited Create;
  FProc := AProc;
  FNothingSelectedProc := ANothingSelectedProc;
end;

procedure TPscAdapterItemSelectedListener.onItemSelected(parent: JAdapterView; view: JView; position: Integer; id: Int64);
begin
  TPscUtils.Log(Format('AdapterOnItemSelected pos=%d id=%d parent=%p view=%p', [position, id, Pointer(parent), Pointer(view)]), 'onItemClick', TLogger.Info, Self);
  if Assigned(FProc) then
    FProc(parent, view, position, id);
end;

procedure TPscAdapterItemSelectedListener.onNothingSelected(parent: JAdapterView);
begin
  if Assigned(FNothingSelectedProc) then
    FNothingSelectedProc(parent);
end;

{ TPscAdapterItemClickListener }

constructor TPscAdapterItemClickListener.Create(AProc: TProc<JAdapterView, JView, Integer, Int64>);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscAdapterItemClickListener.onItemClick(parent: JAdapterView; view: JView; position: Integer; id: Int64);
begin
  TPscUtils.Log(Format('AdapterItemClick pos=%d id=%d parent=%p view=%p', [position, id, Pointer(parent), Pointer(view)]), 'onItemClick', TLogger.Info, Self);
  if Assigned(FProc) then
    FProc(parent, view, position, id);
end;

{ TPscAdapterItemLongClickListener }

constructor TPscAdapterItemLongClickListener.Create(AProc: TProc<JAdapterView, JView, Integer, Int64>);
begin
  inherited Create;
  FProc := AProc;
end;

function TPscAdapterItemLongClickListener.onItemLongClick(parent: JAdapterView; view: JView; position: Integer; id: Int64): Boolean;
begin
  Result := True;
  TPscUtils.Log(Format('AdapterOnItemLongClick pos=%d id=%d parent=%p view=%p', [position, id, Pointer(parent), Pointer(view)]), 'onItemClick', TLogger.Info, Self);
  if Assigned(FProc) then
    FProc(parent, view, position, id);
end;

{ TPscPopupWindowDismissListener }

constructor TPscPopupWindowDismissListener.Create(AOnDismiss: TProc);
begin
  inherited Create;
  FOnDismiss := AOnDismiss;
end;

procedure TPscPopupWindowDismissListener.onDismiss;
begin
  if Assigned(FOnDismiss) then
    FOnDismiss();
end;

{ TPscLayoutChangeListener }

constructor TPscLayoutChangeListener.Create(AProc: TProc<JView, Integer, Integer, Integer, Integer, Integer, Integer, Integer, Integer>);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscLayoutChangeListener.onLayoutChange(v: JView; left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom: Integer);
begin
  if Assigned(FProc) then
    FProc(v, left, top, right, bottom, oldLeft, oldTop, oldRight, oldBottom);
end;

{ TPscViewTouchListener }

constructor TPscViewTouchListener.Create;
begin
  inherited Create;
  FMinDistance := 0.01; // Very small distance for real-time updates
  FHasDetectedSwipe := False;
  // Interactive pop defaults
  FEdgeThreshold := 40;
  FIsEdgeGesture := False;
  FVelocityX := 0;
  FVelocityY := 0;
  FPeakVelocityX := 0;
  FLastEventTime := 0;
  FRawStartX := 0;
  FRawStartY := 0;
end;

procedure TPscViewTouchListener.UpdateVelocity(CurrentX, CurrentY: Single; EventTime: Int64);
var
  DeltaTime: Single;
begin
  if FLastEventTime > 0 then
  begin
    DeltaTime := (EventTime - FLastEventTime) / 1000.0; // Convert to seconds
    if DeltaTime > 0 then
    begin
      // Simple velocity calculation with smoothing
      FVelocityX := (FVelocityX * 0.3) + ((CurrentX - FLastX) / DeltaTime * 0.7);
      FVelocityY := (FVelocityY * 0.3) + ((CurrentY - FLastY) / DeltaTime * 0.7);
    end;
  end;
  FLastX := CurrentX;
  FLastY := CurrentY;
  FLastEventTime := EventTime;
end;

function TPscViewTouchListener.IsWithinEdge(X: Single): Boolean;
begin
  Result := X <= FEdgeThreshold;
end;

function TPscViewTouchListener.onTouch(v: JView; event: JMotionEvent): Boolean;
var
  Action: Integer;
  CurrentX, CurrentY, DiffX, DiffY: Single;
  RawX: Single;
  EventTime: Int64;
  ScreenWidth: Single;
  PopState: TPscInteractivePopState;
begin
  Result := False; // Allow the event to propagate for normal scrolling

  Action := event.getActionMasked;
  CurrentX := event.getX;
  CurrentY := event.getY;
  RawX := event.getRawX;  // Use raw X for edge detection
  EventTime := event.getEventTime;

  case Action of
    // ACTION_DOWN = 0
    0:
    begin
      // Store initial touch coordinates
      FStartX := CurrentX;
      FStartY := CurrentY;
      FLastX := CurrentX;
      FLastY := CurrentY;
      FLastEventTime := EventTime;
      FVelocityX := 0;
      FVelocityY := 0;
      FPeakVelocityX := 0;  // Reset peak velocity for new gesture
      FHasDetectedSwipe := False;

      // Check if touch started within edge zone for interactive pop
      FIsEdgeGesture := IsWithinEdge(RawX) and Assigned(FInteractivePopProc);

      if FIsEdgeGesture then
      begin
        // Store raw (screen-absolute) coordinates for interactive pop
        // This prevents coordinate drift when view translates during gesture
        FRawStartX := RawX;
        FRawStartY := event.getRawY;

        PopState.Reset;
        PopState.Phase := TGesturePhase.Began;
        PopState.StartX := FRawStartX;
        PopState.StartY := FRawStartY;
        PopState.CurrentX := FRawStartX;
        PopState.CurrentY := FRawStartY;
        PopState.Progress := 0;
        PopState.VelocityX := 0;
        PopState.VelocityY := 0;
        PopState.PeakVelocityX := 0;
        PopState.IsActive := True;
        PopState.LastEventTime := EventTime;
        FInteractivePopProc(v, PopState);
        Result := True; // Consume if edge gesture started
      end;

      if Assigned(FProc) then
        FProc(v, TSwipeDirection.Touch, CurrentX, CurrentY);

      // Log initial touch position
      TPscUtils.Log(Format('X: %.2f Y: %.2f', [CurrentX, CurrentY]), 'Down', TLogger.Info, Self);
    end;

    // ACTION_MOVE = 2
    2:
    begin
      UpdateVelocity(CurrentX, CurrentY, EventTime);

      // Track peak velocity during gesture
      if FVelocityX > FPeakVelocityX then
        FPeakVelocityX := FVelocityX;

      // Handle interactive pop gesture
      if FIsEdgeGesture and Assigned(FInteractivePopProc) then
      begin
        ScreenWidth := v.getWidth;
        if ScreenWidth <= 0 then
          ScreenWidth := 1080; // Fallback

        PopState.Phase := TGesturePhase.Changed;
        PopState.StartX := FRawStartX;
        PopState.StartY := FRawStartY;
        // Use getRawX() for current position - screen-absolute coordinates
        // This prevents coordinate drift when view translates during gesture
        PopState.CurrentX := event.getRawX;
        PopState.CurrentY := event.getRawY;
        // Progress is based on horizontal movement relative to half screen width
        // Use raw coordinates to avoid drift as view translates
        PopState.Progress := Max(0, Min(1, (event.getRawX - FRawStartX) / (ScreenWidth * 0.5)));
        PopState.VelocityX := FVelocityX;
        PopState.VelocityY := FVelocityY;
        PopState.PeakVelocityX := FPeakVelocityX;
        PopState.IsActive := True;
        PopState.LastEventTime := EventTime;

        // Log interactive gesture movement
        TPscUtils.Log(Format('RawX: %.2f RawY: %.2f Progress: %.2f',
          [PopState.CurrentX, PopState.CurrentY, PopState.Progress]),
          'InteractiveMove', TLogger.Info, Self);

        FInteractivePopProc(v, PopState);
        Result := True;
      end
      else
      begin
        // Log every move event
        TPscUtils.Log(Format('X: %.2f Y: %.2f', [CurrentX, CurrentY]), 'Movement', TLogger.Info, Self);

        // Calculate distance moved from last position
        DiffX := CurrentX - FStartX;
        DiffY := CurrentY - FStartY;

        // Check if movement exceeds minimum distance (now 0.01)
        if ((Abs(DiffX) >= FMinDistance) or (Abs(DiffY) >= FMinDistance)) then
        begin
          // Determine swipe direction and call proc
          if Abs(DiffX) > Abs(DiffY) then begin
            // Horizontal swipe
            if DiffX > 0 then begin
              if Assigned(FProc) then
                FProc(v, TSwipeDirection.Right, CurrentX, CurrentY);
            end else begin
              if Assigned(FProc) then
                FProc(v, TSwipeDirection.Left, CurrentX, CurrentY);
            end;
          end else begin
            // Vertical swipe
            if DiffY > 0 then begin
              if Assigned(FProc) then
                FProc(v, TSwipeDirection.Down, CurrentX, CurrentY);
            end else begin
              if Assigned(FProc) then
                FProc(v, TSwipeDirection.Up, CurrentX, CurrentY);
            end;
          end;

          // Update start position to current position for continuous detection
          FStartX := CurrentX;
          FStartY := CurrentY;
        end;
      end;
    end;

    // ACTION_UP = 1 or ACTION_CANCEL = 3
    1, 3:
    begin
      UpdateVelocity(CurrentX, CurrentY, EventTime);

      // Final update to peak velocity
      if FVelocityX > FPeakVelocityX then
        FPeakVelocityX := FVelocityX;

      // Handle interactive pop gesture end
      if FIsEdgeGesture and Assigned(FInteractivePopProc) then
      begin
        ScreenWidth := v.getWidth;
        if ScreenWidth <= 0 then
          ScreenWidth := 1080;

        if Action = 3 then
          PopState.Phase := TGesturePhase.Cancelled
        else
          PopState.Phase := TGesturePhase.Ended;

        PopState.StartX := FRawStartX;
        PopState.StartY := FRawStartY;
        // Use getRawX() for final position - screen-absolute coordinates
        PopState.CurrentX := event.getRawX;
        PopState.CurrentY := event.getRawY;
        // Use raw coordinates for progress calculation
        PopState.Progress := Max(0, Min(1, (event.getRawX - FRawStartX) / (ScreenWidth * 0.5)));
        PopState.VelocityX := FVelocityX;
        PopState.VelocityY := FVelocityY;
        PopState.PeakVelocityX := FPeakVelocityX;  // Pass peak velocity for commit decision
        PopState.IsActive := False;
        PopState.LastEventTime := EventTime;
        FInteractivePopProc(v, PopState);
        Result := True;
      end;

      FIsEdgeGesture := False;
      FHasDetectedSwipe := False;
      FLastEventTime := 0;

      if (Action = 1) and Assigned(FProc) then
        FProc(v, TSwipeDirection.Leave, CurrentX, CurrentY);

      // Log final position
      TPscUtils.Log(Format('X: %.2f Y: %.2f', [CurrentX, CurrentY]), 'Up', TLogger.Info, Self);
    end;
  end;

end;

{ TPscDialogClickListener }

constructor TPscDialogClickListener.Create(AProc: TProc);
begin
  inherited Create;
  FProc := AProc;
  FIndexProc := nil;
end;

constructor TPscDialogClickListener.Create(AIndexProc: TProc<Integer>);
begin
  inherited Create;
  FProc := nil;
  FIndexProc := AIndexProc;
end;

procedure TPscDialogClickListener.onClick(dialog: JDialogInterface; which: Integer);
begin
  if Assigned(FIndexProc) then
    FIndexProc(which)
  else if Assigned(FProc) then
    FProc();
end;

{ TPscDialogDismissListener }

constructor TPscDialogDismissListener.Create(AProc: TProc);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscDialogDismissListener.onDismiss(dialog: JDialogInterface);
begin
  if Assigned(FProc) then
    FProc();
end;

{ TPscDialogCancelListener }

constructor TPscDialogCancelListener.Create(AProc: TProc);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscDialogCancelListener.onCancel(dialog: JDialogInterface);
begin
  if Assigned(FProc) then
    FProc();
end;

{ TPscDialogMultiChoiceClickListener }

constructor TPscDialogMultiChoiceClickListener.Create(AProc: TProc<Integer, Boolean>);
begin
  inherited Create;
  FProc := AProc;
end;

procedure TPscDialogMultiChoiceClickListener.onClick(dialog: JDialogInterface; which: Integer; isChecked: Boolean);
begin
  if Assigned(FProc) then
    FProc(which, isChecked);
end;

{ TPscTextWatcherListener }

constructor TPscTextWatcherListener.Create(AAfterProc: TProc<String>; AChangingProc: TProc<String, Integer, Integer, Integer>; ABeforeProc: TProc<String, Integer, Integer, Integer>);
begin
  inherited Create;
  FProcAfter := AAfterProc;
  FProcChanging := AChangingProc;
  FProcBefore := ABeforeProc;
end;

procedure TPscTextWatcherListener.beforeTextChanged(s: JCharSequence; start, count, after: Integer);
begin
  if Assigned(FProcBefore) then
    FProcBefore(JStringToString(s.toString), start, count, after);
end;

procedure TPscTextWatcherListener.onTextChanged(s: JCharSequence; start, before, count: Integer);
begin
  if Assigned(FProcChanging) then
    FProcChanging(JStringToString(s.toString), start, before, count);
end;

procedure TPscTextWatcherListener.afterTextChanged(s: JEditable);
begin
  if Assigned(FProcAfter) then
    FProcAfter(JStringToString(s.toString));
end;

{ TPscViewKeyListener }

constructor TPscViewKeyListener.Create(AProc: TFunc<JView, Integer, JKeyEvent, Boolean>);
begin
  inherited Create;
  FProc := AProc;
end;

function TPscViewKeyListener.onKey(v: JView; keyCode: Integer; event: JKeyEvent): Boolean;
begin
  Result := False;
  if Assigned(FProc) then
    Result := FProc(v, keyCode, event);
end;

{ TPscGlobalLayoutListener }

constructor TPscGlobalLayoutListener.Create(ARootView: JView);
begin
  inherited Create;
  FRootView := ARootView;
end;

procedure TPscGlobalLayoutListener.onGlobalLayout;
var
  Rect: JRect;
  RootView: JView;
  ScreenRoot: JView;
  RootHeight: Integer;
  VisibleHeight: Integer;
begin
  RootView := FRootView;
  if RootView = nil then Exit;
  ScreenRoot := RootView.getRootView;
  if ScreenRoot = nil then
    ScreenRoot := RootView;

  Rect := TJRect.JavaClass.init;
  RootView.getWindowVisibleDisplayFrame(Rect);
  RootHeight := ScreenRoot.getHeight;
  VisibleHeight := Rect.bottom - Rect.top;
  if Assigned(FProc) then
    FProc(ScreenRoot, RootHeight, VisibleHeight);
end;

{ TPscEditorActionListener }

constructor TPscEditorActionListener.Create(AProc: TProc<JTextView, Integer, JKeyEvent>);
begin
  inherited Create;
  FProc := AProc;
end;

function TPscEditorActionListener.onEditorAction(v: JTextView; actionId: Integer; event: JKeyEvent): Boolean;
begin
  Result := False;
  if Assigned(FProc) then
  begin
    FProc(v, actionId, event);
    Result := True;
  end;
end;

end.
