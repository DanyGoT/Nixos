{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];
  boot.loader.grub.theme = "/boot/grub/themes/Minimal/NIXOS";
}
