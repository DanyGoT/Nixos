# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running 'nixos-help').

{ config, pkgs, ... }:

let
  gcloud = pkgs.google-cloud-sdk.withExtraComponents (with pkgs.google-cloud-sdk.components; [
    gke-gcloud-auth-plugin
  ]);
in

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ===== BOOT =====
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    useOSProber = true;
    timeout = null;
    configurationLimit = 3;
    extraEntries = ''
      menuenry "Windows" {
        insmod chain
        set root=(hd0,1)
        chainloader +1
      }
    '';
    theme="/boot/grub/themes/Minimal/NIXOS";
  };

  # ===== NETWORKING =====
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ===== LOCALIZATION =====
  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";

  # ===== KEYMAP =====
  services.xserver.xkb = {
    layout = "no";
    variant = "nodeadkeys";
  };
  console.keyMap = "no";

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

  # ===== TEMPORARY: Custom CA Certificates =====
  # TODO: Remove this once mkcert certificates are no longer needed
  security.pki.certificates = [
    (builtins.readFile "/home/dany/.local/share/mkcert/rootCA.pem")
  ];

  # ===== SYSTEM PACKAGES =====
  environment.systemPackages = with pkgs; [
    # Editor and build tools
    neovim
    gcc
    gnumake
    
    # Language servers and runtimes
    lua51Packages.luarocks
    lua51Packages.lua
    lua-language-server
    elixir
    csharp-ls
    dotnet-sdk_9
    dotnet-ef
    go
    gopls
    typescript-language-server
    nodejs
    python3Full
    python313Packages.python-lsp-server

    # CLI utilities
    fzf
    zoxide
    ripgrep
    stow
    lazygit
    wget
    claude-code
    
    # Security and DevOps tools
    openssl
    mkcert
    kubectl
    gcloud
    docker
    docker-compose
    
    # Wayland/Sway environment
    sway
    ghostty
    kitty  # Required for default Hyprland config
    fuzzel
    grim
    slurp
    mako
    wl-clipboard
    brightnessctl
    tmux
    
    # Desktop applications
    vscode
    google-chrome
    discord
    teams-for-linux
    postgresql
    gimp
    libreoffice
  ];

  # ===== FONTS =====
  fonts = {
    fontconfig.enable = true;
    packages = with pkgs; [
      _0xproto
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

  programs.hyprland.enable = true;

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
  };

  # ===== SERVICES =====
  services.gnome.gnome-keyring.enable = true;
  services.seatd.enable = true;
  services.blueman.enable = true;

  # Disable default key actions for power buttons
  services.logind = {
    rebootKey = "ignore";
    suspendKey = "ignore";
    hibernateKey = "ignore";
  };

  # ===== SYSTEM VERSION =====
  # This value determines the NixOS release from which the default
  # settings for stateful data were taken. Don't change this value.
  system.stateVersion = "25.05";
}
