{ config, pkgs, callPackage, inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./media.nix
    ./caddy.nix
    ./cloudflared.nix
  ];
  
  networking.hostName = "nixos-desktop";
  #### Display stuff
  hardware.graphics = {
    enable = true;
  };
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.kernelParams = [
    "nvidia-drm.modeset=1"
    "modprobe.blacklist=nouveau"
    "resume=PARTUUID=ae5b81fb-7bbb-4363-89ee-9af14d54e5dc"
    "resume_offset=63436800"
  ];

  boot.resumeDevice = "/dev/disk/by-label/NIXROOT";

  boot.blacklistedKernelModules =  [ "nouveau" ];

  # Disable sleep
  systemd.sleep.settings.Sleep = {
    AllowSuspend="no";
    AllowHibernation="yes";
    AllowHybridSleep="no";
    AllowSuspendThenHibernate="no";
  };

  # Fixes tailscaled losinng DNS across hibernate
  powerManagement.resumeCommands = ''
    ${pkgs.systemd}/bin/systemctl try-restart tailscaled.service
  '';

  zramSwap = {
    enable = true;
    algorithm = "zstd";
    memoryPercent = 110;
    priority = 100;
  };

  swapDevices = [ {
    device = "/swapfile";
    size = 32 * 1024;
    priority = 10;
  } ];

  programs.steam.enable = true;

  services.picom = {
    enable = true;
    backend = "xrender";
    vSync = true;
  };
  services.flatpak.enable = true;

  # Enable xscreensaver service (handles PAM and permissions properly)
  services.xscreensaver.enable = true;


  #########################
  environment.pathsToLink = [ "/libexec" ]; # links /libexec from derivations to /run/current-system/sw
  services.xserver = {
    enable = true;

    # Minor display fixes
    displayManager.setupCommands = ''
      ${pkgs.xrandr}/bin/xrandr --output DP-2 --off || true
      ${pkgs.xrandr}/bin/xrandr --output DP-2 --mode 5120x1440 --rate 240 \
        || ${pkgs.xrandr}/bin/xrandr --output DP-2 --auto || true
    '';

    # Disable DPMS to prevent display power-off issues with DisplayPort
    displayManager.sessionCommands = ''
      xset s off
      xset -dpms
      xset s noblank
    '';

    desktopManager.xterm.enable = false;
    windowManager.stumpwm.enable = true;
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
  services.zerotierone.enable = true;

  # ZeroTier interfaces
  networking.firewall.interfaces."ztrfya33ih".allowedTCPPorts = [ 25565 8096 ];
  networking.firewall.interfaces."zteb4joya6".allowedTCPPorts = [ 25565 8096 ];

  environment.systemPackages = with pkgs; [
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg

    xinit       # Provides startx
    maim        # Screenshots
    flameshot   # Better screenshots
    xclip       # Clipboard for X11
    xscreensaver
    feh         # Background

    spotify
    postman

    prismlauncher

    (btop.override { cudaSupport = true; })
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = false;
  };
  users.groups.media = {};
  users.groups.downloads = {};
  users.users.dany.extraGroups = [ "downloads" "media" ];
  users.users.dany.linger = true;
  users.users.jellyfin.extraGroups = [ "media" ];
}
