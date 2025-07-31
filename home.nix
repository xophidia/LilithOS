{ config, pkgs, ... }:

{
  # TODO please change the username & home directory to your own
  home.username = "xophidia";
  home.homeDirectory = "/home/xophidia";
  home.enableNixpkgsReleaseCheck = false;
  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  # set cursor size and dpi for 4k monitor
  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };


  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [

    neofetch
    nnn # terminal file manager
    nautilus

    # archives
    zip
    xz
    unzip
    p7zip

    # utils
    ripgrep # recursively searches directories for a regex pattern
    jq      # A lightweight and flexible command-line JSON processor
    yq-go   # yaml processor https://github.com/mikefarah/yq
    fzf     # A command-line fuzzy finder

    # networking tools
    mtr     # A network diagnostic tool
    iperf3
    dnsutils  # `dig` + `nslookup`
    ldns    # replacement of `dig`, it provide the command `drill`
    aria2   # A lightweight multi-protocol & multi-source command-line download utility
    socat   # replacement of openbsd-netcat
    nmap    # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # misc
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg

    # nix related
    #
    # it provides the command `nom` works just like `nix`
    # with more details log output
    nix-output-monitor

    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon
    iotop # io monitoring
    iftop # network monitoring

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files

    # system tools
    sysstat
    lm_sensors # for `sensors` command
    ethtool
    pciutils # lspci
    usbutils # lsusb

    # personnalisation GNOME
    gnomeExtensions.user-themes
    gnomeExtensions.tray-icons-reloaded
    gnomeExtensions.vitals
    gnomeExtensions.dash-to-panel
    gnomeExtensions.sound-output-device-chooser
    gnomeExtensions.space-bar
    #gnomeExtensions.new-mail-indicator
    
    # Development

    docker-compose
    uv

    # Android Static analysis

    apktool
    jadx
    apkid
    sqlite    

    # Android dynamic analysis

    frida-tools
    genymotion
    ghidra
    ghidra-extensions.gnudisassembler
    

  ];

  programs.vscode = {
   enable = true;
    package = pkgs.vscode;
    profiles.default.userSettings = {
      "editor.formatOnSave" = false;
      "workbench.colorTheme" = "Dracula Theme";
      "terminal.integrated.scrollback" = 10000;
    };
    profiles.default.extensions = with pkgs.vscode-marketplace; [
      dracula-theme.theme-dracula
      ms-python.python
      vscjava.vscode-java-pack
      vscjava.vscode-gradle
    ];
  };

  xdg.desktopEntries = {
    "gnome-system-monitor" = {
      name = "Moniteur système";
      exec = "gnome-system-monitor";
      icon = "utilities-system-monitor";
      type = "Application";
      genericName = "Moniteur de ressources";
      comment = "Affiche l'utilisation des ressources système";
      startupNotify = true;
      categories = [ "Utility" ];
    };
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Name";
    userEmail = "email@nixos.com";
  };

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

 programs.bash = {
    enable = true;
    enableCompletion = true;
    # TODO add your custom bashrc here
  };


  dconf.settings = {
    "org/gnome/shell" = {
      enabled-extensions = [
        "user-theme@gnome-shell-extensions.gcampax.github.com"
        "trayIconsReloaded@selfmade.pl"
        "Vitals@CoreCoding.com" #correspond à la barre vitale à droite
        "dash-to-panel@jderose9.github.com"
        "sound-output-device-chooser@kgshank.net"
        "space-bar@luchrioh"
      ];
      favorite-apps = [
        "firefox.desktop"
	"google-chrome.desktop"
        "code.desktop"
        "com.mitchellh.ghostty.desktop"
        "org.gnome.Terminal.desktop"
        "android-studio.desktop"
        "org.gnome.Nautilus.desktop"
      ];
    };
   "org/gnome/shell/extensions/vitals" = {
      show-storage = false;
      show-voltage = true;
      show-memory = true;
      show-fan = true;
      show-temperature = true;
      show-processor = true;
      show-network = true;
    }; 

   "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
      enable-hot-corners = false;
    };
    "org/gnome/desktop/wm/preferences" = {
      workspace-names = [ "Eden" ];
    };
    "org/gnome/desktop/screensaver" = {
      picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/vnc-d.png";
      primary-color = "#3465a4";
      secondary-color = "#000000";
    };
    "org/gnome/desktop/background" = {
        picture-uri = "file:///run/current-system/sw/share/backgrounds/gnome/wallpaper1.jpg";
	picture-uri-dark = "file:///etc/nixos/backgrounds/lilithOS_1920_1200.png";
        };
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "25.05";
}
