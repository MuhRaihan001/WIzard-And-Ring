# Form Character Sprite Sheet Specification

## Overview
This document details the complete sprite sheet layout for the `form.png` character, including all idle, walk, and attack animations from multiple directions.

## Sprite Sheet Dimensions
- **Recommended Total Size**: 512x512 pixels (or 1024x512 for more frames)
- **Individual Frame Size**: 64x64 pixels (adjustable based on character detail needs)
- **Grid Layout**: 8 columns x 8 rows (64 total frames available)

## Animation Breakdown

### 1. IDLE ANIMATIONS (12 frames total)

#### Idle Front (4 frames)
- **Row**: 1
- **Columns**: 1-4
- **Description**: Character facing camera, subtle breathing animation
- **Frame sequence**: Standing → slight movement → return to standing
- **Timing**: ~0.15s per frame (looping)

#### Idle Back (4 frames)
- **Row**: 1
- **Columns**: 5-8
- **Description**: Character facing away from camera, subtle movement
- **Frame sequence**: Standing → slight sway → return to standing
- **Timing**: ~0.15s per frame (looping)

#### Idle Side (4 frames)
- **Row**: 2
- **Columns**: 1-4
- **Description**: Character facing right (flip horizontally for left)
- **Frame sequence**: Standing → weight shift → return to standing
- **Timing**: ~0.15s per frame (looping)

---

### 2. WALK ANIMATIONS (24 frames total)

#### Walk Front (8 frames)
- **Row**: 2-3
- **Columns**: Row 2: 5-8, Row 3: 1-4
- **Description**: Walking toward camera
- **Frame sequence**: 
  1. Standing
  2. Left foot forward
  3. Both feet together
  4. Right foot forward
  5. Both feet together
  6. Left foot forward (repeat cycle)
  7. Mid-step
  8. Complete step
- **Timing**: ~0.1s per frame (looping)

#### Walk Back (8 frames)
- **Row**: 3-4
- **Columns**: Row 3: 5-8, Row 4: 1-4
- **Description**: Walking away from camera
- **Frame sequence**: Similar to walk front but showing back view
- **Timing**: ~0.1s per frame (looping)

#### Walk Side (8 frames)
- **Row**: 4-5
- **Columns**: Row 4: 5-8, Row 5: 1-4
- **Description**: Walking to the right (flip for left)
- **Frame sequence**: Classic side-view walk cycle
  1. Contact (foot touches ground)
  2. Recoil (body compresses)
  3. Passing (opposite leg passes)
  4. High point (body at highest)
  5. Contact (other foot)
  6. Recoil
  7. Passing
  8. High point
- **Timing**: ~0.1s per frame (looping)

---

### 3. ATTACK ANIMATIONS (24 frames total)

#### Attack Front (8 frames)
- **Row**: 5-6
- **Columns**: Row 5: 5-8, Row 6: 1-4
- **Description**: Attack facing camera (punch/magic cast)
- **Frame sequence**:
  1. Neutral stance
  2. Wind-up (pulling back)
  3. Anticipation
  4. Attack start
  5. Attack peak (hit frame)
  6. Follow-through
  7. Recovery start
  8. Return to neutral
- **Timing**: ~0.08s per frame (one-shot, then return to idle)

#### Attack Back (8 frames)
- **Row**: 6-7
- **Columns**: Row 6: 5-8, Row 7: 1-4
- **Description**: Attack facing away from camera
- **Frame sequence**: Similar to attack front but back view
- **Timing**: ~0.08s per frame (one-shot)

#### Attack Side (8 frames)
- **Row**: 7-8
- **Columns**: Row 7: 5-8, Row 8: 1-4
- **Description**: Attack facing right (flip for left)
- **Frame sequence**:
  1. Neutral stance
  2. Wind-up (arm back)
  3. Anticipation (slight pause)
  4. Attack start (arm moving forward)
  5. Attack peak (full extension) **← HIT FRAME**
  6. Follow-through
  7. Recovery
  8. Return to neutral
- **Timing**: ~0.08s per frame (one-shot)

---

## Sprite Sheet Grid Layout

