unit View.EditSettings;

interface

uses
  System.SysUtils,
  Pisces,
  Model.TripPlanner;

type

  [ TextView('lblCurrency'),
    Text('Currency (USD, EUR, etc.):'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblCurrency = class(TPisces)
  end;

  [ Edit('edtCurrency'),
    Hint('USD'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtCurrency = class(TPisces)
  end;

  [ TextView('lblUnits'),
    Text('Units (metric/imperial):'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblUnits = class(TPisces)
  end;

  [ Edit('edtUnits'),
    Hint('metric'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtUnits = class(TPisces)
  end;

  [ TextView('lblTheme'),
    Text('Theme (light/dark):'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblTheme = class(TPisces)
  end;

  [ Edit('edtTheme'),
    Hint('light'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtTheme = class(TPisces)
  end;

  [ LinearLayout('editSettingsDialog'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Padding(90, 90, 90, 90),
    Height(500)
  ] TEditSettingsView = class(TPisces)
    FLblCurrency: TLblCurrency;
    FEdtCurrency: TEdtCurrency;
    FLblUnits: TLblUnits;
    FEdtUnits: TEdtUnits;
    FLblTheme: TLblTheme;
    FEdtTheme: TEdtTheme;
    procedure OnViewAttachedToWindowHandler(AView: JView); override;
    procedure Save;
  end;

implementation

uses
  Androidapi.Helpers;

{ TEditSettingsView }

procedure TEditSettingsView.OnViewAttachedToWindowHandler(AView: JView);
var
  EdtCurrency, EdtUnits, EdtTheme: JEditText;
  Trip: TTripPlan;
  Settings: TTripSettings;
begin
  Trip := AppState.GetActiveTrip;
  if Trip = nil then Exit;

  if Trip.Settings = nil then
    Trip.Settings := TTripSettings.Create;
  Settings := Trip.Settings;

  EdtCurrency := JEditText(FEdtCurrency.AndroidView);
  EdtUnits := JEditText(FEdtUnits.AndroidView);
  EdtTheme := JEditText(FEdtTheme.AndroidView);

  EdtCurrency.setText(StrToJCharSequence(Settings.Currency), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtUnits.setText(StrToJCharSequence(Settings.Units), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtTheme.setText(StrToJCharSequence(Settings.Theme), TJTextView_BufferType.JavaClass.EDITABLE);
end;

procedure TEditSettingsView.Save;
var
  EdtCurrency, EdtUnits, EdtTheme: JEditText;
  Trip: TTripPlan;
  Settings: TTripSettings;
begin
  Trip := AppState.GetActiveTrip;
  if (Trip = nil) or (Trip.Settings = nil) then Exit;
  Settings := Trip.Settings;

  EdtCurrency := JEditText(FEdtCurrency.AndroidView);
  EdtUnits := JEditText(FEdtUnits.AndroidView);
  EdtTheme := JEditText(FEdtTheme.AndroidView);

  Settings.Currency := JCharSequenceToStr(EdtCurrency.getText);
  Settings.Units := JCharSequenceToStr(EdtUnits.getText);
  Settings.Theme := JCharSequenceToStr(EdtTheme.getText);
end;

end.
