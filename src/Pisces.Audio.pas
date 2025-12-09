unit Pisces.Audio;

interface

uses
  Androidapi.JNIBridge,
  Androidapi.JNI.JavaTypes,
  Androidapi.JNI.Media,
  Androidapi.JNI.Net,
  Androidapi.JNI.GraphicsContentViewText,
  System.Generics.Collections,
  System.SysUtils;

type
  TPscSound = class
  private
    class var FInstance: TPscSound;
    FSoundPool: JSoundPool;
    FSoundIds: TDictionary<String, Integer>;
    FStreamIds: TDictionary<String, Integer>;
    FMaxStreams: Integer;
    constructor Create(MaxStreams: Integer = 10);
  public
    class function Instance: TPscSound;
    class destructor Destroy;
    function Load(const Name, AssetPath: String): TPscSound;
    function LoadResource(const Name, ResName, Location: String): TPscSound;
    function Play(const Name: String; Loop: Boolean = False): Integer;
    function PlayEx(const Name: String; LeftVolume, RightVolume: Single; Priority: Integer; Loop: Integer; Rate: Single): Integer;
    procedure Stop(StreamId: Integer);
    procedure StopByName(const Name: String);
    procedure Pause(StreamId: Integer);
    procedure Resume(StreamId: Integer);
    procedure PauseAll;
    procedure ResumeAll;
    procedure SetVolume(StreamId: Integer; LeftVolume, RightVolume: Single);
    procedure SetRate(StreamId: Integer; Rate: Single);
    procedure SetPriority(StreamId: Integer; Priority: Integer);
    procedure SetLoop(StreamId: Integer; Loop: Integer);
    procedure Unload(const Name: String);
    procedure UnloadAll;
    function IsLoaded(const Name: String): Boolean;
    procedure Release;
  end;

  TPscMusic = class
  private
    class var FInstance: TPscMusic;
    FPlayers: TDictionary<String, JMediaPlayer>;
    FOnCompletion: TDictionary<String, TProc>;
    constructor Create;
    procedure InternalOnCompletion(const Name: String);
  public
    class function Instance: TPscMusic;
    class destructor Destroy;
    function Load(const Name, AssetPath: String): TPscMusic;
    function LoadResource(const Name, ResName, Location: String): TPscMusic;
    function LoadFile(const Name, FilePath: String): TPscMusic;
    function LoadUri(const Name, Uri: String): TPscMusic;
    function Play(const Name: String): TPscMusic;
    function PlayLoop(const Name: String; Loop: Boolean): TPscMusic;
    function Pause(const Name: String): TPscMusic;
    function Stop(const Name: String): TPscMusic;
    function SeekTo(const Name: String; Milliseconds: Integer): TPscMusic;
    function Volume(const Name: String; LeftVolume, RightVolume: Single): TPscMusic;
    function SetLooping(const Name: String; Loop: Boolean): TPscMusic;
    function GetPosition(const Name: String): Integer;
    function GetDuration(const Name: String): Integer;
    function IsPlaying(const Name: String): Boolean;
    function IsLoaded(const Name: String): Boolean;
    function OnCompletion(const Name: String; Callback: TProc): TPscMusic;
    function ReleasePlayer(const Name: String): TPscMusic;
    procedure ReleaseAll;
  end;

implementation

uses
  Androidapi.Helpers,
  Androidapi.JNI.App,
  Pisces.Logger,
  Pisces.Types;

type
  TPscMediaPlayerCompletionListener = class(TJavaLocal, JMediaPlayer_OnCompletionListener)
  private
    FName: String;
    FMusic: TPscMusic;
  public
    constructor Create(const AName: String; AMusic: TPscMusic);
    procedure onCompletion(mp: JMediaPlayer); cdecl;
  end;

{ TPscMediaPlayerCompletionListener }

constructor TPscMediaPlayerCompletionListener.Create(const AName: String; AMusic: TPscMusic);
begin
  inherited Create;
  FName := AName;
  FMusic := AMusic;
end;

procedure TPscMediaPlayerCompletionListener.onCompletion(mp: JMediaPlayer);
begin
  if FMusic <> nil then
    FMusic.InternalOnCompletion(FName);
end;

{ TPscSound }

