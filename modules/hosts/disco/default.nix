{ self, inputs, ... }:
{

  flake.nixosConfigurations.disco = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.discoConfiguration
    ];
  };

}
