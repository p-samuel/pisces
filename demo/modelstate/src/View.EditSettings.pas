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
  end;

procedure PopulateEditSettingsForm(View: TEditSettingsView; Settings: TTripSettings);
procedure SaveEditSettingsForm(View: TEditSettingsView; Settings: TTripSettings);

implementation

uses
  Androidapi.Helpers;

procedure PopulateEditSettingsForm(View: TEditSettingsView; Settings: TTripSettings);
var
  EdtCurrency, EdtUnits, EdtTheme: JEditText;
begin
  EdtCurrency := JEditText(View.FEdtCurrency.AndroidView);
  EdtUnits := JEditText(View.FEdtUnits.AndroidView);
  EdtTheme := JEditText(View.FEdtTheme.AndroidView);

  EdtCurrency.setText(StrToJCharSequence(Settings.Currency), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtUnits.setText(StrToJCharSequence(Settings.Units), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtTheme.setText(StrToJCharSequence(Settings.Theme), TJTextView_BufferType.JavaClass.EDITABLE);
end;

procedure SaveEditSettingsForm(View: TEditSettingsView; Settings: TTripSettings);
var
  EdtCurrency, EdtUnits, EdtTheme: JEditText;
begin
  EdtCurrency := JEditText(View.FEdtCurrency.AndroidView);
  EdtUnits := JEditText(View.FEdtUnits.AndroidView);
  EdtTheme := JEditText(View.FEdtTheme.AndroidView);

  Settings.Currency := JCharSequenceToStr(EdtCurrency.getText);
  Settings.Units := JCharSequenceToStr(EdtUnits.getText);
  Settings.Theme := JCharSequenceToStr(EdtTheme.getText);
end;

end.
