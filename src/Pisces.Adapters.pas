unit Pisces.Adapters;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Widget,
  Androidapi.JNI.GraphicsContentViewText,
  Pisces.Types;

type
  // Adapter that serves already-built TPisces views to a ListView/AdapterView.
  TViewArrayAdapter = class(TJavaLocal, JListAdapter)
  private
    FItems: TArray<TObject>;
  public
    constructor Create(const AItems: TArray<TObject>);

    // Adapter API (JAdapter + JListAdapter)
    function getAutofillOptions: TJavaObjectArray<JCharSequence>; cdecl;
    function areAllItemsEnabled: Boolean; cdecl;
    function isEnabled(position: Integer): Boolean; cdecl;
    function getCount: Integer; cdecl;
    function getItem(position: Integer): JObject; cdecl;
    function getItemId(position: Integer): Int64; cdecl;
    function getItemViewType(position: Integer): Integer; cdecl;
    function getViewTypeCount: Integer; cdecl;
    function hasStableIds: Boolean; cdecl;
    function isEmpty: Boolean; cdecl;
    procedure registerDataSetObserver(observer: JDataSetObserver); cdecl;
    procedure unregisterDataSetObserver(observer: JDataSetObserver); cdecl;
    function getView(position: Integer; convertView: JView; parent: JViewGroup): JView; cdecl;
  end;

implementation

uses
  Androidapi.Helpers, System.SysUtils, Pisces.Base;

constructor TViewArrayAdapter.Create(const AItems: TArray<TObject>);
begin
  inherited Create;
  FItems := AItems;
end;

function TViewArrayAdapter.getAutofillOptions: TJavaObjectArray<JCharSequence>;
begin
  Result := nil;
end;

// Adapter API
function TViewArrayAdapter.areAllItemsEnabled: Boolean;
begin
  Result := True;
end;

function TViewArrayAdapter.isEnabled(position: Integer): Boolean;
begin
  Result := True;
end;

function TViewArrayAdapter.getCount: Integer;
begin
  Result := Length(FItems);
end;

function TViewArrayAdapter.getItem(position: Integer): JObject;
begin
  Result := JObject(TPisces(FItems[position]).AndroidView);
end;

function TViewArrayAdapter.getItemId(position: Integer): Int64;
begin
  Result := position;
end;

function TViewArrayAdapter.getItemViewType(position: Integer): Integer;
begin
  Result := 0;
end;

function TViewArrayAdapter.getViewTypeCount: Integer;
begin
  Result := 1;
end;

function TViewArrayAdapter.hasStableIds: Boolean;
begin
  Result := True;
end;

function TViewArrayAdapter.isEmpty: Boolean;
begin
  Result := getCount = 0;
end;

procedure TViewArrayAdapter.registerDataSetObserver(observer: JDataSetObserver);
begin
end;

procedure TViewArrayAdapter.unregisterDataSetObserver(observer: JDataSetObserver);
begin
end;

function TViewArrayAdapter.getView(position: Integer; convertView: JView; parent: JViewGroup): JView;
var
  V: JView;
  P: JViewParent;
begin
  V := TPisces(FItems[position]).AndroidView;
  if V <> nil then
  begin
    P := V.getParent;
    if Assigned(P) then
      JViewGroup(P).removeView(V); // avoid "view already has a parent"
  end;
  Result := V;
end;

end.
