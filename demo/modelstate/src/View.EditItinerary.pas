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
  end;

var
  CurrentItineraryTrip: TTripPlan;
  CurrentItineraryView: TEditItineraryView;

procedure PopulateEditItineraryForm(View: TEditItineraryView; Trip: TTripPlan);
procedure RefreshDaysList;

implementation

uses
  Androidapi.Helpers;

procedure RefreshDaysList;
var
  I: Integer;
  DaysText: String;
  TxtDays: JTextView;
  Day: TDayPlan;
begin
  if (CurrentItineraryTrip = nil) or (CurrentItineraryView = nil) then Exit;

  if Length(CurrentItineraryTrip.Itinerary) = 0 then
    DaysText := '(no days planned)'
  else begin
    DaysText := '';
    for I := 0 to Length(CurrentItineraryTrip.Itinerary) - 1 do begin
      Day := CurrentItineraryTrip.Itinerary[I];
      if I > 0 then DaysText := DaysText + #13#10;
      DaysText := DaysText + IntToStr(I + 1) + '. ' +
        FormatDateTime('yyyy-mm-dd', Day.Date) + ' - ' + Day.Title;
      if Length(Day.Activities) > 0 then
        DaysText := DaysText + ' (' + IntToStr(Length(Day.Activities)) + ' activities)';
    end;
  end;

  TxtDays := JTextView(CurrentItineraryView.FTxtDaysList.AndroidView);
  TxtDays.setText(StrToJCharSequence(DaysText));
end;

procedure PopulateEditItineraryForm(View: TEditItineraryView; Trip: TTripPlan);
var
  EdtTitle: JEditText;
begin
  CurrentItineraryTrip := Trip;
  CurrentItineraryView := View;

  EdtTitle := JEditText(View.FEdtNewDayTitle.AndroidView);
  EdtTitle.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);

  RefreshDaysList;
end;

{ TBtnAddDay }

procedure TBtnAddDay.OnClickHandler(AView: JView);
var
  EdtTitle: JEditText;
  NewTitle: String;
  Days: TArray<TDayPlan>;
  NewDay: TDayPlan;
  NextDate: TDate;
begin
  if CurrentItineraryTrip = nil then Exit;

  EdtTitle := JEditText(CurrentItineraryView.FEdtNewDayTitle.AndroidView);
  NewTitle := Trim(JCharSequenceToStr(EdtTitle.getText));

  if NewTitle = '' then
    NewTitle := 'Day ' + IntToStr(Length(CurrentItineraryTrip.Itinerary) + 1);

  NewDay := TDayPlan.Create;
  NewDay.Id := TGUID.NewGuid.ToString;
  NewDay.Title := NewTitle;

  if Length(CurrentItineraryTrip.Itinerary) = 0 then
    NextDate := CurrentItineraryTrip.StartDate
  else
    NextDate := CurrentItineraryTrip.Itinerary[High(CurrentItineraryTrip.Itinerary)].Date + 1;

  NewDay.Date := NextDate;
  NewDay.Activities := [];

  Days := CurrentItineraryTrip.Itinerary;
  SetLength(Days, Length(Days) + 1);
  Days[High(Days)] := NewDay;
  CurrentItineraryTrip.Itinerary := Days;

  EdtTitle.setText(StrToJCharSequence(''), TJTextView_BufferType.JavaClass.EDITABLE);
  RefreshDaysList;
  TPscUtils.Toast('Day added', 0);
end;

{ TBtnClearDays }

procedure TBtnClearDays.OnClickHandler(AView: JView);
begin
  if CurrentItineraryTrip = nil then Exit;

  CurrentItineraryTrip.Itinerary := [];
  RefreshDaysList;
  TPscUtils.Toast('Itinerary cleared', 0);
end;

end.
