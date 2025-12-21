unit Pisces.JNI.Extensions;


// +==============================================================+
// | WARNING: CUSTOM JNI EXTENSIONS                               |
// | These JNI bindings are custom additions for Pisces to cover  |
// | APIs missing from Delphi headers. This unit does NOT include |
// | or redistribute any Embarcadero-provided sources.            |
// +==============================================================+

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes;

type

  [JavaSignature('android/view/WindowInsets$Type')]
  JWindowInsets_Type = interface(JObject)
    ['{F8A10F2F-28D6-4B1B-9F10-AB0AF42E6E31}']
  end;

  [JavaSignature('android/view/WindowInsets$Type')]
  JWindowInsets_TypeClass = interface(JObjectClass)
    ['{E8E9C7C6-6CC6-4B3C-9B4C-CEAA0C3A9E9D}']
    function ime: Integer; cdecl;
  end;

  TJWindowInsets_Type = class(TJavaGenericImport<JWindowInsets_TypeClass, JWindowInsets_Type>) end;

implementation

end.