constructor TPscSound.Create(MaxStreams: Integer);
var
  AudioAttributes: JAudioAttributes;
  Builder: JSoundPool_Builder;
  AttrBuilder: JAudioAttributes_Builder;
begin
  inherited Create;
  FMaxStreams := MaxStreams;
  FSoundIds := TDictionary<String, Integer>.Create;
  FStreamIds := TDictionary<String, Integer>.Create;

  try
    // Use SoundPool.Builder for API 21+
    AttrBuilder := TJAudioAttributes_Builder.JavaClass.init;
    AttrBuilder.setUsage(TJAudioAttributes.JavaClass.USAGE_GAME);
    AttrBuilder.setContentType(TJAudioAttributes.JavaClass.CONTENT_TYPE_SONIFICATION);
    AudioAttributes := AttrBuilder.build;

    Builder := TJSoundPool_Builder.JavaClass.init;
    Builder.setMaxStreams(MaxStreams);
    Builder.setAudioAttributes(AudioAttributes);
    FSoundPool := Builder.build;

    TPscLogger.Log('SoundPool created', 'TPscSound.Create', TLogger.Info, 'TPscSound');
  except
    on E: Exception do
      TPscLogger.Log('Error creating SoundPool: ' + E.Message, 'TPscSound.Create', TLogger.Error, 'TPscSound');
  end;
end;

class function TPscSound.Instance: TPscSound;
begin
  if FInstance = nil then
    FInstance := TPscSound.Create;
  Result := FInstance;
end;

class destructor TPscSound.Destroy;
begin
  if FInstance <> nil then
  begin
    FInstance.Release;
    FInstance.Free;
    FInstance := nil;
  end;
end;

function TPscSound.Load(const Name, AssetPath: String): TPscSound;
var
  AssetManager: JAssetManager;
  AssetFd: JAssetFileDescriptor;
  SoundId: Integer;
begin
  Result := Self;
  if FSoundPool = nil then Exit;

  try
    AssetManager := TAndroidHelper.Context.getAssets;
    AssetFd := AssetManager.openFd(StringToJString(AssetPath));
    SoundId := FSoundPool.load(AssetFd, 1);
    AssetFd.close;

    FSoundIds.AddOrSetValue(Name, SoundId);
    TPscLogger.Log('Loaded sound: ' + Name + ' from ' + AssetPath, 'TPscSound.Load', TLogger.Info, 'TPscSound');
  except
    on E: Exception do
      TPscLogger.Log('Error loading sound ' + Name + ': ' + E.Message, 'TPscSound.Load', TLogger.Error, 'TPscSound');
  end;
end;

function TPscSound.LoadResource(const Name, ResName, Location: String): TPscSound;
var
  ResId: Integer;
  SoundId: Integer;
begin
  Result := Self;
  if FSoundPool = nil then Exit;

  try
    ResId := TAndroidHelper.Context.getResources.getIdentifier(
      StringToJString(ResName),
      StringToJString(Location),
      TAndroidHelper.Context.getPackageName
    );

    if ResId <> 0 then
    begin
      SoundId := FSoundPool.load(TAndroidHelper.Context, ResId, 1);
      FSoundIds.AddOrSetValue(Name, SoundId);
      TPscLogger.Log('Loaded sound resource: ' + Name + ' from ' + Location, 'TPscSound.LoadResource', TLogger.Info, 'TPscSound');
    end
    else
      TPscLogger.Log('Resource not found: ' + ResName + ' in ' + Location, 'TPscSound.LoadResource', TLogger.Warning, 'TPscSound');
  except
    on E: Exception do
      TPscLogger.Log('Error loading sound resource ' + Name + ': ' + E.Message, 'TPscSound.LoadResource', TLogger.Error, 'TPscSound');
  end;
end;

function TPscSound.Play(const Name: String; Loop: Boolean): Integer;
var
  LoopCount: Integer;
begin
  if Loop then
    LoopCount := -1
  else
    LoopCount := 0;

  Result := PlayEx(Name, 1.0, 1.0, 1, LoopCount, 1.0);
end;

function TPscSound.PlayEx(const Name: String; LeftVolume, RightVolume: Single;
  Priority: Integer; Loop: Integer; Rate: Single): Integer;
var
  SoundId: Integer;
  StreamId: Integer;
