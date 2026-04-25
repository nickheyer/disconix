{ self, inputs, ... }:
{

  flake.nixosModules.greeter =
    { pkgs, ... }:
    let
      greetdeez = inputs.nickpkgs.packages.${pkgs.stdenv.hostPlatform.system}.greetdeez;
      wlrootsNvidia = pkgs.wlroots_0_19.overrideAttrs (old: {
        patches = (old.patches or []) ++ [ ./patches/wlroots-nvidia.patch ];
      });
      cageNvidia = pkgs.cage.override { wlroots_0_19 = wlrootsNvidia; };
    in
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${cageNvidia}/bin/cage -s -m last -- ${greetdeez}/bin/greetdeez";
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
      };
      users.groups.greetdeez = {};
    };

}
