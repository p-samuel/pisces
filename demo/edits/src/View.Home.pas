unit View.Home;

interface

uses
  Pisces;

type
  [ TextView('tvHeader'),
    Text('Edit Input Types Demo'),
    TextColor(255, 255, 255),
    TextSize(24),
    Gravity([TGravity.Center]),
    Padding(16, 32, 16, 24),
    Height(600)
  ] THeaderText = class(TPisces)
  end;

  [ Edit('edtText'),
    Hint('Text - Normal text input'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 200, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.Text)
  ] TTextEdit = class(TPisces)
    procedure OnTextChangedHandler(AText: String); override;
    procedure OnTextChangingHandler(AText: String; AStart, ABefore, ACount: Integer); override;
    procedure OnBeforeTextChangedHandler(AText: String; AStart, ACount, AAfter: Integer); override;
  end;

  [ Edit('edtNumber'),
    Hint('Number - Numeric input'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(200, 255, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.Number)
  ] TNumberEdit = class(TPisces)
  end;

  [ Edit('edtPhone'),
    Hint('Phone - Phone number'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(200, 200, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.Phone)
  ] TPhoneEdit = class(TPisces)
  end;

  [ Edit('edtTextEmail'),
    Hint('TextEmailAddress - Email input'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 255, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextEmailAddress)
  ] TTextEmailEdit = class(TPisces)
  end;

  [ Edit('edtTextPassword'),
    Hint('TextPassword - Password input'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 200, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextPassword)
  ] TTextPasswordEdit = class(TPisces)
  end;

  [ Edit('edtTextVisiblePassword'),
    Hint('TextVisiblePassword - Visible password'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(200, 255, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextVisiblePassword)
  ] TTextVisiblePasswordEdit = class(TPisces)
  end;

  [ Edit('edtTextWebEmail'),
    Hint('TextWebEmailAddress - Web email'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 220, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextWebEmailAddress)
  ] TTextWebEmailEdit = class(TPisces)
  end;

  [ Edit('edtTextWebPassword'),
    Hint('TextWebPassword - Web password'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(220, 255, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextWebPassword)
  ] TTextWebPasswordEdit = class(TPisces)
  end;

  [ Edit('edtTextUri'),
    Hint('TextUri - URI/URL input'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(200, 220, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextUri)
  ] TTextUriEdit = class(TPisces)
  end;

  [ Edit('edtTextPersonName'),
    Hint('TextPersonName - Person name'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 200, 220, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextPersonName)
  ] TTextPersonNameEdit = class(TPisces)
  end;

  [ Edit('edtTextPostalAddress'),
    Hint('TextPostalAddress - Postal address'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(220, 200, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.TextPostalAddress)
  ] TTextPostalAddressEdit = class(TPisces)
  end;

  [ Edit('edtTextMultiLine'),
    Hint('TextMultiLine - Multiple lines'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(200, 255, 220, 200),
    Height(140),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.Top]),
    MinLines(3),
    InputType(TInputType.TextMultiLine)
  ] TTextMultiLineEdit = class(TPisces)
  end;

  [ Edit('edtNumberDecimal'),
    Hint('NumberDecimal - Decimal number'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 220, 220, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.NumberDecimal)
  ] TNumberDecimalEdit = class(TPisces)
  end;

  [ Edit('edtNumberSigned'),
    Hint('NumberSigned - Signed number'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(220, 255, 220, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.NumberSigned)
  ] TNumberSignedEdit = class(TPisces)
  end;

  [ Edit('edtNumberPassword'),
    Hint('NumberPassword - Numeric password'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(220, 220, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.NumberPassword)
  ] TNumberPasswordEdit = class(TPisces)
  end;

  [ Edit('edtDateTime'),
    Hint('DateTime - Date and time'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(255, 240, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.DateTime)
  ] TDateTimeEdit = class(TPisces)
  end;

  [ Edit('edtDate'),
    Hint('Date - Date only'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(240, 255, 200, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.Date)
  ] TDateEdit = class(TPisces)
  end;

  [ Edit('edtTime'),
    Hint('Time - Time only'),
    HintTextColor(180, 180, 180),
    TextColor(255, 255, 255),
    TextSize(13),
    BackgroundColor(200, 240, 255, 200),
    Height(110),
    Padding(16, 12, 16, 12),
    Gravity([TGravity.CenterVertical]),
    InputType(TInputType.Time)
  ] TTimeEdit = class(TPisces)
  end;

  [ LinearLayout('editContainer'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.CenterHorizontal])
  ] TEditContainer = class(TPisces)
    FHeaderText: THeaderText;
    FTextEdit: TTextEdit;
    FNumberEdit: TNumberEdit;
    FPhoneEdit: TPhoneEdit;
    FTextEmailEdit: TTextEmailEdit;
    FTextPasswordEdit: TTextPasswordEdit;
    FTextVisiblePasswordEdit: TTextVisiblePasswordEdit;
    FTextWebEmailEdit: TTextWebEmailEdit;
    FTextWebPasswordEdit: TTextWebPasswordEdit;
    FTextUriEdit: TTextUriEdit;
    FTextPersonNameEdit: TTextPersonNameEdit;
    FTextPostalAddressEdit: TTextPostalAddressEdit;
    FTextMultiLineEdit: TTextMultiLineEdit;
    FNumberDecimalEdit: TNumberDecimalEdit;
    FNumberSignedEdit: TNumberSignedEdit;
    FNumberPasswordEdit: TNumberPasswordEdit;
    FDateTimeEdit: TDateTimeEdit;
    FDateEdit: TDateEdit;
    FTimeEdit: TTimeEdit;
  end;

  [ ScrollView('scrollContainer'),
    BackgroundColor(0, 0, 0),
    FullScreen(True)
  ] TScrollContainer = class(TPisces)
    FEditContainer: TEditContainer;
  end;

  [ FrameLayout('home'),
    BackgroundColor(0, 0, 0),
    DarkStatusBarIcons(False),
    FullScreen(True)
  ] THomeView = class(TPisces)
    FScrollContainer: TScrollContainer;
  end;

var
  HomeView: THomeView;

implementation

{ TTextEdit }

procedure TTextEdit.OnTextChangedHandler(AText: String);
begin
  TPscUtils.Log('After text changed: ' + AText, 'OnTextChanged', TLogger.Info, Self);
end;

procedure TTextEdit.OnTextChangingHandler(AText: String; AStart, ABefore, ACount: Integer);
begin
  TPscUtils.Log('Text: ' + AText, 'OnTextChanging', TLogger.Info, Self);
end;

procedure TTextEdit.OnBeforeTextChangedHandler(AText: String; AStart, ACount, AAfter: Integer);
begin
  TPscUtils.Log('Text: ' + AText, 'OnBeforeTextChanged', TLogger.Info, Self);
end;

initialization
  HomeView := THomeView.Create;
  HomeView.Show;

finalization
  HomeView.Free;

end.
