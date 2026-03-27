#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr-snap"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "${GREEN}[+]${NC} $1"; }
warn()  { echo -e "${YELLOW}[!]${NC} $1"; }
fail()  { echo -e "${RED}[x]${NC} $1"; exit 1; }

check_deps() {
    local missing=()
    local deps=(wf-recorder slurp ffmpeg wl-copy notify-send jq hyprctl)

    for dep in "${deps[@]}"; do
        command -v "$dep" &>/dev/null || missing+=("$dep")
    done

    if ! python3 -c "import gi; gi.require_version('Gtk','4.0'); from gi.repository import Gtk" &>/dev/null; then
        missing+=("python-gobject/gtk4")
    fi

    if ! gst-inspect-1.0 --exists avdec_h264 2>/dev/null; then
        missing+=("gst-plugins-good/gst-libav")
    fi

    if (( ${#missing[@]} > 0 )); then
        fail "Missing dependencies: ${missing[*]}"
    fi

    info "All dependencies found"
}

install() {
    echo "Installing hypr-snap..."
    echo ""

    check_deps

    mkdir -p "$INSTALL_DIR"
    cp bin/hypr-snap "$INSTALL_DIR/hypr-snap"
    cp bin/hypr-snap-gui "$INSTALL_DIR/hypr-snap-gui"
    chmod +x "$INSTALL_DIR/hypr-snap" "$INSTALL_DIR/hypr-snap-gui"
    info "Installed scripts to $INSTALL_DIR"

    if [[ ! -f "$CONFIG_DIR/config" ]]; then
        mkdir -p "$CONFIG_DIR"
        cp config.example "$CONFIG_DIR/config"
        info "Created config at $CONFIG_DIR/config"
    else
        warn "Config already exists (not overwritten)"
    fi

    mkdir -p "$HOME/Videos/hypr-snap"

    echo ""
    info "Installation complete!"
    echo ""
    echo "  Add keybindings to your Hyprland config:"
    echo "    bind = SUPER, R, exec, hypr-snap screen"
    echo "    bind = SUPER SHIFT, R, exec, hypr-snap region"
    echo ""
    echo "  Add window rules for the floating popup:"
    echo "    windowrule = match:class dev.kloogans.hypr-snap, float 1"
    echo "    windowrule = match:class dev.kloogans.hypr-snap, size 640 480"
    echo "    windowrule = match:class dev.kloogans.hypr-snap, center 1"
    echo ""
}

install
