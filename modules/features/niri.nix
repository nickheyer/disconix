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
            "discord"
            (lib.getExe pkgs.firefox)
            "code"
          ];
	        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          input.keyboard = {
            xkb.layout = "us,ua";
          };

          # DISPLAY ORIENTIATION + RESOLUTION + REFRESH
          outputs."Acer Technologies Acer XF270H 0x7100E343" = {
            mode = "1920x1080@144.001";
            transform = "90";
            position._attrs = { x = 3072; y = 0; };
          };

          outputs."Microstep MPG321CX OLED Unknown" = {
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
            # STARTUP LAYOUT
            {
              matches = [{ app-id = "discord"; at-startup = true; }];
              open-on-output = "Acer Technologies Acer XF270H 0x7100E343";
              open-maximized = true;
            }
            {
              matches = [{ app-id = "firefox"; at-startup = true; }];
              open-on-output = "Microstep MPG321CX OLED Unknown";
              default-column-width.proportion = 0.5;
            }
            {
              matches = [{ app-id = "code"; at-startup = true; }];
              open-on-output = "Microstep MPG321CX OLED Unknown";
              default-column-width.proportion = 0.5;
            }
          ];

          binds = import ./_binds.nix { inherit pkgs lib self'; };
        };

      };

    };

}
