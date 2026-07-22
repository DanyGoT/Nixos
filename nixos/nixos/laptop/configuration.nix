{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # inputs.dms.nixosModules.dank-material-shell
  ];
  networking.hostName = "nixos-laptop";
  boot.loader.grub.theme = "/boot/grub/themes/Minimal/NIXOS";
 
  programs.sway = { enable = true; wrapperFeatures.gtk = true; };
  programs.dank-material-shell.enable = true;
  services.upower.enable = true;

  environment.systemPackages = with pkgs; [ flameshot ];
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
        disabledGrimWarning = true;
      };
    };
  };
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --time --cmd sway";
        user = "greeter";
      };
    };
  };
}
