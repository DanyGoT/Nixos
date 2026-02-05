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
    extraEntries = ''
      menuenry "Windows" {
        insmod chain
        set root=(hd0,1)
        chainloader +1
      }
    '';
  };
  boot.loader.timeout = null;

  # ===== NETWORKING =====
  networking.networkmanager.enable = true;

  # ===== LOCALIZATION =====
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  # ===== KEYMAP =====
  services.xserver.xkb = {
    layout = "no";
    variant = "";
  };
  console.keyMap = "no";
  
  environment.variables = {
    GTK_IM_MODULE = "simple";
  };

  # ===== USER CONFIGURATION =====
  users.users.dany = {
    isNormalUser = true;
    description = "Dany";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    packages = with pkgs; [];
    shell = pkgs.zsh;
  };

  services.getty.autologinUser = "dany";

  # ===== NIX CONFIGURATION =====
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # services.xserver.enable = true;

  # ===== SYSTEM PACKAGES =====
  environment.systemPackages = with pkgs; [
    # Editor and build tools
    neovim
    gcc
    gnumake
    rustc
    cargo
    
    # Language servers and runtimes
    pandoc
    shellcheck
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
    # python3Full
    # python313Packages.python-lsp-server
    

    emacs


    # CLI utilities
    gh
    fd
    fzf
    zoxide
    ripgrep
    stow
    lazygit
    wget
    claude-code
    opencode
    jq
    asciinema # record terminal and create gifs https://github.com/asciinema/asciinema
    
    # Security and DevOps tools
    # openssl
    # mkcert
    # kubectl
    # gcloud
    docker
    docker-compose
    
    direnv
    wofi


    # Wayland/Sway/Niri environment
    niri
    sway
    waybar
    hyprland
    ghostty
    kitty  # Required for default Hyprland config
    fuzzel
    grim
    slurp
    mako
    wl-clipboard
    brightnessctl
    eza
    tmux
    xwayland-satellite

    # Cursor
    bibata-cursors
    
    # Desktop applications
    vscode
    # google-chrome
    brave
    discord
    teams-for-linux
    postgresql
    gimp
    libreoffice

    # Audio
    pavucontrol # PulseAudio Volume Control
    pamixer # Command-line mixer for PulseAudio
    easyeffects
    # bluez # Bluetooth support
    # bluez-tools # Bluetooth tools
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
  virtualisation.docker.enable = true;

  # ===== PROGRAM CONFIGURATION =====
  programs.git = {
    enable = true;
    config = {
      pull.rebase = true;
    };
  };
  programs.direnv.enable = true;

  # programs.hyprland.enable = true;
  # programs.niri.enable = true;
  # programs.waybar.enable = true;
  programs.sway = {
    enable = true;
    wrapperFeatures.gtk = true;
  };

  programs.light.enable = true;

  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };
    interactiveShellInit = ''
      eval "$(zoxide init zsh)"
    '';
  };

  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  # ===== ENVIRONMENT VARIABLES =====
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    EDITOR = "nvim";
    VISUAL = "nvim";
    XCURSOR_THEME = "Bibata-Modern-Cursors";
    XCURSOR_SIZE = "24";
  };

  # ===== SERVICES =====
  services.gnome.gnome-keyring.enable = true;
  services.seatd.enable = true;
  services.openssh.enable = true;
  # services.blueman.enable = true;
  # services.pipewire.wireplumber.enable = false;
  # Enable sound system

# Use PipeWire for audio
  services.pulseaudio.enable = false; # Use Pipewire, the modern sound subsystem

  security.rtkit.enable = true; # Enable RealtimeKit for audio purposes

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  services.power-profiles-daemon.enable = true;

  # Disable default key actions for power buttons
  services.logind.settings.Login = {
    HandleLidSwitchDocked = "suspend";
    HandleLidSwitchExternalPower = "suspend";
    HandleLidSwitch = "suspend";
    HandleHibernateKey = "ignore";
    HandleSuspendKey = "ignore";
    HandleRebootKey = "ignore";
  };

  services.postgresql = {
    enable = true;
    authentication = pkgs.lib.mkOverride 10 ''
      local all all trust
      host all all 127.0.0.1/32 trust
      host all all ::1/128 trust
    '';
  };

  # ===== SYSTEM VERSION =====
  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Don't change this value.
  system.stateVersion = "25.05";

}
