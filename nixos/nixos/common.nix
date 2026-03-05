{ config, pkgs, ... }:

{
  # ===== BOOT =====
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    configurationLimit = 3;
  };
  boot.loader.timeout = null;

  # ===== NETWORKING =====
  networking.networkmanager.enable = true;

  # ===== LOCALIZATION =====
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console.keyMap = "no";
  services.xserver.xkb.layout = "no";

  # ===== USER CONFIGURATION =====
  users.users.dany = {
    isNormalUser = true;
    description = "Dany";
    extraGroups = [ "networkmanager" "wheel" ];
    shell = pkgs.zsh;
  };

  services.getty.autologinUser = "dany";

  # ===== NIX CONFIGURATION =====
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # ===== SYSTEM PACKAGES =====
  environment.systemPackages = with pkgs; [
    # Build tools
    gcc
    gnumake
    cmake
    libtool

    # Language servers and runtimes
    lua51Packages.luarocks
    lua51Packages.lua
    lua-language-server
    elixir
    elixir-ls
    csharp-ls
    dotnet-sdk_9
    dotnet-ef
    go
    gopls
    gotools
    typescript-language-server
    nodejs
    python3
    pyright
    ruff
    uv
    emacs

    texliveFull

    # CLI tools
    bat
    btop
    claude-code
    opencode
    dust
    eza
    fd
    fzf
    gh
    jq
    lazygit
    ripgrep
    sops
    stow
    tldr
    tmux
    wget
    zoxide
    yazi
    bluetui

    # PDF
    pdf2svg

    # Wayland/Sway
    waybar
    ghostty
    fuzzel
    grim
    slurp
    mako
    wl-clipboard
    brightnessctl
    bibata-cursors

    # Desktop apps
    brave
    discord
    gimp
    libreoffice
    teams-for-linux
    vscode
    thunar
    thunar-archive-plugin
    thunar-volman
    gvfs

    # DevOps
    podman-compose
    postgresql

    # Audio
    easyeffects
    pamixer
    pavucontrol
  ];

  # ===== FONTS =====
  fonts = {
    fontDir.enable = true;
    fontconfig.enable = true;
    packages = with pkgs; [
      nerd-fonts._0xproto
      nerd-fonts.symbols-only
      font-awesome
    ];
  };

  # ===== VIRTUALISATION =====
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;  # alias docker to podman
    defaultNetwork.settings.dns_enabled = true;
  };

  # ===== PROGRAMS =====
  programs.direnv.enable = true;
  programs.nix-ld.enable = true;
  programs.neovim = { enable = true; defaultEditor = true; };
  programs.sway = { enable = true; wrapperFeatures.gtk = true; };
  programs.git = { enable = true; config.pull.rebase = true; };
  programs.zsh = {
    enable = true;
    ohMyZsh = { enable = true; theme = "robbyrussell"; };
    interactiveShellInit = ''
      export PATH="$HOME/.local/bin:$PATH"
      eval "$(zoxide init zsh)"
      z() { __zoxide_z "$@" && pwd; }
    '';
  };

  # ===== ENVIRONMENT =====
  environment.sessionVariables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
    GTK_IM_MODULE = "simple";
    NIXOS_OZONE_WL = "1";
    XCURSOR_THEME = "Bibata-Modern-Cursors";
    XCURSOR_SIZE = "24";
  };

  xdg.mime.defaultApplications = {
    "inode/directory" = ["thunar.desktop"];
    "application/x-directory" = ["thunar.desktop"];
  };

  # ===== SERVICES =====
  services.emacs = {
    enable = true;
    package = pkgs.emacs;
  };
  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  services.seatd.enable = true;
  services.openssh.enable = true;

  services.tailscale.enable = true;
  networking.firewall = {
    allowedUDPPorts = [ 41641 ];
  };

  services.syncthing = {
    enable = true;
    user = "dany";
    dataDir = "/home/dany/.config/syncthing";
    configDir = "/home/dany/.config/syncthing";

    openDefaultPorts = true;
    overrideDevices = false;
    overrideFolders = false;

    settings = {
      options = {
        urAccepted = -1; # Disable usage reporting
      };
      devices = { 
        "tablet" = { id = config.sops.templates."syncthing-tablet-id".content; };
      };
      folders = {
        "skole" = {
          id = "skole";
          path = "/home/dany/sync/skole";
          devices = [ "tablet" ];
          type = "sendreceive";
          fsWatcherEnabled = true;
          versioning = {
            type = "staggered";
            params = {
              maxAge = "2592000"; # 30 days
            };
          };
          rescanIntervalS = 3600;
          ignorePerms = false;
        };
      };
    };
  };
  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = "/var/lib/sops-nix/key.txt";
    secrets = {
      "syncthing/tablet-id" = {
        owner = "dany";
      };
    };
    templates."syncthing-tablet-id".content = config.sops.placeholder."syncthing/tablet-id";
  };

  # ===== BLUETOOTH =====
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  # ===== AUDIO (PipeWire) =====
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = { 
    enable = true; 
    # wireplumber = true; 
    alsa.enable = true; 
    alsa.support32Bit = true; 
    pulse.enable = true; 
  };

  services.logind.settings.Login = {
    HandleLidSwitch = "suspend";
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleHibernateKey = "ignore";
    HandleSuspendKey = "ignore";
    HandleRebootKey = "ignore";
  };

  # PostgreSQL - start manually with: sudo systemctl start postgresql
  services.postgresql = {
    enable = false;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  # ===== SYSTEM VERSION =====
  system.stateVersion = "25.05";

}
