{ self, inputs, ... }:
{

  flake.nixosModules.greeter =
    { pkgs, ... }:
    {
      imports = [ inputs.greetdeez.nixosModules.default ];

      services.greetdeez.enable = true;
    };

}
