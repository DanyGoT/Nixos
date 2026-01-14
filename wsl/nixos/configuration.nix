# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

# NixOS-WSL specific options are documented on the NixOS-WSL repository:
# https://github.com/nix-community/NixOS-WSL

{ config, lib, pkgs, ... }:

{
  imports = [
    # include NixOS-WSL modules
    <nixos-wsl/modules>
  ];

  wsl.enable = true;
  wsl.defaultUser = "nixos";
  wsl.wslConf.automount.options = "metadata,uid=1000,gid=100,umask=22,fmask=11,cache=loose";

  users.defaultUserShell = pkgs.zsh;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim
    gcc
    gnumake
    lua51Packages.luarocks
    lua51Packages.lua
    lua-language-server

    # Needed for latex
    texlab # LSP for LaTeX
    (texlive.combine {
      inherit (texlive) scheme-basic latexmk;
    })
    tree-sitter
    nodejs
    #
    
    claude-code

    python3Full
    pyright  # Better Python LSP server
    ruff     # Fast Python linter and formatter
    go
    
    gopls
    

    texpresso

    fzf
    zoxide
    ripgrep
    stow
    lazygit
    age
    sops
    eza
    tmux

    wget

  ];


  programs.neovim.enable = true ;
  programs.neovim.defaultEditor = true;
  programs.nix-ld.enable = true;
  programs.git.enable = true;
  programs.zsh = {
    enable = true;
    ohMyZsh = {
      enable = true;
      theme = "robbyrussell";
    };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
}
