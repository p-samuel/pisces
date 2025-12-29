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
  Androidapi.JNI.Util,
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

  [JavaSignature('android/widget/ArrayAdapter')]
  JArrayAdapter = interface(JBaseAdapter)
    ['{F1A6C17C-7A9F-41CB-9C8C-2E6D6A29F7A6}']
  end;

  [JavaSignature('android/widget/ArrayAdapter')]
  JArrayAdapterClass = interface(JBaseAdapterClass)
    ['{C2C2B3E8-7E1B-4F5B-9E2A-5E6E5B1E2B86}']
    function init(context: JContext; resource: Integer): JArrayAdapter; cdecl; overload;
    function init(context: JContext; resource: Integer; objects: JList): JArrayAdapter; cdecl; overload;
    function init(context: JContext; resource: Integer; textViewResourceId: Integer; objects: JList): JArrayAdapter; cdecl; overload;
  end;

  TJArrayAdapter = class(TJavaGenericImport<JArrayAdapterClass, JArrayAdapter>) end;

  [JavaSignature('android/widget/CheckedTextView')]
  JCheckedTextView = interface(JTextView)
    ['{9F1A6E6E-6A6F-4B6D-9E7E-4D1F2E07A4D3}']
    function getCheckMarkDrawable: JDrawable; cdecl;
    procedure setCheckMarkTintList(tint: JColorStateList); cdecl;
    procedure setCheckMarkTintMode(mode: JPorterDuff_Mode); cdecl;
  end;

  [JavaSignature('android/widget/CheckedTextView')]
  JCheckedTextViewClass = interface(JTextViewClass)
    ['{2C9C7E25-2B4B-45E6-9E91-2D3B8B77C0D1}']
    {class} function init(context: JContext): JCheckedTextView; cdecl; overload;
    {class} function init(context: JContext; attrs: JAttributeSet): JCheckedTextView; cdecl; overload;
    {class} function init(context: JContext; attrs: JAttributeSet; defStyleAttr: Integer): JCheckedTextView; cdecl; overload;
    {class} function init(context: JContext; attrs: JAttributeSet; defStyleAttr: Integer; defStyleRes: Integer): JCheckedTextView; cdecl; overload;
  end;

  TJCheckedTextView = class(TJavaGenericImport<JCheckedTextViewClass, JCheckedTextView>) end;

  // Animation Interpolators - must be declared before JViewPropertyAnimatorEx
  [JavaSignature('android/animation/TimeInterpolator')]
  JTimeInterpolator = interface(IJavaInstance)
    ['{A1B2C3D4-E5F6-7890-ABCD-EF1234567890}']
    function getInterpolation(input: Single): Single; cdecl;
  end;

  // Extended ViewPropertyAnimator with setInterpolator support
  // (setInterpolator is missing from Delphi's standard JViewPropertyAnimator)
  [JavaSignature('android/view/ViewPropertyAnimator')]
  JViewPropertyAnimatorEx = interface(JObject)
    ['{A0B1C2D3-E4F5-6789-0ABC-DEF123456789}']
    function setInterpolator(interpolator: JTimeInterpolator): JViewPropertyAnimatorEx; cdecl;
  end;

  JViewPropertyAnimatorExClass = interface(JObjectClass)
    ['{B1C2D3E4-F5A6-7890-1BCD-EF2345678901}']
  end;

  TJViewPropertyAnimatorEx = class(TJavaGenericImport<JViewPropertyAnimatorExClass, JViewPropertyAnimatorEx>) end;

  [JavaSignature('android/view/animation/LinearInterpolator')]
  JLinearInterpolator = interface(JTimeInterpolator)
    ['{B2C3D4E5-F6A7-8901-BCDE-F12345678901}']
  end;

  [JavaSignature('android/view/animation/LinearInterpolator')]
  JLinearInterpolatorClass = interface(JObjectClass)
    ['{C3D4E5F6-A7B8-9012-CDEF-123456789012}']
    function init: JLinearInterpolator; cdecl;
  end;

  TJLinearInterpolator = class(TJavaGenericImport<JLinearInterpolatorClass, JLinearInterpolator>) end;

  [JavaSignature('android/view/animation/AccelerateDecelerateInterpolator')]
  JAccelerateDecelerateInterpolator = interface(JTimeInterpolator)
    ['{D4E5F6A7-B8C9-0123-DEF0-234567890123}']
  end;

  [JavaSignature('android/view/animation/AccelerateDecelerateInterpolator')]
  JAccelerateDecelerateInterpolatorClass = interface(JObjectClass)
    ['{E5F6A7B8-C9D0-1234-EF01-345678901234}']
    function init: JAccelerateDecelerateInterpolator; cdecl;
  end;

  TJAccelerateDecelerateInterpolator = class(TJavaGenericImport<JAccelerateDecelerateInterpolatorClass, JAccelerateDecelerateInterpolator>) end;

  [JavaSignature('android/view/animation/AccelerateInterpolator')]
  JAccelerateInterpolator = interface(JTimeInterpolator)
    ['{F6A7B8C9-D0E1-2345-F012-456789012345}']
  end;

  [JavaSignature('android/view/animation/AccelerateInterpolator')]
  JAccelerateInterpolatorClass = interface(JObjectClass)
    ['{A7B8C9D0-E1F2-3456-0123-567890123456}']
    function init: JAccelerateInterpolator; cdecl; overload;
    function init(factor: Single): JAccelerateInterpolator; cdecl; overload;
  end;

  TJAccelerateInterpolator = class(TJavaGenericImport<JAccelerateInterpolatorClass, JAccelerateInterpolator>) end;

  [JavaSignature('android/view/animation/DecelerateInterpolator')]
  JDecelerateInterpolator = interface(JTimeInterpolator)
    ['{B8C9D0E1-F2A3-4567-1234-678901234567}']
  end;

  [JavaSignature('android/view/animation/DecelerateInterpolator')]
  JDecelerateInterpolatorClass = interface(JObjectClass)
    ['{C9D0E1F2-A3B4-5678-2345-789012345678}']
    function init: JDecelerateInterpolator; cdecl; overload;
    function init(factor: Single): JDecelerateInterpolator; cdecl; overload;
  end;

  TJDecelerateInterpolator = class(TJavaGenericImport<JDecelerateInterpolatorClass, JDecelerateInterpolator>) end;

  [JavaSignature('android/view/animation/AnticipateInterpolator')]
  JAnticipateInterpolator = interface(JTimeInterpolator)
    ['{D0E1F2A3-B4C5-6789-3456-890123456789}']
  end;

  [JavaSignature('android/view/animation/AnticipateInterpolator')]
  JAnticipateInterpolatorClass = interface(JObjectClass)
    ['{E1F2A3B4-C5D6-7890-4567-901234567890}']
    function init: JAnticipateInterpolator; cdecl; overload;
    function init(tension: Single): JAnticipateInterpolator; cdecl; overload;
  end;

  TJAnticipateInterpolator = class(TJavaGenericImport<JAnticipateInterpolatorClass, JAnticipateInterpolator>) end;

  [JavaSignature('android/view/animation/OvershootInterpolator')]
  JOvershootInterpolator = interface(JTimeInterpolator)
    ['{F2A3B4C5-D6E7-8901-5678-012345678901}']
  end;

  [JavaSignature('android/view/animation/OvershootInterpolator')]
  JOvershootInterpolatorClass = interface(JObjectClass)
    ['{A3B4C5D6-E7F8-9012-6789-123456789012}']
    function init: JOvershootInterpolator; cdecl; overload;
    function init(tension: Single): JOvershootInterpolator; cdecl; overload;
  end;

  TJOvershootInterpolator = class(TJavaGenericImport<JOvershootInterpolatorClass, JOvershootInterpolator>) end;

  [JavaSignature('android/view/animation/AnticipateOvershootInterpolator')]
  JAnticipateOvershootInterpolator = interface(JTimeInterpolator)
    ['{B4C5D6E7-F8A9-0123-7890-234567890123}']
  end;

  [JavaSignature('android/view/animation/AnticipateOvershootInterpolator')]
  JAnticipateOvershootInterpolatorClass = interface(JObjectClass)
    ['{C5D6E7F8-A9B0-1234-8901-345678901234}']
    function init: JAnticipateOvershootInterpolator; cdecl; overload;
    function init(tension: Single): JAnticipateOvershootInterpolator; cdecl; overload;
    function init(tension: Single; extraTension: Single): JAnticipateOvershootInterpolator; cdecl; overload;
  end;

  TJAnticipateOvershootInterpolator = class(TJavaGenericImport<JAnticipateOvershootInterpolatorClass, JAnticipateOvershootInterpolator>) end;

  [JavaSignature('android/view/animation/BounceInterpolator')]
  JBounceInterpolator = interface(JTimeInterpolator)
    ['{D6E7F8A9-B0C1-2345-9012-456789012345}']
  end;

  [JavaSignature('android/view/animation/BounceInterpolator')]
  JBounceInterpolatorClass = interface(JObjectClass)
    ['{E7F8A9B0-C1D2-3456-0123-567890123456}']
    function init: JBounceInterpolator; cdecl;
  end;

  TJBounceInterpolator = class(TJavaGenericImport<JBounceInterpolatorClass, JBounceInterpolator>) end;

implementation

end.
