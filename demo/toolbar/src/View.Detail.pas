unit View.Detail;

interface

uses
  Pisces, View.Toolbar;

type

  [ TextView('detailContent'),
    Text('This is the Detail screen. Use the back button in the toolbar to return to the Home screen.'),
    TextColor(60, 60, 60),
    TextSize(18),
    Padding(32, 32, 32, 32),
    Gravity([TGravity.Center])
  ] TDetailContent = class(TPisces)
  end;

  [ LinearLayout('detailContainer'),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Top])
  ] TDetailContainer = class(TPisces)
    FToolbar: TToolbarHeader;
    FContent: TDetailContent;
  end;

  [ FrameLayout('detail'),
    FullScreen(True),
    BackgroundColor(243, 229, 245),
    DarkStatusBarIcons(False),
    StatusBarColor(123, 31, 162)
  ] TViewDetail = class(TPisces)
    FContainer: TDetailContainer;
  public
    procedure DoShow; override;
  end;

var
  ViewDetail: TViewDetail;

implementation

uses
  Pisces.ScreenManager;

{ TViewDetail }

procedure TViewDetail.DoShow;
begin
  inherited;
  if Assigned(FContainer) and Assigned(FContainer.FToolbar) then begin
    FContainer.FToolbar.SetTitle('Details');
    FContainer.FToolbar.ShowBackButton;
  end;
end;

initialization
  ViewDetail := TViewDetail.Create;
  ViewDetail.ShowAndHide;

finalization
  ViewDetail.Free;

end.
