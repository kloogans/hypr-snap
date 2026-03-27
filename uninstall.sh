#!/usr/bin/env bash
set -euo pipefail

INSTALL_DIR="$HOME/.local/bin"
CONFIG_DIR="${XDG_CONFIG_HOME:-$HOME/.config}/hypr-snap"

rm -f "$INSTALL_DIR/hypr-snap" "$INSTALL_DIR/hypr-snap-gui"
echo "Removed scripts from $INSTALL_DIR"

if [[ -d "$CONFIG_DIR" ]]; then
    read -rp "Remove config at $CONFIG_DIR? [y/N] " answer
    [[ "$answer" =~ ^[Yy]$ ]] && rm -rf "$CONFIG_DIR" && echo "Removed config"
fi

echo "Done. Recordings in ~/Videos/hypr-snap were not removed."
