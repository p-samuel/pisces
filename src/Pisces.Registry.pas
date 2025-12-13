unit Pisces.Registry;

interface

uses
  Pisces.Types,
  System.Generics.Collections;

type
  // Forward declaration for TPisces reference
  TPiscesInstance = TObject;

  TViewRegistrationInfo = record
    ViewName: String;
    ViewGUID: String;
    ViewID: Integer;
    View: JView;
    Instance: TPiscesInstance;  // Reference to the TPisces instance
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

