unit View.EditReminders;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Pisces,
  Model.TripPlanner;

type

  [ TextView('lblRemindersList'),
    Text('Reminders:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblRemindersList = class(TPisces)
  end;

  [ TextView('txtRemindersList'),
    Text('(no reminders)'),
    TextSize(12),
    TextColor(66, 66, 66),
    Padding(16, 4, 16, 8),
    Height(200)
  ] TTxtRemindersList = class(TPisces)
  end;

  [ TextView('lblNewReminder'),
    Text('Reminder Note:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblNewReminder = class(TPisces)
  end;

  [ Edit('edtNewReminderNote'),
    Hint('Reminder note'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtNewReminderNote = class(TPisces)
  end;

  [ TextView('lblReminderTime'),
    Text('Time (HH:MM):'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblReminderTime = class(TPisces)
  end;

  [ Edit('edtReminderTime'),
    Hint('09:00'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtReminderTime = class(TPisces)
  end;

  [ Button('btnAddReminder'),
    Text('Add Reminder'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(76, 175, 80),
    Height(80),
    Padding(16, 4, 16, 8)
  ] TBtnAddReminder = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnClearReminders'),
    Text('Clear All'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(244, 67, 54),
    Height(80),
    Padding(16, 4, 16, 8)
  ] TBtnClearReminders = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('editRemindersDialog'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Padding(90, 90, 90, 90),
    Height(650)
  ] TEditRemindersView = class(TPisces)
  private
    FCurrentActivity: TActivity;
  public
    FLblRemindersList: TLblRemindersList;
    FTxtRemindersList: TTxtRemindersList;
    FLblNewReminder: TLblNewReminder;
    FEdtNewReminderNote: TEdtNewReminderNote;
    FLblReminderTime: TLblReminderTime;
    FEdtReminderTime: TEdtReminderTime;
    FBtnAddReminder: TBtnAddReminder;
    FBtnClearReminders: TBtnClearReminders;
    procedure SetActivity(Activity: TActivity);
    procedure RefreshRemindersList;
    property CurrentActivity: TActivity read FCurrentActivity;
  end;

implementation

uses
  Androidapi.Helpers;

{ TEditRemindersView }

procedure TEditRemindersView.SetActivity(Activity: TActivity);
var
  EdtNote, EdtTime: JEditText;
begin
  FCurrentActivity := Activity;

  EdtNote := JEditText(FEdtNewReminderNote.AndroidView);
  EdtTime := JEditText(FEdtReminderTime.AndroidView);
  EdtNote.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtTime.setText(StrToJCharSequence('09:00'), TJTextView_BufferType.JavaClass.EDITABLE);

  RefreshRemindersList;
end;

procedure TEditRemindersView.RefreshRemindersList;
var
  I: Integer;
  RemindersText: String;
  TxtReminders: JTextView;
  Reminder: TReminder;
begin
  if FCurrentActivity = nil then Exit;

  if Length(FCurrentActivity.Reminders) = 0 then
    RemindersText := '(no reminders)'
  else begin
    RemindersText := '';
    for I := 0 to Length(FCurrentActivity.Reminders) - 1 do begin
      Reminder := FCurrentActivity.Reminders[I];
      if I > 0 then RemindersText := RemindersText + #13#10;
      RemindersText := RemindersText + IntToStr(I + 1) + '. ' +
        FormatDateTime('hh:nn', Reminder.Time) + ' - ' + Reminder.Note;
      if Reminder.Enabled then
        RemindersText := RemindersText + ' [ON]'
      else
        RemindersText := RemindersText + ' [OFF]';
    end;
  end;

  TxtReminders := JTextView(FTxtRemindersList.AndroidView);
  TxtReminders.setText(StrToJCharSequence(RemindersText));
end;

{ TBtnAddReminder }

procedure TBtnAddReminder.OnClickHandler(AView: JView);
var
  ParentView: TEditRemindersView;
  EdtNote, EdtTime: JEditText;
  NewNote, TimeStr: String;
  Reminders: TArray<TReminder>;
  NewReminder: TReminder;
  Hour, Min: Integer;
begin
  ParentView := TEditRemindersView(Parent);
  if ParentView.CurrentActivity = nil then Exit;

  EdtNote := JEditText(ParentView.FEdtNewReminderNote.AndroidView);
  EdtTime := JEditText(ParentView.FEdtReminderTime.AndroidView);
  NewNote := Trim(JCharSequenceToStr(EdtNote.getText));
  TimeStr := Trim(JCharSequenceToStr(EdtTime.getText));

  if NewNote = '' then begin
    TPscUtils.Toast('Enter reminder note', 0);
    Exit;
  end;

  Hour := 9;
  Min := 0;
  if Pos(':', TimeStr) > 0 then begin
    TryStrToInt(Copy(TimeStr, 1, Pos(':', TimeStr) - 1), Hour);
    TryStrToInt(Copy(TimeStr, Pos(':', TimeStr) + 1, 2), Min);
  end;

  NewReminder := TReminder.Create;
  NewReminder.Time := Date + EncodeTime(Hour, Min, 0, 0);
  NewReminder.Note := NewNote;
  NewReminder.Enabled := True;

  Reminders := ParentView.CurrentActivity.Reminders;
  SetLength(Reminders, Length(Reminders) + 1);
  Reminders[High(Reminders)] := NewReminder;
  ParentView.CurrentActivity.Reminders := Reminders;

  EdtNote.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  ParentView.RefreshRemindersList;
  TPscUtils.Toast('Reminder added', 0);
end;

{ TBtnClearReminders }

procedure TBtnClearReminders.OnClickHandler(AView: JView);
var
  ParentView: TEditRemindersView;
begin
  ParentView := TEditRemindersView(Parent);
  if ParentView.CurrentActivity = nil then Exit;

  ParentView.CurrentActivity.Reminders := [];
  ParentView.RefreshRemindersList;
  TPscUtils.Toast('Reminders cleared', 0);
end;

end.
