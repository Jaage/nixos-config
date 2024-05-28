{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-mozilla.url = "github:mozilla/nixpkgs-mozilla";
    nil.url = "github:oxalica/nil";
    xremap-flake.url = "github:xremap/nix-flake";
  };

  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = {inherit inputs;};
      modules = [
        ./configuration.nix
        inputs.xremap-flake.nixosModules.default {
          system.stateVersion = "24.11";
          services.xremap.config.modmap = [
            {
              name = "Global";
              remap = { "CapsLock" = "Esc"; };
            }
          ];
        }
      ];
    };
  };
}
