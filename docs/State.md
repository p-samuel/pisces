# Pisces State

Pisces provides two approaches for state management:

1. **TPscState** - Simple key/value singleton store
2. **TPscStateModel** - Typed state model with automatic JSON serialization

Both use `Save` and `Load` for disk persistence.

---

## TPscState (Key/Value)

Simple singleton store for primitives:

```pascal
uses Pisces.State;

// Set/Get values (in-memory, instant)
TPscState.SetValue('counter', 0);
TPscState.SetValue('theme', 'dark');
var Count := TPscState.GetValue<Integer>('counter', 0);

// Persist to disk (only when needed)
TPscState.Save;

// Load from disk (call at app start)
TPscState.Load;
```

### API

```pascal
TPscState.SetValue('key', value);
TPscState.GetValue<T>('key');
TPscState.GetValue<T>('key', defaultValue);
TPscState.HasKey('key');
TPscState.RemoveKey('key');
TPscState.ClearAll;
TPscState.Save;   // persist to disk
TPscState.Load;   // load from disk
```

### File Location

Default: `Documents/state.json`

---

## TPscStateModel (Typed Model)

Define your app's state as a class with automatic JSON persistence:

```pascal
uses Pisces;

type
  TUserState = class(TPscStateModel)
  public
    Name: String;
    Email: String;
  end;

  TAppState = class(TPscStateModel)
  public
    Counter: Integer;
    Theme: String;
    DarkMode: Boolean;
    User: TUserState;  // nested objects supported
  end;
```

### Usage

```pascal
var
  AppState: TAppState;
begin
  // Load from JSON (or create new if file doesn't exist)
  AppState := TAppState.Load<TAppState>;

  // Use it
  AppState.Counter := AppState.Counter + 1;
  AppState.Theme := 'dark';
  AppState.User := TUserState.Create;
  AppState.User.Name := 'John';

  // Save to JSON
  AppState.Save;
end;
```

### Attributes

```pascal
type
  TMyState = class(TPscStateModel)
  public
    [JsonName('user_name')]   // custom JSON key
    UserName: String;

    [JsonIgnore]              // exclude from JSON
    TempData: String;

    Counter: Integer;
  end;
```

### API

```pascal
// Load from file (creates new if not found)
var State := TMyState.Load<TMyState>;

// Save to file
State.Save;

// Convert to/from JSON string
var Json := State.ToJson;
var State := TMyState.FromJson<TMyState>(Json);

// Custom file path (per model type)
TMyState.SetStatePath('/path/to/state.json');
```

### Supported Types

- `String`
- `Integer`, `Int64`
- `Boolean`
- `Double`, `TDateTime`, `TDate`, `TTime`
- Nested objects (classes)
- Enums

### File Location

Each model type saves to its own file: `Documents/{ClassName}.json`

Examples:
- `TAppState` saves to `Documents/TAppState.json`
- `TUserSettings` saves to `Documents/TUserSettings.json`

Custom paths are tracked per model type, so setting a path for one model doesn't affect others.

---

## Navigation with State

State is global (singleton), so values are available across all screens without explicit passing.

**For navigation (in-memory only):**
```pascal
// Home screen - set values before navigating
TPscState.SetValue('selectedId', 123);
TPscScreenManager.Instance.PushByName('detail');

// Detail screen - read values in DoShow
procedure TDetailScreen.DoShow;
begin
  inherited;
  var Id := State.Get<Integer>('selectedId', 0);
end;
```

**For persistence across app restarts:**
```pascal
// Only call Save when you need data to survive app close
TPscState.SetValue('lastUserId', 123);
TPscState.Save;  // writes to Documents/state.json

// At app startup
TPscState.Load;  // reads from Documents/state.json
var LastId := TPscState.GetValue<Integer>('lastUserId', 0);
```

Same applies to typed models - `Save` is only needed for disk persistence, not for sharing data between screens.
