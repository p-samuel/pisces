unit Pisces.Registry;

interface

uses
  Pisces.Types,
  System.Generics.Collections;

type
  TViewRegistrationInfo = record
    ViewName: String;
    ViewGUID: String;
    ViewID: Integer;
    View: JView;
  end;

var
  ViewsRegistry: TDictionary<String, TViewRegistrationInfo>;

implementation

initialization
  ViewsRegistry := TDictionary<String, TViewRegistrationInfo>.Create([]);

finalization
  ViewsRegistry.Clear;
  ViewsRegistry.Free;


end.

