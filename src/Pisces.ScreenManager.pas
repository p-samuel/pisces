unit Pisces.ScreenManager;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Androidapi.JNI.GraphicsContentViewText,
  Pisces.Types,
  Pisces.Registry,
  Pisces.Utils,
  Pisces.Base;

type

  TPscScreenManager = class
  private
    class var FInstance: TPscScreenManager;
    // Stack of screen GUIDs
    var FScreenStack: TStack<String>;
    var FCurrentScreenGUID: String;
    constructor Create;

  private
    function FindScreenGUIDByName(const ScreenName: String): String;

  public
    class function Instance: TPscScreenManager;
    class destructor Destroy;
    destructor Destroy; override;

    // Simple navigation API - uses ViewsRegistry to find screens
    procedure SetInitialScreen(const ScreenGUID: String);
    procedure SetInitialScreenByName(const ScreenName: String);
    procedure Push(const ScreenGUID: String);
    procedure PushByName(const ScreenName: String);
    procedure Pop;
    procedure PopToRoot;

    property CurrentScreenGUID: String read FCurrentScreenGUID;
  end;

implementation

{ TPscScreenManager }

constructor TPscScreenManager.Create;
begin
  inherited Create;
  FScreenStack := TStack<String>.Create;
  FCurrentScreenGUID := '';
end;

destructor TPscScreenManager.Destroy;
begin
  if Assigned(FScreenStack) then
    FScreenStack.Free;
  inherited;
end;

class destructor TPscScreenManager.Destroy;
begin
  if Assigned(FInstance) then
    FInstance.Free;
end;

class function TPscScreenManager.Instance: TPscScreenManager;
begin
  if not Assigned(FInstance) then
    FInstance := TPscScreenManager.Create;
  Result := FInstance;
end;

procedure TPscScreenManager.Push(const ScreenGUID: String);
var
  CurrentView, NewView: JView;
  RegInfo, NewRegInfo: TViewRegistrationInfo;
  CurrentInstance, NewInstance: TPisces;
begin
  TPscUtils.Log(Format('Pushing screen with GUID: %s', [ScreenGUID]), 'Push', TLogger.Info, 'TPscScreenManager');

  // Check if screen exists in registry
  if not ViewsRegistry.TryGetValue(ScreenGUID, NewRegInfo) then begin
    TPscUtils.Log(Format('Screen GUID not found in registry: %s', [ScreenGUID]), 'Push', TLogger.Error, 'TPscScreenManager');
    Exit;
  end;

  NewView := NewRegInfo.View;
  NewInstance := TPisces(NewRegInfo.Instance);
  TPscUtils.Log(Format('Found screen: %s', [NewRegInfo.ViewName]), 'Push', TLogger.Info, 'TPscScreenManager');

  // Hide current screen if exists
  if FCurrentScreenGUID <> '' then begin
    TPscUtils.Log(Format('Hiding current screen: %s', [FCurrentScreenGUID]), 'Push', TLogger.Info, 'TPscScreenManager');
    if ViewsRegistry.TryGetValue(FCurrentScreenGUID, RegInfo) then begin
      CurrentView := RegInfo.View;
      CurrentInstance := TPisces(RegInfo.Instance);
      TPscUtils.Log(Format('Current screen name: %s', [RegInfo.ViewName]), 'Push', TLogger.Info, 'TPscScreenManager');

      // Call DoHide lifecycle method on current screen
      if Assigned(CurrentInstance) then
        CurrentInstance.DoHide;

      CurrentView.setVisibility(TJView.JavaClass.GONE);
      TPscUtils.Log('Current screen hidden', 'Push', TLogger.Info, 'TPscScreenManager');
    end;
  end;

  // Push to stack
  if FCurrentScreenGUID <> '' then
    FScreenStack.Push(FCurrentScreenGUID);

  FCurrentScreenGUID := ScreenGUID;

  // Show new screen with fade transition
  TPscUtils.Log('Setting new screen visible', 'Push', TLogger.Info, 'TPscScreenManager');
  NewView.setAlpha(0);
  NewView.setVisibility(TJView.JavaClass.VISIBLE);
  NewView.bringToFront;
  NewView.animate
    .alpha(1)
    .setDuration(300)
    .start;

  // Call DoShow lifecycle method on new screen
  if Assigned(NewInstance) then
    NewInstance.DoShow;

  TPscUtils.Log('Screen pushed successfully', 'Push', TLogger.Info, 'TPscScreenManager');