begin
  Result := 0;
  if FSoundPool = nil then Exit;

  if FSoundIds.TryGetValue(Name, SoundId) then
  begin
    StreamId := FSoundPool.play(SoundId, LeftVolume, RightVolume, Priority, Loop, Rate);
    FStreamIds.AddOrSetValue(Name, StreamId);
    Result := StreamId;
    TPscLogger.Log('Playing sound: ' + Name + ' (StreamId: ' + IntToStr(StreamId) + ')', 'TPscSound.Play', TLogger.Info, 'TPscSound');
  end
  else
    TPscLogger.Log('Sound not loaded: ' + Name, 'TPscSound.Play', TLogger.Warning, 'TPscSound');
end;

procedure TPscSound.Stop(StreamId: Integer);
begin
  if FSoundPool <> nil then
    FSoundPool.stop(StreamId);
end;

procedure TPscSound.StopByName(const Name: String);
var
  StreamId: Integer;
begin
  if FStreamIds.TryGetValue(Name, StreamId) then
    Stop(StreamId);
end;

procedure TPscSound.Pause(StreamId: Integer);
begin
  if FSoundPool <> nil then
    FSoundPool.pause(StreamId);
end;

procedure TPscSound.Resume(StreamId: Integer);
begin
  if FSoundPool <> nil then
    FSoundPool.resume(StreamId);
end;

procedure TPscSound.PauseAll;
begin
  if FSoundPool <> nil then
    FSoundPool.autoPause;
end;

procedure TPscSound.ResumeAll;
begin
  if FSoundPool <> nil then
    FSoundPool.autoResume;
end;

procedure TPscSound.SetVolume(StreamId: Integer; LeftVolume, RightVolume: Single);
begin
  if FSoundPool <> nil then
    FSoundPool.setVolume(StreamId, LeftVolume, RightVolume);
end;

procedure TPscSound.SetRate(StreamId: Integer; Rate: Single);
begin
  if FSoundPool <> nil then
    FSoundPool.setRate(StreamId, Rate);
end;

procedure TPscSound.SetPriority(StreamId: Integer; Priority: Integer);
begin
  if FSoundPool <> nil then
    FSoundPool.setPriority(StreamId, Priority);
end;

procedure TPscSound.SetLoop(StreamId: Integer; Loop: Integer);
begin
  if FSoundPool <> nil then
    FSoundPool.setLoop(StreamId, Loop);
end;

procedure TPscSound.Unload(const Name: String);
var
  SoundId: Integer;
begin
  if FSoundPool = nil then Exit;

  if FSoundIds.TryGetValue(Name, SoundId) then
  begin
    FSoundPool.unload(SoundId);
    FSoundIds.Remove(Name);
    FStreamIds.Remove(Name);
    TPscLogger.Log('Unloaded sound: ' + Name, 'TPscSound.Unload', TLogger.Info, 'TPscSound');
  end;
end;

procedure TPscSound.UnloadAll;
var
  Name: String;
  SoundId: Integer;
begin
  if FSoundPool = nil then Exit;

  for Name in FSoundIds.Keys do
  begin
    if FSoundIds.TryGetValue(Name, SoundId) then
      FSoundPool.unload(SoundId);
  end;

  FSoundIds.Clear;
  FStreamIds.Clear;
  TPscLogger.Log('Unloaded all sounds', 'TPscSound.UnloadAll', TLogger.Info, 'TPscSound');
end;

function TPscSound.IsLoaded(const Name: String): Boolean;
begin
  Result := FSoundIds.ContainsKey(Name);
end;

procedure TPscSound.Release;
begin
  if FSoundPool <> nil then
  begin
    UnloadAll;
    FSoundPool.release;
    FSoundPool := nil;
    TPscLogger.Log('SoundPool released', 'TPscSound.Release', TLogger.Info, 'TPscSound');
  end;

  FreeAndNil(FSoundIds);
  FreeAndNil(FStreamIds);
end;

{ TPscMusic }

constructor TPscMusic.Create;
begin
  inherited Create;
  FPlayers := TDictionary<String, JMediaPlayer>.Create;
  FOnCompletion := TDictionary<String, TProc>.Create;
  TPscLogger.Log('TPscMusic created', 'TPscMusic.Create', TLogger.Info, 'TPscMusic');
end;

class function TPscMusic.Instance: TPscMusic;
begin
  if FInstance = nil then
    FInstance := TPscMusic.Create;
  Result := FInstance;
