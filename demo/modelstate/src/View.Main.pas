unit View.Main;

interface

uses
  System.SysUtils,
  Pisces,
  Model.TripPlanner,
  View.EditTrip,
  View.EditTraveler,
  View.EditSettings,
  View.EditNotes,
  View.EditItinerary,
  View.EditActivity,
  View.EditReminders;

type
  [ TextView('title'),
    Text('Trip Planner'),
    TextSize(22),
    TextColor(255, 255, 255),
    Height(260),
    Padding(16, 16, 16, 0),
    Gravity([TGravity.Center])
  ] THeaderTitle = class(TPisces)
  end;

  [ TextView('tripSummary'),
    Text('No active trip'),
    TextSize(14),
    TextColor(200, 220, 255),
    Height(180),
    Padding(16, 0, 16, 16),
    Gravity([TGravity.Center])
  ] TTripSummary = class(TPisces)
  end;

  [ Button('btnEditTrip'),
    Text('Trip Info'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Padding(16, 12, 16, 12)
  ] TEditTripBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnEditTraveler'),
    Text('Traveler'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Padding(16, 12, 16, 12)
  ] TEditTravelerBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnEditSettings'),
    Text('Settings'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Padding(16, 12, 16, 12)
  ] TEditSettingsBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnEditItinerary'),
    Text('Itinerary'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Padding(16, 12, 16, 12)
  ] TEditItineraryBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnEditNotes'),
    Text('Notes'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(105, 82, 163),
    Padding(16, 12, 16, 12)
  ] TEditNotesBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnNewTrip'),
    Text('+ New Trip'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(165, 128, 254),
    Padding(16, 12, 16, 12)
  ] TNewTripBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnLoadTrip'),
    Text('Load Trip'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(82, 105, 163),
    Padding(16, 12, 16, 12)
  ] TLoadTripBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ Button('btnClearTrips'),
    Text('Clear All Trips'),
    TextSize(14),
    TextColor(255, 255, 255),
    BackgroundTintList(163, 82, 105),
    Padding(16, 12, 16, 12)
  ] TClearTripsBtn = class(TPisces)
    procedure OnClickHandler(AView: JView); override;
  end;

  [ LinearLayout('buttonContainer'),
    Orientation(TOrientation.Vertical),
    Height(TLayout.WRAP),
    Width(TLayout.MATCH),
    Padding(16, 8, 16, 16)
  ] TButtonContainer = class(TPisces)
    FEditTripBtn: TEditTripBtn;
    FEditTravelerBtn: TEditTravelerBtn;
    FEditSettingsBtn: TEditSettingsBtn;
    FEditItineraryBtn: TEditItineraryBtn;
    FEditNotesBtn: TEditNotesBtn;
    FNewTripBtn: TNewTripBtn;
    FLoadTripBtn: TLoadTripBtn;
    FClearTripsBtn: TClearTripsBtn;
  end;

  [ TextView('statusText'),
    Text('State will be shown here'),
    TextSize(15),
    TextColor(150, 170, 190),
    Height(350),
    Padding(16, 16, 16, 16),
    Gravity([TGravity.Top])
  ] TStatusText = class(TPisces)
  end;

  [ LinearLayout('home'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(33, 33, 48),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Padding(16, 48, 16, 16)
  ] THomeScreen = class(TPisces)
    FHeaderTitle: THeaderTitle;
    FTripSummary: TTripSummary;
    FButtonContainer: TButtonContainer;
    FStatusText: TStatusText;
    FEditTripDialog: TEditTripView;
    FEditTravelerDialog: TEditTravelerView;
    FEditSettingsDialog: TEditSettingsView;
    FEditNotesDialog: TEditNotesView;
    FEditItineraryDialog: TEditItineraryView;
    FEditActivityDialog: TEditActivityView;
    FEditRemindersDialog: TEditRemindersView;
    procedure AfterInitialize; override;
    procedure AfterShow; override;
    procedure RefreshDisplay;
    procedure SaveAndRefresh;
  end;

var
  HomeScreen: THomeScreen;

implementation

uses
  Androidapi.Helpers,
  Pisces.ScreenManager;

{ THomeScreen }

procedure THomeScreen.RefreshDisplay;
var
  Trip: TTripPlan;
  Summary, Status: String;
  TxtSummary, TxtStatus: JTextView;
begin
  Trip := AppState.GetActiveTrip;
  if Trip <> nil then begin
    Summary := Trip.Name + #13#10 + Trip.Destination + #13#10 +
      DateToStr(Trip.StartDate) + ' - ' + DateToStr(Trip.EndDate);
    Status := 'Trips: ' + IntToStr(Length(AppState.Trips)) + #13#10 +
      'Days: ' + IntToStr(Length(Trip.Itinerary)) + #13#10 +
      'Notes: ' + IntToStr(Length(Trip.Notes));
    if Trip.Traveler <> nil then
      Status := Status + #13#10 + 'Traveler: ' + Trip.Traveler.Name;
    if Trip.Settings <> nil then
      Status := Status + #13#10 + 'Currency: ' + Trip.Settings.Currency;
  end else begin
    Summary := 'No active trip';
    Status := 'Create a new trip to get started';
  end;

  TxtSummary := JTextView(FTripSummary.AndroidView);
  TxtSummary.setText(StrToJCharSequence(Summary));

  TxtStatus := JTextView(FStatusText.AndroidView);
  TxtStatus.setText(StrToJCharSequence(Status));
end;

procedure THomeScreen.SaveAndRefresh;
begin
  AppState.Save;
  RefreshDisplay;
end;

{ TEditTripBtn }

procedure TEditTripBtn.OnClickHandler(AView: JView);
begin
  if AppState.GetActiveTrip = nil then begin
    TPscUtils.Toast('Create a trip first', 0);
    Exit;
  end;
  HomeScreen.FEditTripDialog.Visible := True;
  TPscUtils.AlertDialog
    .Title('Edit Trip Info')
    .CustomView(HomeScreen.FEditTripDialog.AndroidView)
    .PositiveButton('Save', procedure begin
      HomeScreen.FEditTripDialog.Save;
      HomeScreen.SaveAndRefresh;
    end)
    .NegativeButton('Cancel', nil)
    .OnDismiss(procedure begin
      HomeScreen.FEditTripDialog.Visible := False;
    end)
  .Show;
end;

{ TEditTravelerBtn }

procedure TEditTravelerBtn.OnClickHandler(AView: JView);
begin
  if AppState.GetActiveTrip = nil then begin
    TPscUtils.Toast('Create a trip first', 0);
    Exit;
  end;
  HomeScreen.FEditTravelerDialog.Visible := True;
  TPscUtils.AlertDialog
    .Title('Edit Traveler')
    .CustomView(HomeScreen.FEditTravelerDialog.AndroidView)
    .PositiveButton('Save', procedure begin
      HomeScreen.FEditTravelerDialog.Save;
      HomeScreen.SaveAndRefresh;
    end)
    .NegativeButton('Cancel', nil)
    .OnDismiss(procedure begin
      HomeScreen.FEditTravelerDialog.Visible := False;
    end)
  .Show;
end;

{ TEditSettingsBtn }

procedure TEditSettingsBtn.OnClickHandler(AView: JView);
begin
  if AppState.GetActiveTrip = nil then begin
    TPscUtils.Toast('Create a trip first', 0);
    Exit;
  end;
  HomeScreen.FEditSettingsDialog.Visible := True;
  TPscUtils.AlertDialog
    .Title('Edit Settings')
    .CustomView(HomeScreen.FEditSettingsDialog.AndroidView)
    .PositiveButton('Save', procedure begin
      HomeScreen.FEditSettingsDialog.Save;
      HomeScreen.SaveAndRefresh;
    end)
    .NegativeButton('Cancel', nil)
    .OnDismiss(procedure begin
      HomeScreen.FEditSettingsDialog.Visible  := False;
    end)
  .Show;
end;

{ TEditItineraryBtn }

procedure TEditItineraryBtn.OnClickHandler(AView: JView);
begin
  if AppState.GetActiveTrip = nil then begin
    TPscUtils.Toast('Create a trip first', 0);
    Exit;
  end;
  HomeScreen.FEditItineraryDialog.Visible := True;
  TPscUtils.AlertDialog
    .Title('Edit Itinerary')
    .CustomView(HomeScreen.FEditItineraryDialog.AndroidView)
    .PositiveButton('Done', procedure begin
      HomeScreen.SaveAndRefresh;
    end)
    .OnDismiss(procedure begin
      HomeScreen.FEditItineraryDialog.Visible := False;
    end)
  .Show;
end;

{ TEditNotesBtn }

procedure TEditNotesBtn.OnClickHandler(AView: JView);
begin
  if AppState.GetActiveTrip = nil then begin
    TPscUtils.Toast('Create a trip first', 0);
    Exit;
  end;
  HomeScreen.FEditNotesDialog.Visible := True;
  TPscUtils.AlertDialog
    .Title('Edit Notes')
    .CustomView(HomeScreen.FEditNotesDialog.AndroidView)
    .PositiveButton('Done', procedure begin
      HomeScreen.SaveAndRefresh;
    end)
    .OnDismiss(procedure begin
      HomeScreen.FEditNotesDialog.Visible := False;
    end)
  .Show;
end;

{ TNewTripBtn }

procedure TNewTripBtn.OnClickHandler(AView: JView);
var
  NewTrip: TTripPlan;
  Trips: TArray<TTripPlan>;
begin
  NewTrip := TTripPlan.Create;
  NewTrip.Id := TGUID.NewGuid.ToString;
  NewTrip.Name := 'New Trip';
  NewTrip.Destination := 'Destination';
  NewTrip.StartDate := Date + 7;
  NewTrip.EndDate := Date + 14;
  NewTrip.Traveler := TTraveler.Create;
  NewTrip.Settings := TTripSettings.Create;
  NewTrip.Settings.Currency := 'USD';
  NewTrip.Settings.Units := 'metric';
  NewTrip.Settings.Theme := 'light';

  Trips := AppState.Trips;
  SetLength(Trips, Length(Trips) + 1);
  Trips[High(Trips)] := NewTrip;
  AppState.Trips := Trips;
  AppState.ActiveTripId := NewTrip.Id;

  HomeScreen.SaveAndRefresh;
  TPscUtils.Toast('New trip created', 0);
end;

{ TLoadTripBtn }

var
  SelectedTripIndex: Integer = 0;

procedure TLoadTripBtn.OnClickHandler(AView: JView);
var
  TripNames: TArray<String>;
  I: Integer;
begin
  if Length(AppState.Trips) = 0 then begin
    TPscUtils.Toast('No trips available', 0);
    Exit;
  end;

  SetLength(TripNames, Length(AppState.Trips));
  SelectedTripIndex := 0;
  for I := 0 to Length(AppState.Trips) - 1 do begin
    TripNames[I] := AppState.Trips[I].Name + ' - ' + AppState.Trips[I].Destination;
    if AppState.Trips[I].Id = AppState.ActiveTripId then
      SelectedTripIndex := I;
  end;

  TPscUtils.AlertDialog
    .Title('Select Trip')
    .SingleChoiceItems(TripNames, SelectedTripIndex,
      procedure(Index: Integer) begin
        SelectedTripIndex := Index;
      end)
    .PositiveButton('Load', procedure begin
      if (SelectedTripIndex >= 0) and (SelectedTripIndex < Length(AppState.Trips)) then begin
        AppState.ActiveTripId := AppState.Trips[SelectedTripIndex].Id;
        HomeScreen.SaveAndRefresh;
        TPscUtils.Toast('Trip loaded', 0);
      end;
    end)
    .NegativeButton('Cancel', nil)
  .Show;
end;

{ TClearTripsBtn }

procedure TClearTripsBtn.OnClickHandler(AView: JView);
begin
  if Length(AppState.Trips) = 0 then begin
    TPscUtils.Toast('No trips to clear', 0);
    Exit;
  end;

  TPscUtils.AlertDialog
    .Title('Clear All Trips')
    .Message('Are you sure you want to delete all ' + IntToStr(Length(AppState.Trips)) + ' trip(s)? This cannot be undone.')
    .PositiveButton('Delete All', procedure begin
      AppState.Trips := [];
      AppState.ActiveTripId := '';
      HomeScreen.SaveAndRefresh;
      TPscUtils.Toast('All trips cleared', 0);
    end)
    .NegativeButton('Cancel', nil)
  .Show;
end;

procedure THomeScreen.AfterInitialize;
begin
  inherited;
end;

procedure THomeScreen.AfterShow;
begin
  inherited;
  FEditTripDialog.Hide;
  FEditTravelerDialog.Hide;
  FEditSettingsDialog.Hide;
  FEditNotesDialog.Hide;
  FEditItineraryDialog.Hide;
  FEditActivityDialog.Hide;
  FEditRemindersDialog.Hide;
  RefreshDisplay;
end;

initialization
  HomeScreen := THomeScreen.Create;
  HomeScreen.Show;
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  HomeScreen.Free;

end.
