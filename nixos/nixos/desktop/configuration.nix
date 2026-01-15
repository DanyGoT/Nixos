{ config, pkgs, ... }:

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

  programs.steam.enable = true;

  # Home TV
  environment.systemPackages = with pkgs; [
    qbittorrent
    jellyfin
    jellyfin-web
    jellyfin-ffmpeg
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
  # services.sonarr = {
  #   enable = true;
  #   openFirewall = true;
  # };
  users.groups.media = {};
  users.groups.downloads = {};
  users.users.dany.extraGroups = [ "downloads" "media" ];
  users.users.jellyfin.extraGroups = [ "media" ];
  # users.users.sonarr.extraGroups = [ "downloads" "media" ];
}
