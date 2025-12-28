unit View.EditItinerary;

interface

uses
  System.SysUtils,
  System.DateUtils,
  Pisces,
  Model.TripPlanner;

type

  [ TextView('lblDaysList'),
    Text('Day Plans:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblDaysList = class(TPisces)
  end;

  [ TextView('txtDaysList'),
    Text('(no days)'),
    TextSize(12),
    TextColor(66, 66, 66),
    Padding(16, 4, 16, 8),
    Height(250)
  ] TTxtDaysList = class(TPisces)
  end;

  [ TextView('lblNewDay'),
    Text('New Day Title:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblNewDay = class(TPisces)
  end;

  [ Edit('edtNewDayTitle'),
    Hint('Day title'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtNewDayTitle = class(TPisces)
  end;

  [ Button('btnAddDay'),
    Text('Add Day'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Height(TLayout.WRAP),
    Width(TLayout.MATCH),
    Padding(16, 12, 16, 12)
  ] TBtnAddDay = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnClearDays'),
    Text('Clear All'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Height(TLayout.WRAP),
    Width(TLayout.MATCH),
    Padding(16, 12, 16, 12)
  ] TBtnClearDays = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('editItineraryDialog'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Padding(90, 90, 90, 90),
    Height(650)
  ] TEditItineraryView = class(TPisces)
    FLblDaysList: TLblDaysList;
    FTxtDaysList: TTxtDaysList;
    FLblNewDay: TLblNewDay;
    FEdtNewDayTitle: TEdtNewDayTitle;
    FBtnAddDay: TBtnAddDay;
    FBtnClearDays: TBtnClearDays;
    procedure OnViewAttachedToWindowHandler(AView: JView); override;
    procedure RefreshDaysList;
  end;

implementation

uses
  Androidapi.Helpers;

{ TEditItineraryView }

procedure TEditItineraryView.OnViewAttachedToWindowHandler(AView: JView);
var
  EdtTitle: JEditText;
begin
  EdtTitle := JEditText(FEdtNewDayTitle.AndroidView);
  EdtTitle.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  RefreshDaysList;
end;

procedure TEditItineraryView.RefreshDaysList;
var
  I: Integer;
  DaysText: String;
  TxtDays: JTextView;
  Day: TDayPlan;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  if Length(Trip.Itinerary) = 0 then
    DaysText := '(no days planned)'
  else begin
    DaysText := '';
    for I := 0 to Length(Trip.Itinerary) - 1 do begin
      Day := Trip.Itinerary[I];
      if I > 0 then DaysText := DaysText + #13#10;
      DaysText := DaysText + IntToStr(I + 1) + '. ' +
        FormatDateTime('yyyy-mm-dd', Day.Date) + ' - ' + Day.Title;
      if Length(Day.Activities) > 0 then
        DaysText := DaysText + ' (' + IntToStr(Length(Day.Activities)) + ' activities)';
    end;
  end;

  TxtDays := JTextView(FTxtDaysList.AndroidView);
  TxtDays.setText(StrToJCharSequence(DaysText));
end;

{ TBtnAddDay }

procedure TBtnAddDay.OnClickHandler(AView: JView);
var
  ParentView: TEditItineraryView;
  EdtTitle: JEditText;
  NewTitle: String;
  Days: TArray<TDayPlan>;
  NewDay: TDayPlan;
  NextDate: TDate;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  ParentView := TEditItineraryView(Parent);
  EdtTitle := JEditText(ParentView.FEdtNewDayTitle.AndroidView);
  NewTitle := Trim(JCharSequenceToStr(EdtTitle.getText));

  if NewTitle = '' then
    NewTitle := 'Day ' + IntToStr(Length(Trip.Itinerary) + 1);

  NewDay := TDayPlan.Create;
  NewDay.Id := TGUID.NewGuid.ToString;
  NewDay.Title := NewTitle;

  if Length(Trip.Itinerary) = 0 then
    NextDate := Trip.StartDate
  else
    NextDate := Trip.Itinerary[High(Trip.Itinerary)].Date + 1;

  NewDay.Date := NextDate;
  NewDay.Activities := [];

  Days := Trip.Itinerary;
  SetLength(Days, Length(Days) + 1);
  Days[High(Days)] := NewDay;
  Trip.Itinerary := Days;

  EdtTitle.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  ParentView.RefreshDaysList;
  TPscUtils.Toast('Day added', 0);
end;

{ TBtnClearDays }

procedure TBtnClearDays.OnClickHandler(AView: JView);
var
  ParentView: TEditItineraryView;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  ParentView := TEditItineraryView(Parent);
  Trip.Itinerary := [];
  ParentView.RefreshDaysList;
  TPscUtils.Toast('Itinerary cleared', 0);
end;

end.