end;

class destructor TPscMusic.Destroy;
begin
  if FInstance <> nil then
  begin
    FInstance.ReleaseAll;
    FInstance.Free;
    FInstance := nil;
  end;
end;

procedure TPscMusic.InternalOnCompletion(const Name: String);
var
  Callback: TProc;
begin
  if FOnCompletion.TryGetValue(Name, Callback) then
  begin
    if Assigned(Callback) then
      Callback;
  end;
end;

function TPscMusic.Load(const Name, AssetPath: String): TPscMusic;
var
  Player: JMediaPlayer;
  AssetManager: JAssetManager;
  AssetFd: JAssetFileDescriptor;
  Listener: TPscMediaPlayerCompletionListener;
begin
  Result := Self;

  try
    // Release existing player if any
    ReleasePlayer(Name);

    Player := TJMediaPlayer.JavaClass.init;
    AssetManager := TAndroidHelper.Context.getAssets;
    AssetFd := AssetManager.openFd(StringToJString(AssetPath));

    Player.setDataSource(AssetFd.getFileDescriptor, AssetFd.getStartOffset, AssetFd.getLength);
    AssetFd.close;
    Player.prepare;

    // Set completion listener
    Listener := TPscMediaPlayerCompletionListener.Create(Name, Self);
    Player.setOnCompletionListener(Listener);

    FPlayers.AddOrSetValue(Name, Player);
    TPscLogger.Log('Loaded music: ' + Name + ' from ' + AssetPath, 'TPscMusic.Load', TLogger.Info, 'TPscMusic');
  except
    on E: Exception do
      TPscLogger.Log('Error loading music ' + Name + ': ' + E.Message, 'TPscMusic.Load', TLogger.Error, 'TPscMusic');
  end;
end;

function TPscMusic.LoadResource(const Name, ResName, Location: String): TPscMusic;
var
  Player: JMediaPlayer;
  ResId: Integer;
  Listener: TPscMediaPlayerCompletionListener;
begin
  Result := Self;

  try
    ReleasePlayer(Name);

    ResId := TAndroidHelper.Context.getResources.getIdentifier(
      StringToJString(ResName),
      StringToJString(Location),
      TAndroidHelper.Context.getPackageName
    );

    if ResId <> 0 then
    begin
      Player := TJMediaPlayer.JavaClass.create(TAndroidHelper.Context, ResId);
      Listener := TPscMediaPlayerCompletionListener.Create(Name, Self);
      Player.setOnCompletionListener(Listener);
      FPlayers.AddOrSetValue(Name, Player);
      TPscLogger.Log('Loaded music resource: ' + Name + ' from ' + Location, 'TPscMusic.LoadResource', TLogger.Info, 'TPscMusic');
    end
    else
      TPscLogger.Log('Resource not found: ' + ResName + ' in ' + Location, 'TPscMusic.LoadResource', TLogger.Warning, 'TPscMusic');
  except
    on E: Exception do
      TPscLogger.Log('Error loading music resource ' + Name + ': ' + E.Message, 'TPscMusic.LoadResource', TLogger.Error, 'TPscMusic');
  end;
end;

function TPscMusic.LoadFile(const Name, FilePath: String): TPscMusic;
var
  Player: JMediaPlayer;
  Listener: TPscMediaPlayerCompletionListener;
begin
  Result := Self;

  try
    ReleasePlayer(Name);

    Player := TJMediaPlayer.JavaClass.init;
    Player.setDataSource(StringToJString(FilePath));
    Player.prepare;

    Listener := TPscMediaPlayerCompletionListener.Create(Name, Self);
    Player.setOnCompletionListener(Listener);

    FPlayers.AddOrSetValue(Name, Player);
    TPscLogger.Log('Loaded music file: ' + Name + ' from ' + FilePath, 'TPscMusic.LoadFile', TLogger.Info, 'TPscMusic');
  except
    on E: Exception do
      TPscLogger.Log('Error loading music file ' + Name + ': ' + E.Message, 'TPscMusic.LoadFile', TLogger.Error, 'TPscMusic');
  end;
end;

function TPscMusic.LoadUri(const Name, Uri: String): TPscMusic;
var
  Player: JMediaPlayer;
  JUri: Jnet_Uri;
  Listener: TPscMediaPlayerCompletionListener;
