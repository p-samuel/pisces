# Screen Transitions

Pisces supports animated screen transitions via attributes. Each screen can define four transition animations that control how it appears and disappears during navigation.

## The Four Transition Types

| Attribute | When It Runs |
|-----------|--------------|
| `EnterTransition` | Screen animates **in** when pushed onto the stack |
| `ExitTransition` | Screen animates **out** when another screen is pushed on top |
| `PopEnterTransition` | Screen animates **in** when returning (previous screen was popped) |
| `PopExitTransition` | Screen animates **out** when popped off the stack |

### Visual Example

```
Stack: [Home]

User taps "View Details":
  - Home plays ExitTransition (exits)
  - Detail plays EnterTransition (enters)

Stack: [Home, Detail]

User taps "Back":
  - Detail plays PopExitTransition (exits)
  - Home plays PopEnterTransition (enters)

Stack: [Home]
```

## Usage

```pascal
[ LinearLayout('myScreen'),
  EnterTransition(TTransitionType.SlideRight, TEasingType.Decelerate, 300),
  ExitTransition(TTransitionType.Fade, TEasingType.Accelerate, 200),
  PopEnterTransition(TTransitionType.SlideLeft, TEasingType.Decelerate, 300),
  PopExitTransition(TTransitionType.SlideRight, TEasingType.Accelerate, 250)
] TMyScreen = class(TPisces)
  // ...
end;
```

## Available Transition Types

| Type | Description |
|------|-------------|
| `None` | No animation |
| `Fade` | Alpha fade in/out |
| `SlideLeft` | Slide from/to the left |
| `SlideRight` | Slide from/to the right |
| `SlideUp` | Slide from/to the top |
| `SlideDown` | Slide from/to the bottom |
| `ScaleCenter` | Scale from/to center |
| `FlipHorizontal` | 3D flip around Y-axis |
| `FlipVertical` | 3D flip around X-axis |

## Available Easing Types

| Type | Description |
|------|-------------|
| `Linear` | Constant speed |
| `AccelerateDecelerate` | Slow start and end, fast middle |
| `Accelerate` | Starts slow, speeds up |
| `Decelerate` | Starts fast, slows down |
| `Anticipate` | Pulls back before moving forward |
| `Overshoot` | Goes past target, then settles back |
| `AnticipateOvershoot` | Combines anticipate and overshoot |
| `Bounce` | Bounces at the end |

## Parameters

Each transition attribute takes three parameters:

```pascal
EnterTransition(TransitionType, EasingType, DurationMs)
```

- **TransitionType**: The animation effect (see table above)
- **EasingType**: The interpolation curve (see table above)
- **DurationMs**: Animation duration in milliseconds

## Default Behavior

If no transition attributes are specified, screens default to a 300ms fade transition.
