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

      environment.etc."greetd/greetdeez.conf".text = ''
        [ui]
        theme = "cyber"
      '';

      systemd.tmpfiles.rules = [
        "d /var/cache/greetdeez 0755 greetdeez greetdeez -"
      ];

      users.users.greetdeez = {
        isSystemUser = true;
        group = "greetdeez";
      };
      users.groups.greetdeez = {};
    };

}
