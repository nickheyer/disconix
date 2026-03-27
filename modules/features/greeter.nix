{ self, inputs, ... }:
{

  flake.nixosModules.greeter =
    { pkgs, ... }:
    let
      greetdeez = inputs.nickpkgs.packages.${pkgs.stdenv.hostPlatform.system}.greetdeez;
    in
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.cage}/bin/cage -s -m last -- ${greetdeez}/bin/greetdeez";
          user = "greetdeez";
        };
      };

      users.users.greetdeez = {
        isSystemUser = true;
        group = "greetdeez";
      };
      users.groups.greetdeez = {};
    };

}
