unit View.EditActivity;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Pisces,
  Model.TripPlanner;

type

  [ TextView('lblActivitiesList'),
    Text('Activities:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblActivitiesList = class(TPisces)
  end;

  [ TextView('txtActivitiesList'),
    Text('(no activities)'),
    TextSize(12),
    TextColor(66, 66, 66),
    Padding(16, 4, 16, 8),
    Height(200)
  ] TTxtActivitiesList = class(TPisces)
  end;

  [ TextView('lblNewActivity'),
    Text('Activity Name:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblNewActivity = class(TPisces)
  end;

  [ Edit('edtNewActivityName'),
    Hint('Activity name'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtNewActivityName = class(TPisces)
  end;

  [ TextView('lblLocation'),
    Text('Location:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblLocation = class(TPisces)
  end;

  [ Edit('edtLocation'),
    Hint('Location'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtLocation = class(TPisces)
  end;

  [ Button('btnAddActivity'),
    Text('Add Activity'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(76, 175, 80),
    Height(80),
    Padding(16, 4, 16, 8)
  ] TBtnAddActivity = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('editActivityDialog'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Padding(90, 90, 90, 90),
    Height(650)
  ] TEditActivityView = class(TPisces)
  private
    FCurrentDay: TDayPlan;
  public
    FLblActivitiesList: TLblActivitiesList;
    FTxtActivitiesList: TTxtActivitiesList;
    FLblNewActivity: TLblNewActivity;
    FEdtNewActivityName: TEdtNewActivityName;
    FLblLocation: TLblLocation;
    FEdtLocation: TEdtLocation;
    FBtnAddActivity: TBtnAddActivity;
    procedure SetDay(Day: TDayPlan);
    procedure RefreshActivitiesList;
    property CurrentDay: TDayPlan read FCurrentDay;
  end;

implementation

uses
  Androidapi.Helpers;

{ TEditActivityView }

procedure TEditActivityView.SetDay(Day: TDayPlan);
var
  EdtName, EdtLoc: JEditText;
begin
  FCurrentDay := Day;

  EdtName := JEditText(FEdtNewActivityName.AndroidView);
  EdtLoc := JEditText(FEdtLocation.AndroidView);
  EdtName.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtLoc.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);

  RefreshActivitiesList;
end;

procedure TEditActivityView.RefreshActivitiesList;
var
  I: Integer;
  ActivitiesText: String;
  TxtActivities: JTextView;
  Activity: TActivity;
begin
  if FCurrentDay = nil then Exit;

  if Length(FCurrentDay.Activities) = 0 then
    ActivitiesText := '(no activities)'
  else begin
    ActivitiesText := '';
    for I := 0 to Length(FCurrentDay.Activities) - 1 do begin
      Activity := FCurrentDay.Activities[I];
      if I > 0 then ActivitiesText := ActivitiesText + #13#10;
      ActivitiesText := ActivitiesText + IntToStr(I + 1) + '. ' +
        Activity.Name + ' @ ' + Activity.Location;
      if Activity.Duration > 0 then
        ActivitiesText := ActivitiesText + ' (' + IntToStr(Activity.Duration) + ' min)';
      if Length(Activity.Reminders) > 0 then
        ActivitiesText := ActivitiesText + ' [' + IntToStr(Length(Activity.Reminders)) + ' reminders]';
    end;
  end;

  TxtActivities := JTextView(FTxtActivitiesList.AndroidView);
  TxtActivities.setText(StrToJCharSequence(ActivitiesText));
end;

{ TBtnAddActivity }

procedure TBtnAddActivity.OnClickHandler(AView: JView);
var
  ParentView: TEditActivityView;
  EdtName, EdtLoc: JEditText;
  NewName, NewLoc: String;
  Activities: TArray<TActivity>;
  NewActivity: TActivity;
begin
  ParentView := TEditActivityView(Parent);
  if ParentView.CurrentDay = nil then Exit;

  EdtName := JEditText(ParentView.FEdtNewActivityName.AndroidView);
  EdtLoc := JEditText(ParentView.FEdtLocation.AndroidView);
  NewName := Trim(JCharSequenceToStr(EdtName.getText));
  NewLoc := Trim(JCharSequenceToStr(EdtLoc.getText));

  if NewName = '' then begin
    TPscUtils.Toast('Enter activity name', 0);
    Exit;
  end;

  NewActivity := TActivity.Create;
  NewActivity.Id := TGUID.NewGuid.ToString;
  NewActivity.Name := NewName;
  NewActivity.Location := NewLoc;
  NewActivity.StartTime := ParentView.CurrentDay.Date + EncodeTime(9, 0, 0, 0);
  NewActivity.Duration := 60;
  NewActivity.Notes := '';
  NewActivity.Reminders := [];

  Activities := ParentView.CurrentDay.Activities;
  SetLength(Activities, Length(Activities) + 1);
  Activities[High(Activities)] := NewActivity;
  ParentView.CurrentDay.Activities := Activities;

  EdtName.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtLoc.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  ParentView.RefreshActivitiesList;
  TPscUtils.Toast('Activity added', 0);
end;

end.
