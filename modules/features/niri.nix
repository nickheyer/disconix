{ self, inputs, ... }:
{

  flake.nixosModules.niri =
    { pkgs, lib, ... }:
    {
      programs.niri = {
        enable = true;
        package = self.packages.${pkgs.stdenv.hostPlatform.system}.discoNiri;
      };
    };

  perSystem =
    { pkgs, lib, self', ... }:
    {
      packages.discoNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
          
          # START UP DEPS
          spawn-at-startup = [
            (lib.getExe self'.packages.discoNoctalia)
          ];
	        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          input.keyboard = {
            xkb.layout = "us,ua";
          };

          # DISPLAY ORIENTIATION + RESOLUTION + REFRESH
          outputs."DP-4" = {
            mode = "1920x1080@144.001";
            transform = "90";
            position._attrs = { x = 3072; y = 0; };
          };

          outputs."DP-5" = {
            mode = "3840x2160@239.998";
            scale = 1.25;
            position._attrs = { x = 0; y = 0; };
          };

          # LAYOUT
          layout.gaps = 5;

          # WINDOW RULES
          window-rules = [
            {
              matches = [{ app-id = "firefox"; title = "Picture-in-Picture"; }];
              open-floating = true;
            }
          ];

          binds = import ./binds.nix { inherit pkgs lib self'; };
        };

      };

    };

}