begin
  Result := Self;

  try
    ReleasePlayer(Name);

    Player := TJMediaPlayer.JavaClass.init;
    JUri := TJnet_Uri.JavaClass.parse(StringToJString(Uri));
    Player.setDataSource(TAndroidHelper.Context, JUri);
    Player.prepare;

    Listener := TPscMediaPlayerCompletionListener.Create(Name, Self);
    Player.setOnCompletionListener(Listener);

    FPlayers.AddOrSetValue(Name, Player);
    TPscLogger.Log('Loaded music URI: ' + Name, 'TPscMusic.LoadUri', TLogger.Info, 'TPscMusic');
  except
    on E: Exception do
      TPscLogger.Log('Error loading music URI ' + Name + ': ' + E.Message, 'TPscMusic.LoadUri', TLogger.Error, 'TPscMusic');
  end;
end;

function TPscMusic.Play(const Name: String): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
  begin
    Player.start;
    TPscLogger.Log('Playing music: ' + Name, 'TPscMusic.Play', TLogger.Info, 'TPscMusic');
  end
  else
    TPscLogger.Log('Music not loaded: ' + Name, 'TPscMusic.Play', TLogger.Warning, 'TPscMusic');
end;

function TPscMusic.PlayLoop(const Name: String; Loop: Boolean): TPscMusic;
begin
  SetLooping(Name, Loop);
  Result := Play(Name);
end;

function TPscMusic.Pause(const Name: String): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
  begin
    if Player.isPlaying then
      Player.pause;
  end;
end;

function TPscMusic.Stop(const Name: String): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
  begin
    Player.stop;
    Player.prepare; // Reset to beginning
    TPscLogger.Log('Stopped music: ' + Name, 'TPscMusic.Stop', TLogger.Info, 'TPscMusic');
  end;
end;

function TPscMusic.SeekTo(const Name: String; Milliseconds: Integer): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
    Player.seekTo(Milliseconds);
end;

function TPscMusic.Volume(const Name: String; LeftVolume, RightVolume: Single): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
    Player.setVolume(LeftVolume, RightVolume);
end;

function TPscMusic.SetLooping(const Name: String; Loop: Boolean): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
    Player.setLooping(Loop);
end;

function TPscMusic.GetPosition(const Name: String): Integer;
var
  Player: JMediaPlayer;
begin
  Result := 0;

  if FPlayers.TryGetValue(Name, Player) then
    Result := Player.getCurrentPosition;
end;

function TPscMusic.GetDuration(const Name: String): Integer;
var
  Player: JMediaPlayer;
begin
  Result := 0;

  if FPlayers.TryGetValue(Name, Player) then
    Result := Player.getDuration;
end;

function TPscMusic.IsPlaying(const Name: String): Boolean;
var
  Player: JMediaPlayer;
begin
  Result := False;

  if FPlayers.TryGetValue(Name, Player) then
    Result := Player.isPlaying;
end;

function TPscMusic.IsLoaded(const Name: String): Boolean;
begin
  Result := FPlayers.ContainsKey(Name);
end;

function TPscMusic.OnCompletion(const Name: String; Callback: TProc): TPscMusic;
begin
  Result := Self;
  FOnCompletion.AddOrSetValue(Name, Callback);
end;

function TPscMusic.ReleasePlayer(const Name: String): TPscMusic;
var
  Player: JMediaPlayer;
begin
  Result := Self;

  if FPlayers.TryGetValue(Name, Player) then
  begin
    Player.stop;
    Player.release;
    FPlayers.Remove(Name);
    FOnCompletion.Remove(Name);
    TPscLogger.Log('Released music player: ' + Name, 'TPscMusic.ReleasePlayer', TLogger.Info, 'TPscMusic');
  end;
end;

procedure TPscMusic.ReleaseAll;
var
  Name: String;
  Player: JMediaPlayer;
begin
  for Name in FPlayers.Keys do
  begin
    if FPlayers.TryGetValue(Name, Player) then
    begin
      Player.stop;
      Player.release;
    end;
  end;

  FPlayers.Clear;
  FOnCompletion.Clear;
  TPscLogger.Log('Released all music players', 'TPscMusic.ReleaseAll', TLogger.Info, 'TPscMusic');
end;

end.
