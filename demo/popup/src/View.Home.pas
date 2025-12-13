unit View.Home;

interface

uses
  Pisces;

type

  TPopupPosition = (ppTopLeft, ppTopRight, ppBottomLeft, ppBottomRight, ppCenter, ppTop, ppBottom);

  [ LinearLayout('menu'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 124, 23),
    Width(TLayout.MATCH),
    Height(TLayout.MATCH),
    Padding(16, 16, 16, 16)
  ] TViewPopup = class(TPisces)
    constructor Create; override;
  end;

  [ SwitchButton('btn'),
    Width(200),
    BackgroundColor(244, 244, 244, 0.1)
  ] TSwitch = class(TPisces)

  end;

  [ TextView('btn-text'),
    Text('Top Left'),
    TextColor(255, 255, 255),
    TextSize(16),
    Padding(16, 16, 16, 16),
    BackgroundColor(0, 0, 0, 0.05),
    RippleColor(244, 244, 244, 0.1),
    Gravity([TGravity.Left, TGravity.CenterVertical])
  ] TText = class(TPisces)
  private
    FPosition: TPopupPosition;
  public
    procedure Click(AView: JView);
    constructor Create; override;
    property PopupPosition: TPopupPosition read FPosition write FPosition;
  end;

  [ LinearLayout('btncontainer'),
    Gravity([TGravity.Left, TGravity.CenterVertical]),
    Orientation(TOrientation.Horizontal),
    BackgroundColor(244, 244, 244, 0.2),
    Height(120)
  ] TBtnContainer = class(TPisces)
    FSwitch: TSwitch;
    FText: TText;
  end;

  [ LinearLayout('home'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(0, 76, 63),
    Gravity([TGravity.Center]),
    FullScreen(True),
    DarkStatusBarIcons(False)
  ] THomeView = class(TPisces)
    FMode1: TBtnContainer;
    FMode2: TBtnContainer;
    FMode3: TBtnContainer;
    FMode4: TBtnContainer;
    FMode5: TBtnContainer;
    FMode6: TBtnContainer;
    FMode7: TBtnContainer;
    FDropDownEnabled: TBtnContainer;
  private
    procedure SetPopupPosition(APosition: TPopupPosition);
    procedure ShowPopUp(APosition: TPopupPosition);
  public
    procedure AfterCreate; override;
  end;

var
  ViewHome: THomeView;
  ViewPopup: TViewPopup;

implementation

uses
  Androidapi.Helpers;

{ TViewPopup }

constructor TViewPopup.Create;
begin
  if not Assigned(ViewPopup) then
    ViewPopup := Self;
  inherited;
end;

{ THomeView }

procedure THomeView.AfterCreate;
begin
  inherited;
  JTextView(FMode1.FText.AndroidView).setText(StrToJCharSequence('Top Left'));
  JTextView(FMode2.FText.AndroidView).setText(StrToJCharSequence('Top Right'));
  JTextView(FMode3.FText.AndroidView).setText(StrToJCharSequence('Bottom Left'));
  JTextView(FMode4.FText.AndroidView).setText(StrToJCharSequence('Bottom Right'));
  JTextView(FMode5.FText.AndroidView).setText(StrToJCharSequence('Center'));
  JTextView(FMode6.FText.AndroidView).setText(StrToJCharSequence('Top'));
  JTextView(FMode7.FText.AndroidView).setText(StrToJCharSequence('Bottom'));
  JTextView(FDropDownEnabled.FText.AndroidView).setText(StrToJCharSequence('Show as Dropdown'));

  FMode1.FText.PopupPosition := ppTopLeft;
  FMode2.FText.PopupPosition := ppTopRight;
  FMode3.FText.PopupPosition := ppBottomLeft;
  FMode4.FText.PopupPosition := ppBottomRight;
  FMode5.FText.PopupPosition := ppCenter;
  FMode6.FText.PopupPosition := ppTop;
  FMode7.FText.PopupPosition := ppBottom;

end;

procedure THomeView.SetPopupPosition(APosition: TPopupPosition);
begin
  JSwitch(FMode1.FSwitch.AndroidView).setChecked(APosition = FMode1.FText.PopupPosition);
  JSwitch(FMode2.FSwitch.AndroidView).setChecked(APosition = FMode2.FText.PopupPosition);
  JSwitch(FMode3.FSwitch.AndroidView).setChecked(APosition = FMode3.FText.PopupPosition);
  JSwitch(FMode4.FSwitch.AndroidView).setChecked(APosition = FMode4.FText.PopupPosition);
  JSwitch(FMode5.FSwitch.AndroidView).setChecked(APosition = FMode5.FText.PopupPosition);
  JSwitch(FMode6.FSwitch.AndroidView).setChecked(APosition = FMode6.FText.PopupPosition);
  JSwitch(FMode7.FSwitch.AndroidView).setChecked(APosition = FMode7.FText.PopupPosition);;
end;

procedure THomeView.ShowPopUp(APosition: TPopupPosition);
var
  Position: Integer;
begin

  SetPopupPosition(APosition);

  Position := 0;
  case APosition of
    ppTopLeft: Position := TJGravity.JavaClass.TOP or TJGravity.JavaClass.LEFT;
    ppTopRight: Position := TJGravity.JavaClass.TOP or TJGravity.JavaClass.RIGHT;
    ppBottomLeft: Position := TJGravity.JavaClass.BOTTOM or TJGravity.JavaClass.LEFT;
    ppBottomRight: Position := TJGravity.JavaClass.BOTTOM or TJGravity.JavaClass.RIGHT;
    ppCenter: Position := TJGravity.JavaClass.CENTER;
    ppTop: Position := TJGravity.JavaClass.TOP;
    ppBottom: Position := TJGravity.JavaClass.BOTTOM;
  end;

  ViewPopup.Visible := True;

  if JSwitch(FDropDownEnabled.FSwitch.AndroidView).isChecked then
    TPscUtils.PopupWindow
      .Content(ViewPopup.AndroidView)
      .Width(400)
      .Height(700)
      .Focusable(True)
      .OnDismiss(procedure begin
        TPscUtils.Toast('Popup Dismissed', TJToast.JavaClass.LENGTH_SHORT);
        ViewPopup.Visible := False;
      end)
      .ShowAsDropDown(AndroidView, 0, 0, Position)
  else
    TPscUtils.PopupWindow
      .Content(ViewPopup.AndroidView)
      .Width(400)
      .Height(700)
      .Focusable(True)
      .OnDismiss(procedure begin
        TPscUtils.Toast('Popup Dismissed', TJToast.JavaClass.LENGTH_SHORT);
        ViewPopup.Visible := False;
      end)
      .ShowAtLocation(AndroidView, Position, 0, 0)
end;

{ TText }

procedure TText.Click(AView: JView);
begin
  ViewHome.ShowPopUp(FPosition)
end;

constructor TText.Create;
begin
  OnClick := Click;
  inherited;
end;

initialization
  ViewHome  := THomeView.Create;
  ViewPopup := TViewPopup.Create;
  ViewPopup.ShowAndHide;
  ViewHome.Show;

finalization
  ViewHome.Free;
  ViewPopup.Free;

end.
