unit View.Home;

interface

uses
  Pisces,
  Pisces.ScreenManager;

type
  [ TextView('title'),
    Text(''),
    TextColor(255, 255, 255),
    BackgroundColor(20, 34, 53),
    Height(120),
    TextSize(20),
    Padding(16, 12, 60, 12),
    CornerRadius(50),
    Gravity([TGravity.CenterVertical]),
    ListViewItem(True)
  ] TConstelationTitle = class(TPisces)

  end;

  [ TextView('detail'),
    Text(''),
    TextColor(220, 230, 245),
    FontFamily('monospace'),
    FontWeight(500),
    LetterSpacing(0.05),
    LineHeight(34),
    Padding(16, 8, 16, 0),
    MinLines(2),
    ListViewItem(True),
    Height(80)
  ] TConstelationDetail = class(TPisces)

  end;

  [ LinearLayout('item'),
    Height(300),
    Padding(20, 18, 20, 18),
    BackgroundColor(46, 53, 61),
    RippleColor(244, 244, 244, 0.2),
    Orientation(TOrientation.Vertical),
    ListViewItem(True)
  ] TConstelationItem = class(TPisces)
  private
    FTitle: TConstelationTitle;
    FDetail: TConstelationDetail;
    FCaption: string;
  public
    constructor Create(const ACaption: string); reintroduce;
    procedure AfterInitialize; override;
  end;

  [ ListView('home'),
    BackgroundColor(28, 43, 64),
    Padding(0, 200, 0, 0),
    ItemsCanFocus(False),
    ChoiceMode(TChoiceMode.Multiple),
    AdapterType(TAdapterType.ViewArrayAdapter),
    ItemClass('TConstelationItem'),
    FullScreen(True)
  ] THomeView = class(TPisces)
  public
    procedure AfterShow; override;
    procedure OnItemClickHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64); override;
  end;


var
  HomeView: THomeView;

implementation

{ - Create (TPisces.Create): instantiates the object, reads attributes, sets IDs, creates child dictionary, then calls Initialize.
  - Initialize (TPisces.Initialize): builds the native view, attaches listeners, processes child fields, sets keyboard padding, then calls AfterInitialize.
  - AfterInitialize: post-build hook; Android view and child fields exist even when Show is never called (ListView items).
  - Show (TPisces.Show): adds the view to the Activity via ShowView, then calls AfterShow.
  - AfterShow: runs after ShowView for top-level views; child views also get AfterShow during ProcessFields once they’re created and attached to their parent view.
  - DoShow/DoHide: navigation callbacks triggered by TPscScreenManager.Push/Pop when a screen becomes visible/hidden.
  - OnShow/OnHide: not present in code; the equivalents are DoShow/DoHide. }

uses
  System.SysUtils,
  Androidapi.Helpers,
  Androidapi.JNI.GraphicsContentViewText;

const
  Items: array[0..49] of string = (
    'Andromeda', 'Antlia', 'Apus', 'Aquarius', 'Aquila', 'Ara', 'Aries',
    'Auriga', 'Bootes', 'Caelum', 'Camelopardalis', 'Cancer', 'CanesVenatici',
    'CanisMajor', 'CanisMinor', 'Capricornus', 'Carina', 'Cassiopeia', 'Centaurus',
    'Cepheus', 'Cetus', 'Chamaeleon', 'Circinus', 'Columba', 'ComaBerenices',
    'CoronaAustralis', 'CoronaBorealis', 'Corvus', 'Crater', 'Crux', 'Cygnus',
    'Delphinus', 'Dorado', 'Draco', 'Equuleus', 'Eridanus', 'Fornax', 'Gemini',
    'Grus', 'Hercules', 'Horologium', 'Hydra', 'Hydrus', 'Indus', 'Lacerta',
    'Leo', 'Lepus', 'Libra', 'Lupus', 'Lynx'
  );

{ TConstelationItem }

constructor TConstelationItem.Create(const ACaption: string);
begin
  inherited Create;
  FCaption := ACaption;
end;

//Why AfterInitialize exists (ListView)
//  - List items are created via TPscListView.SetListItems which calls ItemInstance.Initialize directly.
//  - List items are never shown with TPisces.Show, so AfterShow does not run for them.
//  - AfterInitialize is the first safe hook where the Android view and child fields exist for list items. That’s why text binding for list items goes there.

procedure TConstelationItem.AfterInitialize;
begin
  inherited;
  if Assigned(FTitle) and (FTitle.AndroidView <> nil) then
    JTextView(FTitle.AndroidView).setText(TAndroidHelper.StrToJCharSequence(FCaption));
  if Assigned(FDetail) and (FDetail.AndroidView <> nil) then
    JTextView(FDetail.AndroidView).setText(TAndroidHelper.StrToJCharSequence(
      Format('name = "%s"; hemi = "N";' + #13#10 +
             'best = "Oct"; type = "constellation";', [FCaption])
    ));
end;

{ THomeView }

procedure THomeView.AfterShow;
var
  ItemList: TArray<String>;
  I: Integer;
begin
  inherited;
  SetLength(ItemList, Length(Items));
  for I := Low(Items) to High(Items) do
    ItemList[I] := Items[I];
  SetListItems(ItemList);
end;

procedure THomeView.OnItemClickHandler(AParent: JAdapterView; AView: JView; APosition: Integer; AId: Int64);
begin
  inherited;
  TPscUtils.Log(Format('Item clicked: %s', [Items[APosition]]), 'OnItemClickHandler', TLogger.Info, Self);
end;

initialization
  HomeView := THomeView.Create;
  HomeView.Show;
  TPscScreenManager.Instance.SetInitialScreenByName('home');

finalization
  HomeView.Free;
end.
