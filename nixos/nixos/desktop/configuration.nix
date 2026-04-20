{ config, pkgs, callPackage, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  
  networking.hostName = "nixos-desktop";
  #### Display stuff
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = false;
    powerManagement.finegrained = false;
    open = false;  # Use proprietary driver for better early boot support
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.extraModulePackages = [ config.boot.kernelPackages.nvidia_x11 ];

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "modprobe.blacklist=nouveau"
  ];

  # Load NVIDIA modules in initramfs for early boot DisplayPort support
  boot.initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];

  boot.blacklistedKernelModules =  [ "nouveau" ];

  # Disable sleep
  systemd.sleep.extraConfig = ''
    AllowSuspend=no
    AllowHibernation=no
    AllowHybridSleep=no
    AllowSuspendThenHibernate=no
  '';

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 50;
  };

  programs.steam.enable = true;

  # Enable xscreensaver service (handles PAM and permissions properly)
  services.xscreensaver.enable = true;


  #########################
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.xserver = {
    enable = true;

    # Disable DPMS to prevent display power-off issues with DisplayPort
    displayManager.sessionCommands = ''
      xset s off
      xset -dpms
      xset s noblank
    '';

    desktopManager.xterm.enable = false;
    windowManager.i3 = {
      enable = true;
      extraPackages = with pkgs; [
        i3status
        i3blocks
        dmenu
        rofi
     ];
    };
  };
  ##############################

  services.displayManager.defaultSession = "none+i3";


  # Home TV
  environment.systemPackages = with pkgs; [
    qbittorrent
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    xorg.xinit  # Provides startx
    maim        # Screenshots
    xclip       # Clipboard for X11
    xscreensaver

    spotify

    (btop.override { cudaSupport = true; })
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  users.groups.media = {};
  users.groups.downloads = {};
  users.users.dany.extraGroups = [ "downloads" "media" ];
  users.users.jellyfin.extraGroups = [ "media" ];
}
