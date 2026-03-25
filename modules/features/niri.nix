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
    { pkgs, lib, ... }:
    {
      packages.discoNiri = inputs.wrapper-modules.wrappers.niri.wrap {
        inherit pkgs;
        settings = {
	  xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
          input.keyboard = {
            xkb.layout = "us,ua";
          };

          layout.gaps = 5;

          binds = {
            "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+Q".close-window = null;
          };
        };

      };

    };

}
