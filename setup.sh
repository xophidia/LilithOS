#!/usr/bin/env bash

set -e

# Configuration
REPO_URL="https://github.com/nom-utilisateur/mon-depot-nixos.git"
TARGET_DIR="/etc/nixos"
TEMP_DIR="/tmp/nixos-config"

echo "[1/6] Activation des fonctionnalités flakes dans nix.conf"
sudo mkdir -p /etc/nix
echo "experimental-features = nix-command flakes" | sudo tee /etc/nix/nix.conf > /dev/null

echo "[2/6] Installation de git (si absent)"
if ! command -v git &> /dev/null; then
  echo "git non trouvé, installation en cours..."
  sudo nix-env -iA nixos.git
else
  echo "git déjà installé."
fi

echo "[3/6] Clonage du dépôt..."
sudo rm -rf "$TEMP_DIR"
git clone "$REPO_URL" "$TEMP_DIR"

echo "[3.5/6] Personnalisation"
sudo mkdir -p /usr/share/backgrounds/
sudo cp "$TEMP_DIR/backgrounds/lilithOS_1920_1200.png" /usr/share/backgrounds/custom/


echo "[4/6] Sauvegarde de la configuration actuelle"
sudo cp -r "$TARGET_DIR" "$TARGET_DIR.bak.$(date +%Y%m%d%H%M%S)"

echo "[5/6] Copie des fichiers dans /etc/nixos/"
sudo cp -r "$TEMP_DIR"/* "$TARGET_DIR"

echo "[6/6] Application de la configuration via flake"
sudo nixos-rebuild switch --flake "$TARGET_DIR"#$(hostname)

echo "✅ Configuration appliquée avec succès !"
