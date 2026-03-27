# hypr-snap

Fast screen recording for Hyprland with a post-recording GUI.

Press a key to start recording, press again to stop. A floating popup appears with video playback, trim controls, GIF conversion, and clipboard actions.

## Features

- **Toggle recording** with a single keybind
- **Three modes**: fullscreen, region (via slurp), or active window
- **Video playback** with seek bar in the post-recording popup
- **Trim** - mark in/out points and cut with ffmpeg
- **GIF conversion** with optimized palette generation
- **Clipboard integration** - copy file paths instantly
- **Multi-monitor** - auto-detects the focused monitor

## Dependencies

| Package | Purpose |
|---|---|
| `wf-recorder` | Screen recording |
| `slurp` | Region selection |
| `ffmpeg` | Trim + GIF conversion |
| `wl-clipboard` | Clipboard (wl-copy) |
| `libnotify` | Notifications (notify-send) |
| `jq` | JSON parsing |
| `python-gobject` | GTK4 Python bindings |
| `gtk4` | GUI toolkit |
| `gst-plugins-good` | GStreamer video codecs |
| `gst-libav` | GStreamer H.264 decoder |

On Arch:

```bash
sudo pacman -S wf-recorder slurp ffmpeg wl-clipboard libnotify jq python-gobject gtk4 gst-plugins-good gst-libav
```

## Install

```bash
git clone https://github.com/kloogans/hypr-snap.git
cd hypr-snap
./install.sh
```

## Usage

```bash
hypr-snap screen    # Record entire screen
hypr-snap region    # Select a region with slurp
hypr-snap window    # Record the active window
hypr-snap           # Default: fullscreen (stops if already recording)
```

Any invocation while recording is active will stop the recording and open the GUI.

### Keybindings

Add to `~/.config/hypr/hyprland.conf`:

```ini
bind = SUPER, R, exec, hypr-snap screen
bind = SUPER SHIFT, R, exec, hypr-snap region
```

### Window Rules

Float the popup so it doesn't tile:

```ini
windowrule = match:class dev.kloogans.hypr-snap, float 1
windowrule = match:class dev.kloogans.hypr-snap, size 640 480
windowrule = match:class dev.kloogans.hypr-snap, center 1
```

## Post-Recording GUI

After recording stops, a floating popup appears with:

- **Video player** - full playback with seek bar (autoplay, looping)
- **File info** - filename, duration, size, resolution
- **Trim** - Mark In / Mark Out to set trim points, then Trim to cut
- **Copy Path** - copy the file path to clipboard
- **GIF** - convert to GIF (becomes "Copy GIF" after conversion)
- **Open** - open the containing folder
- **Delete** - remove the recording and close

Press **Escape** to dismiss.

## Configuration

Edit `~/.config/hypr-snap/config`:

```bash
# Where to save recordings
SAVE_DIR="$HOME/Videos/hypr-snap"

# Recording settings
FPS=30
AUDIO=false
# CODEC=h264_vaapi    # Uncomment for hardware-accelerated encoding
PIXEL_FORMAT=yuv420p

# GIF conversion settings
GIF_FPS=15
GIF_MAX_WIDTH=640
```

## How It Works

1. `hypr-snap` starts `wf-recorder` in the background and tracks its PID
2. On second press, it sends SIGINT to stop recording gracefully
3. `hypr-snap-gui` opens a floating GTK4 window with video playback
4. Trim uses ffmpeg stream copy for instant cuts
5. GIF conversion uses ffmpeg's palette-based method for optimal quality and size

## Uninstall

```bash
cd hypr-snap
./uninstall.sh
```
