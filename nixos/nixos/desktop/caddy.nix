{ ... }:

{
  services.caddy = {
    enable = true;
    virtualHosts."http://:80".extraConfig = ''
      redir /switchboard /
      redir /qbittorrent /qbittorrent/
      redir /ai /ai/
      redir /storage /storage/

      # These know their own prefix (URL base / Base URL), so it's kept.
      handle /jellyfin* {
        reverse_proxy 127.0.0.1:8097
      }
      handle /sonarr* {
        reverse_proxy 127.0.0.1:8989
      }
      handle /radarr* {
        reverse_proxy 127.0.0.1:7878
      }
      handle /prowlarr* {
        reverse_proxy 127.0.0.1:9696
      }

      # These don't, so it's stripped.
      handle_path /qbittorrent/* {
        reverse_proxy 127.0.0.1:8081
      }
      handle_path /ai/* {
        reverse_proxy 127.0.0.1:8791
      }
      handle_path /storage/* {
        reverse_proxy 127.0.0.1:8792
      }

      handle {
        reverse_proxy 127.0.0.1:8790
      }
    '';

    virtualHosts."http://:8096".extraConfig = ''
      @noprefix not path /jellyfin /jellyfin/*
      rewrite @noprefix /jellyfin{uri}
      reverse_proxy 127.0.0.1:8097
    '';
  };

  services.sonarr.settings.server.urlbase = "/sonarr";
  services.radarr.settings.server.urlbase = "/radarr";
  services.prowlarr.settings.server.urlbase = "/prowlarr";
}
