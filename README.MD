<div align="center">
    <img src="./pisces.jpg" width="40%">
</div>

## Pisces - 双鱼座
Pisces is a set of classes to provide rapid access for Android Widgets JNIs (<code>Android.JNI.Widget</code>). It serves a few list of attributes to build native Android views (JView) using simple pascal classes only. Read introduction notes [here](https://github.com/p-samuel/pisces/wiki/%E2%99%93-Introduction).

```pascal
uses
  Pisces;

type
  [ LinearLayout('screen'),
    BackgroundColor(107, 174, 200),
    FullScreen(True),
    DarkStatusBarIcons(False),
    Orientation(TOrientation.Vertical),
    Gravity([TGravity.Center])
  ] TScreen = class(TPisces)
  private 
  
  end;
```

## Target

<img src="https://img.shields.io/badge/Delphi%20-12%2B%20-blue"></img>
<img src="https://img.shields.io/badge/Android-x64-green"></img>

## Notes 
- ⚠️ In development
- Not a production-ready libray, it's just a proof of concept.
- Not a cross-platform library, it only works on Android.
- Not taked into account the many versions of Android and the different versions of the Android SDK. It assumes the latest version being [Android 14 with the Android SDK API level 34](https://www.embarcadero.com/products/rad-studio/whats-new-in-12-athens).

____


###### Art By @Macrovector from Freepik