end;

procedure TPscScreenManager.Pop;
var
  CurrentView, PreviousView: JView;
  PreviousGUID: String;
  RegInfo, PreviousRegInfo: TViewRegistrationInfo;
  CurrentInstance, PreviousInstance: TPisces;
begin
  if FScreenStack.Count = 0 then
  begin
    TPscUtils.Log('Cannot pop - stack is empty', 'Pop', TLogger.Warning, 'TPscScreenManager');
    Exit;
  end;

  TPscUtils.Log('Popping current screen', 'Pop', TLogger.Info, 'TPscScreenManager');

  // Get previous screen from stack
  PreviousGUID := FScreenStack.Pop;

  // Hide current screen
  if ViewsRegistry.TryGetValue(FCurrentScreenGUID, RegInfo) then
  begin
    CurrentView := RegInfo.View;
    CurrentInstance := TPisces(RegInfo.Instance);

    // Call DoHide lifecycle method on current screen
    if Assigned(CurrentInstance) then
      CurrentInstance.DoHide;

    CurrentView.animate
      .alpha(0)
      .setDuration(300)
      .withEndAction(TPscUtils.Runnable(CurrentView,
        procedure(AView: JView)
        begin
          AView.setVisibility(TJView.JavaClass.GONE);
        end))
      .start;
  end;

  // Show previous screen
  if ViewsRegistry.TryGetValue(PreviousGUID, PreviousRegInfo) then
  begin
    PreviousView := PreviousRegInfo.View;
    PreviousInstance := TPisces(PreviousRegInfo.Instance);
    PreviousView.setAlpha(0);
    PreviousView.setVisibility(TJView.JavaClass.VISIBLE);
    PreviousView.animate
      .alpha(1)
      .setDuration(300)
      .start;

    // Call DoShow lifecycle method on previous screen (returning to it)
    if Assigned(PreviousInstance) then
      PreviousInstance.DoShow;
  end;

  FCurrentScreenGUID := PreviousGUID;

  TPscUtils.Log('Screen popped successfully', 'Pop', TLogger.Info, 'TPscScreenManager');
end;

procedure TPscScreenManager.PopToRoot;
var
  RootGUID: String;
begin
  if FScreenStack.Count = 0 then
    Exit;

  TPscUtils.Log('Popping to root screen', 'PopToRoot', TLogger.Info, 'TPscScreenManager');

  // Get root screen (first one in stack)
  RootGUID := FScreenStack.ToArray[FScreenStack.Count - 1];

  // Clear stack
  FScreenStack.Clear;

  // Pop to root
  FScreenStack.Push(RootGUID);
  Pop;

  TPscUtils.Log('Popped to root successfully', 'PopToRoot', TLogger.Info, 'TPscScreenManager');
end;

function TPscScreenManager.FindScreenGUIDByName(const ScreenName: String): String;
var
  RegInfo: TViewRegistrationInfo;
begin
  Result := '';
  for RegInfo in ViewsRegistry.Values do
  begin
    if SameText(RegInfo.ViewName, ScreenName) then
    begin
      Result := RegInfo.ViewGUID;
      Exit;
    end;
  end;
end;

procedure TPscScreenManager.SetInitialScreen(const ScreenGUID: String);
begin
  FCurrentScreenGUID := ScreenGUID;
  TPscUtils.Log(Format('Initial screen set to GUID: %s', [ScreenGUID]), 'SetInitialScreen', TLogger.Info, 'TPscScreenManager');
end;

procedure TPscScreenManager.SetInitialScreenByName(const ScreenName: String);
var
  GUID: String;
begin
  GUID := FindScreenGUIDByName(ScreenName);
  if GUID <> '' then
  begin
    SetInitialScreen(GUID);
    TPscUtils.Log(Format('Initial screen set to: %s', [ScreenName]), 'SetInitialScreenByName', TLogger.Info, 'TPscScreenManager');
  end
  else
    TPscUtils.Log(Format('Screen not found: %s', [ScreenName]), 'SetInitialScreenByName', TLogger.Error, 'TPscScreenManager');
end;

procedure TPscScreenManager.PushByName(const ScreenName: String);
var
  GUID: String;
begin
  GUID := FindScreenGUIDByName(ScreenName);
  if GUID <> '' then
    Push(GUID)
  else
    TPscUtils.Log(Format('Screen not found: %s', [ScreenName]), 'PushByName', TLogger.Error, 'TPscScreenManager');
end;

end.
