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
          services.xremap.yamlConfig = ''
            modmap:
              - name: Caps Lock to Right Control for shortcut purposes
                remap:
                  CapsLock: rightctrl
            keymap:
              - name: Miscellaneous Shortcuts
                remap:
                  rightctrl-i: up
                  rightctrl-j: left
                  rightctrl-k: down
                  rightctrl-l: right
                  rightctrl-o: backspace
                  rightctrl-u: delete
                  rightctrl-h: home
                  rightctrl-;: end
          '';
        }
      ];
    };
  };
}
