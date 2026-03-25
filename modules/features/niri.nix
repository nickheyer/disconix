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
          spawn-at-startup = [
            (lib.getExe self'.packages.discoNoctalia)
          ];
	        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          input.keyboard = {
            xkb.layout = "us,ua";
          };

          outputs."DP-4" = {
            mode = "1920x1080@144.001";
            transform = "270";
            position._attrs = { x = 0; y = 0; };
          };

          outputs."DP-5" = {
            mode = "3840x2160@60.000";
            scale = 1.25;
            position._attrs = { x = 1080; y = 0; };
          };

          layout.gaps = 5;

          binds = {
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.discoNoctalia} ipc call launcher toggle";
            "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+Q".close-window = null;
          };
        };

      };

    };

}
