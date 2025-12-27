unit View.EditTraveler;

interface

uses
  System.SysUtils,
  Pisces,
  Model.TripPlanner;

type
  [ TextView('lblTravelerName'),
    Text('Name:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblTravelerName = class(TPisces)
  end;

  [ Edit('edtTravelerName'),
    Hint('Enter your name'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtTravelerName = class(TPisces)
  end;

  [ TextView('lblEmail'),
    Text('Email:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblEmail = class(TPisces)
  end;

  [ Edit('edtEmail'),
    Hint('Enter your email'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtEmail = class(TPisces)
  end;

  [ TextView('lblPhone'),
    Text('Phone:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblPhone = class(TPisces)
  end;

  [ Edit('edtPhone'),
    Hint('Enter your phone'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtPhone = class(TPisces)
  end;

  [ TextView('lblPreferences'),
    Text('Preferences:'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 8, 16, 4)
  ] TLblPreferences = class(TPisces)
  end;

  [ Edit('edtPreferences'),
    Hint('Dietary, accessibility, etc.'),
    TextSize(14),
    TextColor(33, 33, 33),
    Padding(16, 4, 16, 8),
    Height(90)
  ] TEdtPreferences = class(TPisces)
  end;

  [ LinearLayout('editTravelerDialog'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 255, 255),
    Padding(90, 90, 90, 90),
    Height(650)
  ] TEditTravelerView = class(TPisces)
    FLblName: TLblTravelerName;
    FEdtName: TEdtTravelerName;
    FLblEmail: TLblEmail;
    FEdtEmail: TEdtEmail;
    FLblPhone: TLblPhone;
    FEdtPhone: TEdtPhone;
    FLblPreferences: TLblPreferences;
    FEdtPreferences: TEdtPreferences;
  end;

procedure PopulateEditTravelerForm(View: TEditTravelerView; Traveler: TTraveler);
procedure SaveEditTravelerForm(View: TEditTravelerView; Traveler: TTraveler);

implementation

uses
  Androidapi.Helpers;

procedure PopulateEditTravelerForm(View: TEditTravelerView; Traveler: TTraveler);
var
  EdtName, EdtEmail, EdtPhone, EdtPrefs: JEditText;
begin
  EdtName := JEditText(View.FEdtName.AndroidView);
  EdtEmail := JEditText(View.FEdtEmail.AndroidView);
  EdtPhone := JEditText(View.FEdtPhone.AndroidView);
  EdtPrefs := JEditText(View.FEdtPreferences.AndroidView);

  EdtName.setText(StrToJCharSequence(Traveler.Name), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtEmail.setText(StrToJCharSequence(Traveler.Email), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtPhone.setText(StrToJCharSequence(Traveler.Phone), TJTextView_BufferType.JavaClass.EDITABLE);
  EdtPrefs.setText(StrToJCharSequence(Traveler.Preferences), TJTextView_BufferType.JavaClass.EDITABLE);
end;

procedure SaveEditTravelerForm(View: TEditTravelerView; Traveler: TTraveler);
var
  EdtName, EdtEmail, EdtPhone, EdtPrefs: JEditText;
begin
  EdtName := JEditText(View.FEdtName.AndroidView);
  EdtEmail := JEditText(View.FEdtEmail.AndroidView);
  EdtPhone := JEditText(View.FEdtPhone.AndroidView);
  EdtPrefs := JEditText(View.FEdtPreferences.AndroidView);

  Traveler.Name := JCharSequenceToStr(EdtName.getText);
  Traveler.Email := JCharSequenceToStr(EdtEmail.getText);
  Traveler.Phone := JCharSequenceToStr(EdtPhone.getText);
  Traveler.Preferences := JCharSequenceToStr(EdtPrefs.getText);
end;

end.
