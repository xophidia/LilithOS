#!/usr/bin/env bash

set -e

# Configuration
REPO_URL="https://github.com/xophidia/LilithOS.git"
TARGET_DIR="/etc/nixos"
TEMP_DIR="/tmp/nixos-config"

echo "[1/5] Detection de Git et installation"
if ! command -v git &> /dev/null; then
  echo "git non trouvé, installation en cours..."
  sudo nix-env -iA nixos.git
else
  echo "git déjà installé."
fi

echo "[2/5] Clonage du dépôt..."
sudo rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

#echo "[3/5] Sauvegarde de la configuration actuelle"
#sudo cp -r "$TARGET_DIR" "$TARGET_DIR.bak.$(date +%Y%m%d%H%M%S)"

echo "[4/5] Copie des fichiers dans /etc/nixos/"
sudo cp -r "$TEMP_DIR"/* "$TARGET_DIR"

echo "[5/5] Application de la configuration via flake"
sudo nixos-rebuild switch --flake "$TARGET_DIR"#$(hostname)

echo "Configuration appliquée avec succès !"
