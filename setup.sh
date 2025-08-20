#!/usr/bin/env bash

set -e

# Configuration
REPO_URL="https://github.com/xophidia/LilithOS.git"
TARGET_DIR="/etc/nixos"
TEMP_DIR="/tmp/nixos-config"
HOME="/home/xophidia"

echo "[1/5] Detection des pre-requis et installation"
if ! command -v git &> /dev/null; then
  echo "git non trouvé, installation en cours..."
  sudo nix-env -iA nixos.git
else
  echo "git déjà installé."
fi

if ! command -v wget &> /dev/null; then
  echo "wget non trouvé, installation en cours..."
  sudo nix-env -iA nixos.wget
else
  echo "git déjà installé."
fi

echo "[2/5] Clonage du dépôt..."
sudo rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

echo "[3/5] Copie du répertoire scripts/ dans le HOME de l'utilisateur"
if [ -d "$TEMP_DIR/scripts" ]; then
  mkdir -p "$HOME/scripts"
  cp -r "$TEMP_DIR/scripts/"* "$HOME/scripts/"
  echo "Répertoire scripts copié dans $HOME/scripts"
else
  echo "Aucun répertoire scripts trouvé dans le dépôt."
fi

echo "[4/5] Copie des fichiers dans /etc/nixos/"
sudo cp -r "$TEMP_DIR"/* "$TARGET_DIR"

echo "[5/5] Application de la configuration via flake"
sudo nixos-rebuild switch --flake "$TARGET_DIR"#$(hostname)

echo "Configuration appliquée avec succès !"