```
     1    2    3    4    5    6    7    8
   ┌────┬────┬────┬────┬────┬────┬────┬────┐
 1 │ IF │ IF │ IF │ IF │ IB │ IB │ IB │ IB │  IF = Idle Front
   ├────┼────┼────┼────┼────┼────┼────┼────┤  IB = Idle Back
 2 │ IS │ IS │ IS │ IS │ WF │ WF │ WF │ WF │  IS = Idle Side
   ├────┼────┼────┼────┼────┼────┼────┼────┤  WF = Walk Front
 3 │ WF │ WF │ WF │ WF │ WB │ WB │ WB │ WB │  WB = Walk Back
   ├────┼────┼────┼────┼────┼────┼────┼────┤  WS = Walk Side
 4 │ WB │ WB │ WB │ WB │ WS │ WS │ WS │ WS │  AF = Attack Front
   ├────┼────┼────┼────┼────┼────┼────┼────┤  AB = Attack Back
 5 │ WS │ WS │ WS │ WS │ AF │ AF │ AF │ AF │  AS = Attack Side
   ├────┼────┼────┼────┼────┼────┼────┼────┤
 6 │ AF │ AF │ AF │ AF │ AB │ AB │ AB │ AB │
   ├────┼────┼────┼────┼────┼────┼────┼────┤
 7 │ AB │ AB │ AB │ AB │ AS │ AS │ AS │ AS │
   ├────┼────┼────┼────┼────┼────┼────┼────┤
 8 │ AS │ AS │ AS │ AS │    │    │    │    │
   └────┴────┴────┴────┴────┴────┴────┴────┘
```

---

## Technical Specifications

### Frame Dimensions
- **Width**: 64 pixels
- **Height**: 64 pixels
- **Spacing**: 0 pixels (frames are adjacent)
- **Margin**: 0 pixels

### Color & Style Guidelines
- **Background**: Transparent (PNG with alpha channel)
- **Art Style**: Pixel art / 2D sprite style
- **Color Palette**: Match existing character design
- **Outline**: Optional 1-2 pixel dark outline for visibility

### Export Settings
- **Format**: PNG
- **Color Mode**: RGBA (with transparency)
- **Resolution**: 72 DPI minimum
- **Total Size**: 512x512 pixels (8x8 grid of 64x64 frames)

---

## Animation Frame Rates

| Animation Type | FPS | Duration | Loop |
|---------------|-----|----------|------|
| Idle Front    | 6-8 | ~0.5-0.6s | Yes |
| Idle Back     | 6-8 | ~0.5-0.6s | Yes |
| Idle Side     | 6-8 | ~0.5-0.6s | Yes |
| Walk Front    | 10-12 | ~0.8s | Yes |
| Walk Back     | 10-12 | ~0.8s | Yes |
| Walk Side     | 10-12 | ~0.8s | Yes |
| Attack Front  | 12-15 | ~0.64s | No |
| Attack Back   | 12-15 | ~0.64s | No |
| Attack Side   | 12-15 | ~0.64s | No |

---

## Recommended Tools

1. **Aseprite** (Paid) - Best for pixel art sprite sheets
   - Built-in animation timeline
   - Onion skinning
   - Export sprite sheet with metadata

2. **Piskel** (Free, Web-based) - Good for beginners
   - Online editor
   - Simple interface
   - Export as PNG sprite sheet

3. **GraphicsGale** (Free) - Windows pixel art tool
   - Layer support
   - Animation preview
   - Sprite sheet export

4. **GIMP** (Free) - General purpose
   - Use with grid guides (64x64)
   - Manual frame creation
   - Good for non-pixel art styles

---

## Implementation Notes for Godot

After creating the sprite sheet, you'll need to:

1. Import `form.png` into Godot
2. Configure the import settings:
   - Filter: OFF (for pixel art)
   - Repeat: Disabled
   - Compression: Lossless or Uncompressed

3. Create AnimatedSprite2D or use SpriteFrames resource
4. Set Hframes = 8, Vframes = 8
5. Configure each animation in the SpriteFrames editor

See the accompanying Godot configuration file for implementation details.

---

## File Organization

```
assets/characters/
├── form.png                          # Main sprite sheet
├── form.png.import                   # Godot import config
├── form_sprite_specification.md     # This file
└── form_animations.tres              # Godot SpriteFrames resource (to be created)
```

---

## Quick Reference: Frame Coordinates

### Idle Animations
- **Idle Front**: Row 0, Frames 0-3
- **Idle Back**: Row 0, Frames 4-7
- **Idle Side**: Row 1, Frames 0-3

### Walk Animations
- **Walk Front**: Row 1 Frame 4 to Row 2 Frame 3 (Frames 12-19)
- **Walk Back**: Row 2 Frame 4 to Row 3 Frame 3 (Frames 20-27)
- **Walk Side**: Row 3 Frame 4 to Row 4 Frame 3 (Frames 28-35)

### Attack Animations
- **Attack Front**: Row 4 Frame 4 to Row 5 Frame 3 (Frames 36-43)
- **Attack Back**: Row 5 Frame 4 to Row 6 Frame 3 (Frames 44-51)
- **Attack Side**: Row 6 Frame 4 to Row 7 Frame 3 (Frames 52-59)

---

## Notes
- All "side" animations are designed for RIGHT-facing direction
- Flip horizontally in Godot for LEFT-facing direction
- The HIT FRAME for attacks is typically frame 5 of each attack sequence
- Adjust frame counts and timing based on your game's feel

---

**Last Updated**: 2026-02-11
**Version**: 1.0
