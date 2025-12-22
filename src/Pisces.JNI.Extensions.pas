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
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.GraphicsContentViewText,
  Androidapi.JNI.Widget;

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

  [JavaSignature('android/widget/HorizontalScrollView')]
  JHorizontalScrollView = interface(JFrameLayout)
    ['{9B2C7C7D-9B2A-4A0D-9A9E-DB6E4F3E8C91}']
    function isFillViewport: Boolean; cdecl;
    procedure setFillViewport(fillViewport: Boolean); cdecl;
    procedure setSmoothScrollingEnabled(smoothScrollingEnabled: Boolean); cdecl;
    procedure setEdgeEffectColor(color: Integer); cdecl;
    function getLeftEdgeEffectColor: Integer; cdecl;
    function getRightEdgeEffectColor: Integer; cdecl;
    procedure setLeftEdgeEffectColor(color: Integer); cdecl;
    procedure setRightEdgeEffectColor(color: Integer); cdecl;
  end;

  [JavaSignature('android/widget/HorizontalScrollView')]
  JHorizontalScrollViewClass = interface(JFrameLayoutClass)
    ['{1E0C7060-7E5E-4B4F-A7E3-1A7B6B1E97F1}']
    function init(context: JContext): JHorizontalScrollView; cdecl;
  end;

  TJHorizontalScrollView = class(TJavaGenericImport<JHorizontalScrollViewClass, JHorizontalScrollView>) end;

implementation

end.
