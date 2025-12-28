unit View.EditTrip;

interface

uses
  System.SysUtils,
  Pisces,
  Model.TripPlanner;

type

  [ TextView('lblName'),
    Text('Trip Name:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblName = class(TPisces)
  end;

  [ Edit('edtName'),
    Hint('Enter trip name'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtName = class(TPisces)
  end;

  [ TextView('lblDestination'),
    Text('Destination:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblDestination = class(TPisces)
  end;

  [ Edit('edtDestination'),
    Hint('Enter destination'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtDestination = class(TPisces)
  end;

  [ TextView('lblStartDate'),
    Text('Start Date (YYYY-MM-DD):'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblStartDate = class(TPisces)
  end;

  [ Edit('edtStartDate'),
    Hint('2025-01-15'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtStartDate = class(TPisces)
  end;

  [ TextView('lblEndDate'),
    Text('End Date (YYYY-MM-DD):'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblEndDate = class(TPisces)
  end;

  [ Edit('edtEndDate'),
    Hint('2025-01-22'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtEndDate = class(TPisces)
  end;

  [ LinearLayout('editTripDialog'),
    Orientation(TOrientation.Vertical),
    Padding(90, 90, 90, 90),
    Height(650)
  ] TEditTripView = class(TPisces)
    FLblName: TLblName;
    FEdtName: TEdtName;
    FLblDestination: TLblDestination;
    FEdtDestination: TEdtDestination;
    FLblStartDate: TLblStartDate;
    FEdtStartDate: TEdtStartDate;
    FLblEndDate: TLblEndDate;
    FEdtEndDate: TEdtEndDate;
    procedure OnViewAttachedToWindowHandler(AView: JView); override;
    procedure Save;
  end;

implementation

uses
  Androidapi.Helpers;

{ TEditTripView }

procedure TEditTripView.OnViewAttachedToWindowHandler(AView: JView);
var
  EdtName, EdtDest, EdtStart, EdtEnd: JEditText;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  EdtName := JEditText(FEdtName.AndroidView);
  EdtDest := JEditText(FEdtDestination.AndroidView);
  EdtStart := JEditText(FEdtStartDate.AndroidView);
  EdtEnd := JEditText(FEdtEndDate.AndroidView);

  EdtName.setText(StrToJCharSequence(Trip.Name), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtDest.setText(StrToJCharSequence(Trip.Destination), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtStart.setText(StrToJCharSequence(FormatDateTime('yyyy-mm-dd', Trip.StartDate)), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtEnd.setText(StrToJCharSequence(FormatDateTime('yyyy-mm-dd', Trip.EndDate)), TJTextView_BufferType.JavaClass.EDITABLE);
end;

procedure TEditTripView.Save;
var
  EdtName, EdtDest, EdtStart, EdtEnd: JEditText;
  Trip: TTripPlan;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  EdtName := JEditText(FEdtName.AndroidView);
  EdtDest := JEditText(FEdtDestination.AndroidView);
  EdtStart := JEditText(FEdtStartDate.AndroidView);
  EdtEnd := JEditText(FEdtEndDate.AndroidView);

  Trip.Name := JCharSequenceToStr(EdtName.getText);
  Trip.Destination := JCharSequenceToStr(EdtDest.getText);
  Trip.StartDate := StrToDateDef(JCharSequenceToStr(EdtStart.getText), Date);
  Trip.EndDate := StrToDateDef(JCharSequenceToStr(EdtEnd.getText), Date + 7);
end;

end.
