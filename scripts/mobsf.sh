#!/bin/bash

show_help() {
  echo "Usage: $0 {start|stop|help}"
  echo
  echo "  start  : Démarre le conteneur Docker Mobsf."
  echo "  stop   : Arrête le conteneur Docker Mobsf."
  echo "  help   : Affiche ce message d'aide."
}

start_container() {
  echo "Démarrage du conteneur Docker Mobsf..."
  docker run -d -p 8000:8000 opensecurity/mobile-security-framework-mobsf:latest
  firefox http://localhost:8000 &
}

stop_container() {
  echo "Arrêt du conteneur Docker Mobsf..."
  if [ -f "$CONTAINER_ID_FILE" ]; then
    container_id=$(docker ps -a | grep "mobile-security-framework-mobsf" | cut -d " " -f1)
    docker container stop $container_id
  else
    echo "Aucun conteneur en cours d'exécution."
  fi
}

case "$1" in
  start)
    start_container
    ;;
  stop)
    stop_container
    ;;
  help)
    show_help
    ;;
  *)
    echo "Argument invalide. Utilise 'start', 'stop' ou 'help'."
    show_help
    exit 1
    ;;
esac

