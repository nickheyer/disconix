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

          # KEYBINDS
          binds = {
            # APP LAUNCHERS
            "Mod+S".spawn-sh = "${lib.getExe self'.packages.discoNoctalia} ipc call launcher toggle";
            "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
            "Mod+Return".fullscreen-window = null;
            "Mod+E".spawn-sh = "${lib.getExe pkgs.kitty} -e ${lib.getExe pkgs.yazi}";
            "Mod+Q".close-window = null;

            # SCREENSHOTS
            "Print".spawn-sh = "${lib.getExe pkgs.grim} - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
            "Mod+Shift+S".spawn-sh = ''${lib.getExe pkgs.grim} -g "$(${lib.getExe pkgs.slurp})" - | ${lib.getExe pkgs.satty} -f -'';
            "Mod+Print".spawn-sh = "${lib.getExe pkgs.grim} -o \"$(${lib.getExe self'.packages.discoNiri} msg -j outputs | ${lib.getExe pkgs.jq} -r '.[] | select(.is_focused) | .name')\" - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";

            # SCREEN RECORDING TOGGLE
            "Mod+Shift+R".spawn-sh = "if ${pkgs.procps}/bin/pgrep -x wf-recorder > /dev/null; then ${pkgs.procps}/bin/pkill -x wf-recorder && ${lib.getExe pkgs.libnotify} 'Recording saved'; else ${lib.getExe pkgs.wf-recorder} -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4 & ${lib.getExe pkgs.libnotify} 'Recording started'; fi";

            # COLOR PICKER
            "Mod+Shift+P".spawn-sh = "${lib.getExe pkgs.hyprpicker} -a -n";

            # LOCK SCREEN
            "Mod+L".spawn-sh = lib.getExe pkgs.swaylock;

            # SCROLL BETWEEN COLUMNS (left/right on the conveyor belt)
            "Mod+Left".focus-column-left = null;
            "Mod+Right".focus-column-right = null;
            "Mod+Home".focus-column-first = null;
            "Mod+End".focus-column-last = null;

            # FOCUS WINDOWS WITHIN A COLUMN (stacked vertically)
            "Mod+Up".focus-window-up = null;
            "Mod+Down".focus-window-down = null;

            # REORDER COLUMNS
            "Mod+Shift+Left".move-column-left = null;
            "Mod+Shift+Right".move-column-right = null;

            # REORDER WINDOWS WITHIN A COLUMN
            "Mod+Shift+Up".move-window-up = null;
            "Mod+Shift+Down".move-window-down = null;

            # COLUMN COMPOSITION (pull windows in / kick them out)
            "Mod+BracketLeft".consume-or-expel-window-left = null;
            "Mod+BracketRight".consume-or-expel-window-right = null;

            # COLUMN WIDTH
            "Mod+R".switch-preset-column-width = null;
            "Mod+Minus".set-column-width = "-10%";
            "Mod+Equal".set-column-width = "+10%";

            # WINDOW HEIGHT (within a column)
            "Mod+Shift+Minus".set-window-height = "-10%";
            "Mod+Shift+Equal".set-window-height = "+10%";

            # FIREFOX
            "Mod+F".spawn-sh = lib.getExe pkgs.firefox;

            # MAXIMIZE
            "Mod+M".maximize-column = null;
            "Mod+C".center-column = null;

            # MONITORS (dual setup)
            "Mod+Comma".focus-monitor-left = null;
            "Mod+Period".focus-monitor-right = null;
            "Mod+Shift+Comma".move-column-to-monitor-left = null;
            "Mod+Shift+Period".move-column-to-monitor-right = null;

            # MEDIA KEYS
            "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
            "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
            "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
            "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
            "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";
            "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";
          };
        };

      };

    };

}
