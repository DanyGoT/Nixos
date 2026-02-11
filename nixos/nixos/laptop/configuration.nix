{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    # inputs.dms.nixosModules.dank-material-shell
  ];
  networking.hostName = "nixos-laptop";
  boot.loader.grub.theme = "/boot/grub/themes/Minimal/NIXOS";
 
  programs.dank-material-shell.enable = true;
  services.upower.enable = true;
}
