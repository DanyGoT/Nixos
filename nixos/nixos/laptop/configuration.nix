{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  networking.hostName = "nixos-laptop";
  boot.loader.grub.theme = "/boot/grub/themes/Minimal/NIXOS";
}
