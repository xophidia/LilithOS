#!/bin/bash

VERSION="redroid:12.0.0-latest"
START_COMMAND="docker run -itd --rm --privileged --pull always -v ./data:/data -p 5555:5555 redroid/$VERSION androidboot.redroid_width=1080 androidboot.redroid_height=1920 androidboot.redroid_dpi=480"

id_container=$(docker ps -a | grep "$VERSION" | cut -d " " -f1)
STOP_COMMAND="docker container stop $id_container"

display_help() {
  echo "Usage: $0 {start|stop|help}"
  echo
  echo "start   : Démarre le conteneur, se connecte via ADB et lance scrcpy."
  echo "stop    : Arrête le conteneur."
  echo "help    : Affiche ce message d'aide."
}

case "$1" in
  start)
    echo "Démarrage du conteneur..."
    if $START_COMMAND; then
      echo "Conteneur démarré avec succès."

      echo "Connexion ADB..."
      if adb connect localhost:5555 | grep -q "connected"; then
        echo "Connexion ADB réussie."

        echo "Lancement de scrcpy..."
        sleep 20
        scrcpy -s localhost:5555
      else
        echo "Échec de la connexion ADB."
        exit 1
      fi

    else
      echo "Échec du démarrage du conteneur."
      exit 1
    fi
    ;;
  
  stop)
    echo "Arrêt du conteneur..."
    if $STOP_COMMAND; then
      echo "Conteneur arrêté avec succès."
    else
      echo "Échec de l'arrêt du conteneur."
      exit 1
    fi
    ;;

  help)
    display_help
    ;;
  
  *)
    echo "Commande inconnue."
    display_help
    exit 1
    ;;

  
esac
