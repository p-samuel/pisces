unit Model.TripPlanner;

interface

// {
//    "Trips": [
//      {
//        "Id": "{GUID}",
//        "Name": "Santorini Vacation",
//        "Destination": "Santorini, Greece",
//        "StartDate": "2026-01-26",
//        "EndDate": "2026-02-02",
//        "Traveler": {
//          "Name": "John Doe",
//          "Email": "john@example.com",
//          "Phone": "+1234567890",
//          "Preferences": "Vegetarian, window seat"
//        },
//        "Settings": {
//          "Currency": "EUR",
//          "Units": "metric",
//          "Theme": "light"
//        },
//        "Itinerary": [
//          {
//            "Id": "{GUID}",
//            "Date": "2026-01-26",
//            "Title": "Arrival Day",
//            "Activities": [
//              {
//                "Id": "{GUID}",
//                "Name": "Check into hotel",
//                "Location": "Oia Village",
//                "StartTime": "2026-01-26T14:00:00",
//                "Duration": 60,
//                "Notes": "Confirm reservation beforehand",
//                "Reminders": [
//                  {
//                    "Time": "2026-01-26T12:00:00",
//                    "Note": "Confirm reservation",
//                    "Enabled": true
//                  }
//                ]
//              },
//              {
//                "Id": "{GUID}",
//                "Name": "Sunset dinner",
//                "Location": "Ammoudi Bay",
//                "StartTime": "2026-01-26T19:00:00",
//                "Duration": 120,
//                "Notes": "Fresh seafood restaurant",
//                "Reminders": [
//                  {
//                    "Time": "2026-01-26T18:00:00",
//                    "Note": "Leave for dinner",
//                    "Enabled": true
//                  }
//                ]
//              }
//            ]
//          }
//        ],
//        "Notes": [
//          "Pack sunscreen",
//          "Book sunset tour",
//          "Try local wine",
//          "Visit Red Beach"
//        ]
//      }
//    ],
//    "ActiveTripId": "{GUID}"
//  }

uses
  System.SysUtils,
  System.DateUtils,
  Pisces.State.Model;

type
  TReminder = class(TPscStateModel)
  public
    Time: TDateTime;
    Note: String;
    Enabled: Boolean;
  end;

  TActivity = class(TPscStateModel)
  public
    Id: String;
    Name: String;
    Location: String;
    StartTime: TDateTime;
    Duration: Integer;
    Notes: String;
    Reminders: TArray<TReminder>;
  end;

  TDayPlan = class(TPscStateModel)
  public
    Id: String;
    Date: TDate;
    Title: String;
    Activities: TArray<TActivity>;
  end;

  TTraveler = class(TPscStateModel)
  public
    Name: String;
    Email: String;
    Phone: String;
    Preferences: String;
  end;

  TTripSettings = class(TPscStateModel)
  public
    Currency: String;
    Units: String;
    Theme: String;
  end;

  TTripPlan = class(TPscStateModel)
  public
    Id: String;
    Name: String;
    Destination: String;
    StartDate: TDate;
    EndDate: TDate;
    Traveler: TTraveler;
    Settings: TTripSettings;
    Itinerary: TArray<TDayPlan>;
    Notes: TArray<String>;
  end;

  TTripPlannerState = class(TPscStateModel)
  public
    Trips: TArray<TTripPlan>;
    ActiveTripId: String;
    class function CreateSampleData: TTripPlannerState;
    function GetActiveTrip: TTripPlan;
    function GetActiveTripIndex: Integer;
  end;

implementation

{ TTripPlannerState }

class function TTripPlannerState.CreateSampleData: TTripPlannerState;
var
  Trip: TTripPlan;
  Day1, Day2: TDayPlan;
  Act1, Act2, Act3: TActivity;
  Rem1, Rem2: TReminder;
