unit Pisces.Logger;

interface

uses
  System.SysUtils,
  Androidapi.Log,
  Pisces.Types;

type
  TPscLogger = class
    class procedure Log(Msg, MethodName: String; LogType: TLogger; const ClassInstanceName: String); overload;
    class procedure Log(Msg, MethodName: String; LogType: TLogger; const ClassInstance: TObject); overload;
  end;

implementation

uses
  Pisces.Utils, System.Rtti;

{ TPscLogger }

class procedure TPscLogger.Log(Msg, MethodName: String; LogType: TLogger; const ClassInstance: TObject);
var
  Context: TRttiContext;
  RttiType: TRttiType;
  ClassName, FullMsg, ColorCode: string;
begin
  // If you are using Android Studio, you can fetch logs using logcat via the terminal
  // We can combine ascii escape sequences to log messages and write colored based strings for different types of severity
  // 1 - adb devices (Find your device in the device list)
  // 2 - adb -s <your-device-name> logcat | grep -e "com.embarcadero*" -e "another-string" -e "yet-another-string" etc...

  Context := TRttiContext.Create;
  try
    if Assigned(ClassInstance) then begin
      RttiType := Context.GetType(ClassInstance.ClassType);
      ClassName := RttiType.Name;
    end else
      ClassName := '[Unkown class]';

    // Determine the color code based on the log type using ascii sequences.
    case LogType of
      TLogger.Info: ColorCode := #27'[32m';    // Green
      TLogger.Error: ColorCode := #27'[31m';   // Red
      TLogger.Warning: ColorCode := #27'[33m'; // Yellow
      TLogger.Fatal: ColorCode := #27'[35m';   // Magenta
    else
      ColorCode := #27'[0m';                   // Default
    end;

    FullMsg := Format('%s %s: %s.%s %s' + #27'[0m', [ColorCode, TPscUtils.GetPackageName, ClassName, MethodName, Msg]);

    // Log the message with the appropriate color and ascii sequence to be processed by the terminal
    case LogType of
      TLogger.Info: LOGI(MarshaledAString(AnsiString(FullMsg)));
      TLogger.Error: LOGE(MarshaledAString(AnsiString(FullMsg)));
      TLogger.Warning: LOGW(MarshaledAString(AnsiString(FullMsg)));
      TLogger.Fatal: LOGF(MarshaledAString(AnsiString(FullMsg)));
    end;

  finally
    Context.Free;
  end;
end;

class procedure TPscLogger.Log(Msg, MethodName: String; LogType: TLogger; const ClassInstanceName: String);
var
  FullMsg, ColorCode: string;
begin
  // Determine the color code based on the log type using ascii sequences.
  case LogType of
    TLogger.Info: ColorCode := #27'[32m';    // Green
    TLogger.Error: ColorCode := #27'[31m';   // Red
    TLogger.Warning: ColorCode := #27'[33m'; // Yellow
    TLogger.Fatal: ColorCode := #27'[35m';   // Magenta
  else
    ColorCode := #27'[0m';                   // Default
  end;

  FullMsg := Format('%s %s: %s.%s %s' + #27'[0m', [ColorCode, TPscUtils.GetPackageName, ClassInstanceName, MethodName, Msg]);

  // Log the message with the appropriate color and ascii sequence to be processed by the terminal
  case LogType of
    TLogger.Info: LOGI(MarshaledAString(AnsiString(FullMsg)));
    TLogger.Error: LOGE(MarshaledAString(AnsiString(FullMsg)));
    TLogger.Warning: LOGW(MarshaledAString(AnsiString(FullMsg)));
    TLogger.Fatal: LOGF(MarshaledAString(AnsiString(FullMsg)));
  end;
end;

end.
