{

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    sops-nix.url = "github:Mic92/sops-nix";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";

    pocr.url = "github:DanyGoT/pocr";
    fff-el.url = "github:JonasThowsen/fff.el";

    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { self, nixpkgs, sops-nix, dms, fff-el, pocr, ...}@inputs: {
    nixosConfigurations = {
      laptop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          dms.nixosModules.dank-material-shell
          ./common.nix
          ./laptop/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };

      desktop = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./common.nix
          ./desktop/configuration.nix
          sops-nix.nixosModules.sops
        ];
      };
    };
  };
}