begin
  Result := TTripPlannerState.Create;

  Trip := TTripPlan.Create;
  Trip.Id := TGUID.NewGuid.ToString;
  Trip.Name := 'Santorini Vacation';
  Trip.Destination := 'Santorini, Greece';
  Trip.StartDate := Date + 30;
  Trip.EndDate := Date + 37;

  Trip.Traveler := TTraveler.Create;
  Trip.Traveler.Name := 'John Doe';
  Trip.Traveler.Email := 'john@example.com';
  Trip.Traveler.Phone := '+1234567890';
  Trip.Traveler.Preferences := 'Vegetarian, window seat';

  Trip.Settings := TTripSettings.Create;
  Trip.Settings.Currency := 'EUR';
  Trip.Settings.Units := 'metric';
  Trip.Settings.Theme := 'light';

  // Day 1: Arrival
  Day1 := TDayPlan.Create;
  Day1.Id := TGUID.NewGuid.ToString;
  Day1.Date := Trip.StartDate;
  Day1.Title := 'Arrival Day';

  Act1 := TActivity.Create;
  Act1.Id := TGUID.NewGuid.ToString;
  Act1.Name := 'Check into hotel';
  Act1.Location := 'Oia Village';
  Act1.StartTime := Day1.Date + EncodeTime(14, 0, 0, 0);
  Act1.Duration := 60;
  Act1.Notes := 'Confirm reservation beforehand';

  Rem1 := TReminder.Create;
  Rem1.Time := Day1.Date + EncodeTime(12, 0, 0, 0);
  Rem1.Note := 'Confirm reservation';
  Rem1.Enabled := True;

  Act1.Reminders := [Rem1];

  Act2 := TActivity.Create;
  Act2.Id := TGUID.NewGuid.ToString;
  Act2.Name := 'Sunset dinner';
  Act2.Location := 'Ammoudi Bay';
  Act2.StartTime := Day1.Date + EncodeTime(19, 0, 0, 0);
  Act2.Duration := 120;
  Act2.Notes := 'Fresh seafood restaurant';

  Rem2 := TReminder.Create;
  Rem2.Time := Day1.Date + EncodeTime(18, 0, 0, 0);
  Rem2.Note := 'Leave for dinner';
  Rem2.Enabled := True;

  Act2.Reminders := [Rem2];

  Day1.Activities := [Act1, Act2];

  // Day 2: Exploration
  Day2 := TDayPlan.Create;
  Day2.Id := TGUID.NewGuid.ToString;
  Day2.Date := Trip.StartDate + 1;
  Day2.Title := 'Explore Fira';

  Act3 := TActivity.Create;
  Act3.Id := TGUID.NewGuid.ToString;
  Act3.Name := 'Visit Fira town';
  Act3.Location := 'Fira';
  Act3.StartTime := Day2.Date + EncodeTime(10, 0, 0, 0);
  Act3.Duration := 240;
  Act3.Notes := 'Cable car from old port';
  Act3.Reminders := [];

  Day2.Activities := [Act3];

  Trip.Itinerary := [Day1, Day2];
  Trip.Notes := ['Pack sunscreen', 'Book sunset tour', 'Try local wine', 'Visit Red Beach'];

  Result.Trips := [Trip];
  Result.ActiveTripId := Trip.Id;
end;

function TTripPlannerState.GetActiveTrip: TTripPlan;
var
  I: Integer;
begin
  Result := nil;
  for I := 0 to Length(Trips) - 1 do begin
    if Trips[I].Id = ActiveTripId then begin
      Result := Trips[I];
      Exit;
    end;
  end;
  if (Result = nil) and (Length(Trips) > 0) then
    Result := Trips[0];
end;

function TTripPlannerState.GetActiveTripIndex: Integer;
var
  I: Integer;
begin
  Result := -1;
  for I := 0 to Length(Trips) - 1 do begin
    if Trips[I].Id = ActiveTripId then begin
      Result := I;
      Exit;
    end;
  end;
  if (Result = -1) and (Length(Trips) > 0) then
    Result := 0;
end;

end.
