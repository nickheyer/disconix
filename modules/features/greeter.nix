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

      systemd.services.greetd.environment = {
        WEBKIT_DISABLE_DMABUF_RENDERER = "1";
      };

      environment.etc."greetd/greetdeez.conf".text = ''
        [ui]
        theme = "cyber"

        [window]
        scale = 2
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
