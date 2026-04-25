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

      systemd.services.greetd.environment.WLR_RENDERER = "vulkan";


      environment.etc."greetd/greetdeez.conf".text = ''
        [ui]
        theme = "doom"

        [window]
        scale = 2
      '';

      systemd.tmpfiles.rules = [
        "d /var/cache/greetdeez 0755 greetdeez greetdeez -"
      ];

      users.users.greetdeez = {
        isSystemUser = true;
        group = "greetdeez";
        extraGroups = [ "video" "render" ];
      };
      users.groups.greetdeez = {};
    };

}
