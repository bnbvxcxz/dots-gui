#!/usr/bin/env bash
set -euo pipefail

CONFIG_DIR="$HOME/.config"
REPO_CONFIG_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.config"
BACKUP_DIR="$HOME/.config/dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
BACKED_UP=false

if [ ! -d "$REPO_CONFIG_DIR" ]; then
    echo "Error: .config directory not found in the repository root!"
    exit 1
fi

mkdir -p "$CONFIG_DIR"

echo "==> Deploying configurations from $REPO_CONFIG_DIR to $CONFIG_DIR..."

for item in "$REPO_CONFIG_DIR"/*; do
    [ -e "$item" ] || continue
    name=$(basename "$item")
    target="$CONFIG_DIR/$name"

    # Check if target already exists (file, directory, or symlink)
    if [ -e "$target" ] || [ -L "$target" ]; then
        # If it's already a symlink pointing to the exact repo item, skip
        if [ -L "$target" ] && [ "$(readlink -f "$target")" = "$(readlink -f "$item")" ]; then
            echo " [Skipped] $name is already correctly linked."
            continue
        fi

        # Back up existing conflicting config
        if [ "$BACKED_UP" = false ]; then
            mkdir -p "$BACKUP_DIR"
            BACKED_UP=true
        fi
        echo " [Backup] Moving existing $target to $BACKUP_DIR/"
        mv "$target" "$BACKUP_DIR/"
    fi

    echo " [Link] Linking $name -> $target"
    ln -s "$item" "$target"
done

echo "==> Done! Configurations deployed successfully."
if [ "$BACKED_UP" = true ]; then
    echo "    Existing conflicting configs were backed up to: $BACKUP_DIR"
fi
