unit View.Popup;

interface

uses
  Pisces;

type

  [ TextView('menutext'),
    Text('This is a popup view example'),
    TextColor(255, 255, 255),
    TextSize(16),
    Padding(16, 16, 16, 16)
  ] TText = class(TPisces)

  end;

  [ LinearLayout('menu'),
    Orientation(TOrientation.Vertical),
    BackgroundColor(255, 124, 23),
    Width(TLayout.MATCH),
    Height(TLayout.MATCH),
    Padding(16, 16, 16, 16)
  ] TViewPopup = class(TPisces)
    FText: TText;
  public
    constructor Create; override;
  end;

var
  ViewPopup: TViewPopup;

implementation

{ TViewPopup }

constructor TViewPopup.Create;
begin
  if not Assigned(ViewPopup) then
    ViewPopup := Self;
  inherited;
end;

initialization
  ViewPopup := TViewPopup.Create;
  ViewPopup.ShowAndHide;

finalization
  ViewPopup.Free;

end.
