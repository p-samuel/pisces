unit Pisces.App;

interface

uses
  Androidapi.JNI.App,
  Androidapi.JNI.GraphicsContentViewText,
  Pisces.Lifecycle;

type
  TPiscesApplication = class
  private
    class var FLifecycleManager: TPscLifecycleManager;
    class var FInitialized: Boolean;
  public
    class procedure Initialize;
    class procedure Finalize;
    class function GetLifecycleManager: TPscLifecycleManager;
    class property IsInitialized: Boolean read FInitialized;
  end;

implementation

uses
  Androidapi.Helpers,
  FMX.Helpers.Android,
  Pisces.Utils, Pisces.Types, System.SysUtils;

class procedure TPiscesApplication.Initialize;
begin
  if not FInitialized then
  begin
    TPscUtils.Log('Initializing Pisces Application', 'PiscesApp', TLogger.Info, nil);

    try
      FLifecycleManager := TPscLifecycleManager.Create;
      FLifecycleManager.RegisterLifecycleCallbacks;
      FInitialized := True;
      TPscUtils.Log('Lifecycle manager initialized and registered successfully', 'PiscesApp', TLogger.Info, 'TPiscesApplication');
    except
      on E: Exception do
      begin
        TPscUtils.Log('Failed to initialize Pisces Application: ' + E.Message, 'PiscesApp', TLogger.Error, 'TPiscesApplication');
        if Assigned(FLifecycleManager) then
        begin
          FLifecycleManager.Free;
          FLifecycleManager := nil;
        end;
      end;
    end;
  end else begin
    TPscUtils.Log('Pisces Application already initialized', 'PiscesApp', TLogger.Info, nil);
  end;
end;

class procedure TPiscesApplication.Finalize;
begin
  if FInitialized then
  begin
    TPscUtils.Log('Finalizing Pisces Application', 'PiscesApp', TLogger.Info, 'TPiscesApplication');

    if Assigned(FLifecycleManager) then
    begin
      FLifecycleManager.Free;
      FLifecycleManager := nil;
    end;

    FInitialized := False;
    TPscUtils.Log('Pisces Application finalized', 'PiscesApp', TLogger.Info, 'TPiscesApplication');
  end;
end;

class function TPiscesApplication.GetLifecycleManager: TPscLifecycleManager;
begin
  // This will auto-initialize if not created
  if not FInitialized then
    Initialize;
  Result := FLifecycleManager;
end;

initialization
  TPiscesApplication.Initialize;

finalization
  TPiscesApplication.Finalize;

end.

