{ self, ... }:
{

  flake.nixosModules.greeter =
    { pkgs, ... }:
    {
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.defaultSession = "niri";

      services.displayManager.sddm.setupScript = let
        xrandr = "${pkgs.xrandr}/bin/xrandr";
        awk = "${pkgs.gawk}/bin/awk";
      in ''
        # Disable all but the largest monitor to prevent duplicate/misrotated login screen
        ${xrandr} --query > /tmp/sddm-xrandr.log 2>&1
        best=""
        best_area=0
        for out in $(${xrandr} --query | ${awk} '/ connected/{print $1}'); do
          area=$(${xrandr} --query | ${awk} -v o="$out" '
            $0 ~ "^"o" connected" { match($0, /([0-9]+)mm x ([0-9]+)mm/, a); print a[1]*a[2] }
          ')
          if [ "''${area:-0}" -gt "$best_area" ]; then
            best_area="$area"
            best="$out"
          fi
        done
        for out in $(${xrandr} --query | ${awk} '/ connected/{print $1}'); do
          [ "$out" != "$best" ] && ${xrandr} --output "$out" --off
        done
      '';

      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };
    };

}
