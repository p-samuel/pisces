unit View.Toolbar;

interface

uses
  Pisces,
  Androidapi.JNI.Widget;

type
  [ ToolBar('toolbarheader'),
    Title('Toolbar Demo'),
    RippleColor(233, 233, 233, 0.2),
    TitleTextColor(255, 255, 255),
    SubtitleTextColor(200, 200, 200),
    BackgroundColor(33, 150, 243),
    Padding(0, 80, 30, 0),
    Height(220),
    Gravity([TGravity.Bottom])
  ] TToolbarHeader = class(TPisces)
  private
    procedure BackPressed(AView: JView);
    procedure LongClick(AView: JView);
  public
    constructor Create; override;
    procedure DoShow; override;
    procedure DoHide; override;
    procedure SetTitle(const ATitle: String);
    procedure SetSubtitle(const ASubtitle: String);
    procedure ShowBackButton;
    procedure HideBackButton;
  end;

var
  ToolbarHeader: TToolbarHeader;

implementation

uses
  Androidapi.Helpers,
  System.SysUtils,
  Pisces.ScreenManager,
  View.Popup;

{ TToolbarHeader }

constructor TToolbarHeader.Create;
begin
  OnBackPressed := BackPressed;
  OnLongClick := LongClick;

  if not Assigned(ToolbarHeader) then begin
    ToolbarHeader := Self;
    TPscUtils.Log('Toolbar header instance assigned', 'Create', TLogger.Info, Self);
  end;
  inherited;
end;

procedure TToolbarHeader.BackPressed(AView: JView);
begin
  TPscScreenManager.Instance.Pop;
end;

procedure TToolbarHeader.SetTitle(const ATitle: String);
begin
  if Assigned(AndroidView) then
    JToolbar(AndroidView).setTitle(StrToJCharSequence(ATitle));
end;

procedure TToolbarHeader.SetSubtitle(const ASubtitle: String);
begin
  if Assigned(AndroidView) then
    JToolbar(AndroidView).setSubtitle(StrToJCharSequence(ASubtitle));
end;

procedure TToolbarHeader.ShowBackButton;
var
  ResId: Integer;
begin
  if Assigned(AndroidView) then
  begin
    ResId := TPscUtils.FindResourceId('ic_menu_back', 'drawable');
    JToolbar(AndroidView).setNavigationIcon(ResId);
  end;
end;

procedure TToolbarHeader.HideBackButton;
begin
  if Assigned(AndroidView) then
    JToolbar(AndroidView).setNavigationIcon(nil);
end;

procedure TToolbarHeader.LongClick(AView: JView);
begin
  ViewPopup.Visible := True;
  TPscUtils.PopupWindow
    .Content(ViewPopup.AndroidView)
    .Width(300)
    .Height(700)
    .Focusable(True)
    .OnDismiss(procedure begin
      TPscUtils.Toast('Dismissed waited', TJToast.JavaClass.LENGTH_SHORT);
      ViewPopup.Visible := False;
    end)
    .ShowAsDropDown(AndroidView, 0, 0, TJGravity.JavaClass.RIGHT or TJGravity.JavaClass.TOP)
end;

procedure TToolbarHeader.DoHide;
begin
  inherited;
  TPscUtils.Log('Toolbar is now hidden!', 'DoHide', TLogger.Info, Self);
end;

procedure TToolbarHeader.DoShow;
begin
  inherited;
  TPscUtils.Log('Toolbar is now visible!', 'DoShow', TLogger.Info, Self);
end;

end.
