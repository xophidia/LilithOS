{ config, pkgs, lib, ... }:

{
 
 virtualisation.docker = {
  enable = true;
  # Customize Docker daemon settings using the daemon.settings option
  daemon.settings = {
    dns = [ "1.1.1.1" "8.8.8.8" ];
    log-driver = "journald";
    registry-mirrors = [ "https://mirror.gcr.io" ];
    storage-driver = "overlay2";
  };
  # Use the rootless mode - run Docker daemon as non-root user
  #rootless = {
  #  enable = true;
  #  setSocketVariable = true;
  #};
};

users.users.xophidia = {
 isNormalUser = true;
 extraGroups = [ "wheel" "docker" ];
};

systemd.services.docker-image-pull = {
    description = "Pull Redroid12 Docker Image";
    wantedBy = [ "multi-user.target" ];
    after = [ "docker.service" ];
    requires = [ "docker.service" ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.docker}/bin/docker pull redroid/redroid:12.0.0-latest";
    };
  };

}
