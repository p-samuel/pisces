# Pisces Audio

Pisces provides two audio classes for Android applications:

- **TPscSound** - For short sound effects (SoundPool-based, low latency)
- **TPscMusic** - For background music and longer audio (MediaPlayer-based)

## Quick Start

```pascal
uses
  Pisces;

// Load sounds (do this once, e.g., in initialization)
TPscUtils.Sound
  .Load('click', 'audio/click.wav')
  .Load('win', 'audio/win.wav');

// Play a sound
TPscUtils.Sound.Play('click');

// Load and play background music
TPscUtils.Music.Load('bgm', 'audio/background.mp3');
TPscUtils.Music.PlayLoop('bgm', True);  // True = loop
```

## Deployment

Add your audio files in the Delphi Deployment Manager:

| Local Path | Remote Path | Platform |
|------------|-------------|----------|
| `assets\audio\click.wav` | `assets\audio` | Android64 |

The load path is relative to the `assets` folder:
- Remote path: `assets\audio`
- Load with: `'audio/click.wav'`

## TPscSound (Sound Effects)

Best for short sounds (<5 seconds), supports multiple simultaneous playback.

### Loading

```pascal
// From assets folder
TPscUtils.Sound.Load('name', 'audio/sound.wav');

// From resources (res/raw folder)
TPscUtils.Sound.LoadResource('name', 'sound', 'raw');
```

### Playback

```pascal
// Play once
TPscUtils.Sound.Play('name');

// Play looped
TPscUtils.Sound.Play('name', True);

// Play with full control (returns StreamId)
var StreamId := TPscUtils.Sound.PlayEx('name',
  1.0, 1.0,   // Left/Right volume (0.0-1.0)
  1,          // Priority
  0,          // Loop (-1=infinite, 0=none)
  1.0         // Rate (0.5-2.0)
);
```

### Control

```pascal
// Stop by stream ID
TPscUtils.Sound.Stop(StreamId);

// Stop by name
TPscUtils.Sound.StopByName('name');

// Pause/Resume
TPscUtils.Sound.Pause(StreamId);
TPscUtils.Sound.Resume(StreamId);

// Pause/Resume all
TPscUtils.Sound.PauseAll;
TPscUtils.Sound.ResumeAll;

// Adjust playing sound
TPscUtils.Sound.SetVolume(StreamId, 0.5, 0.5);
TPscUtils.Sound.SetRate(StreamId, 1.5);
TPscUtils.Sound.SetLoop(StreamId, -1);  // -1 = infinite
```

### Cleanup

```pascal
TPscUtils.Sound.Unload('name');
TPscUtils.Sound.UnloadAll;
TPscUtils.Sound.Release;
```

## TPscMusic (Background Music)

Best for longer audio, supports seeking and duration info.

### Loading

```pascal
// From assets folder
TPscUtils.Music.Load('name', 'audio/music.mp3');

// From resources
TPscUtils.Music.LoadResource('name', 'music', 'raw');

// From file path
TPscUtils.Music.LoadFile('name', '/sdcard/music.mp3');

// From URI
TPscUtils.Music.LoadUri('name', 'content://...');
```

### Playback

```pascal
// Play
TPscUtils.Music.Play('name');

// Play with loop option
TPscUtils.Music.PlayLoop('name', True);

// Pause/Stop
TPscUtils.Music.Pause('name');
TPscUtils.Music.Stop('name');

// Seek (milliseconds)
TPscUtils.Music.SeekTo('name', 30000);  // 30 seconds
```

### Properties

```pascal
// Volume (0.0-1.0)
TPscUtils.Music.Volume('name', 0.8, 0.8);

// Looping
TPscUtils.Music.SetLooping('name', True);

// Get info
var Position := TPscUtils.Music.GetPosition('name');  // ms
var Duration := TPscUtils.Music.GetDuration('name');  // ms
var Playing := TPscUtils.Music.IsPlaying('name');
var Loaded := TPscUtils.Music.IsLoaded('name');
```

### Completion Callback

```pascal
TPscUtils.Music.OnCompletion('name', procedure begin
  // Called when playback finishes
  ShowMessage('Music ended');
end);
```

### Cleanup

```pascal
TPscUtils.Music.ReleasePlayer('name');
TPscUtils.Music.ReleaseAll;
```

## Complete Example

```pascal
unit View.Game;

interface

uses
  Pisces;

type
  [FrameLayout('game'), FullScreen(True)]
  TGameScreen = class(TPisces)
    constructor Create; override;
  end;

implementation

constructor TGameScreen.Create;
begin
  inherited;
  // Start background music when screen loads
  TPscUtils.Music.PlayLoop('bgm', True);
end;

initialization
  // Load all audio assets
  TPscUtils.Sound
    .Load('click', 'audio/click.wav')
    .Load('win', 'audio/win.wav')
    .Load('lose', 'audio/lose.wav');

  TPscUtils.Music
    .Load('bgm', 'audio/background.mp3');

finalization
  // Optional: cleanup is automatic on app termination
  TPscUtils.Sound.UnloadAll;
  TPscUtils.Music.ReleaseAll;

end.
```

## Supported Formats

| Type | Recommended Formats |
|------|---------------------|
| Sound Effects | WAV, OGG |
| Music | MP3, OGG, AAC |
