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
          system.stateVersion = "23.11";
          services.xremap.config.modmap = [
            {
              name = "layer1";
              remap = { "CapsLock" = { "set_mode" = "layer2"; }; };
              mode = "layer1";
            }
            {
              name = "layer2";
              remap = {
                "CapsLock" = { "set_mode" = "layer1"; };
                "i" = "up";
                "j" = "left";
                "k" = "down";
                "l" = "right";
              };
              mode = "layer2";
            }
          ];
        }
      ];
    };
  };
}
