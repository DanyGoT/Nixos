{ pkgs, ... }:

{
  services.qbittorrent = {
    enable = true;
    webuiPort = 8081;
    openFirewall = false;
  };
  systemd.services.qbittorrent.serviceConfig.UMask = "0002";

  services.prowlarr.enable = true;

  services.sonarr.enable = true;

  services.radarr.enable = true;

  systemd.services.sonarr.serviceConfig.TemporaryFileSystem = "/mnt";
  systemd.services.radarr.serviceConfig.TemporaryFileSystem = "/mnt";

  services.seerr.enable = true;
  # Home LAN: Seerr, and Jellyfin via Caddy on 8096 (Android TV).
  networking.firewall.interfaces."wlp0s20f3".allowedTCPPorts = [ 5055 8096 ];

  users.users.qbittorrent.extraGroups = [ "downloads" ];
  users.users.sonarr.extraGroups = [ "downloads" "media" ];
  users.users.radarr.extraGroups = [ "downloads" "media" ];

  systemd.tmpfiles.rules = [
    "d /data/media 0755 root root -"
    "d /data/media/movies 2775 root media -"
    "d /data/media/shows 2775 root media -"
  ];

  environment.systemPackages = [ pkgs.qbittorrent-cli ];
}
