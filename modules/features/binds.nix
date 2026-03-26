{ pkgs, lib, self', ... }:
{
  # APP LAUNCHERS
  "Mod+Slash".show-hotkey-overlay = null;
  "Mod+S".spawn-sh = "${lib.getExe self'.packages.discoNoctalia} ipc call launcher toggle";
  "Mod+T".spawn-sh = lib.getExe pkgs.kitty;
  "Mod+Return".fullscreen-window = null;
  "Mod+E".spawn-sh = "${lib.getExe pkgs.kitty} -e ${lib.getExe pkgs.yazi}";
  "Mod+Q".close-window = null;
  "Mod+F".spawn-sh = lib.getExe pkgs.firefox;

  # SCREENSHOTS
  "Print".spawn-sh = "${lib.getExe pkgs.grim} - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";
  "Mod+Shift+S".spawn-sh = ''${lib.getExe pkgs.grim} -g $(${lib.getExe pkgs.slurp}) - | ${lib.getExe pkgs.satty} -f -'';
  "Mod+Print".spawn-sh = "${lib.getExe pkgs.grim} -o $(${lib.getExe pkgs.niri} msg -j outputs | ${lib.getExe pkgs.jq} -r '.[] | select(.is_focused) | .name') - | ${lib.getExe' pkgs.wl-clipboard "wl-copy"}";

  # SCREEN RECORDING TOGGLE
  "Mod+Shift+R".spawn-sh = "PIDFILE=/tmp/wf-recorder.pid; if [ -f \"$PIDFILE\" ] && kill -0 $(cat \"$PIDFILE\") 2>/dev/null; then kill $(cat \"$PIDFILE\"); rm -f \"$PIDFILE\"; ${lib.getExe pkgs.libnotify} 'Recording saved'; else ${lib.getExe pkgs.wf-recorder} -f ~/Videos/recording-$(date +%Y%m%d-%H%M%S).mp4 & echo $! > \"$PIDFILE\"; ${lib.getExe pkgs.libnotify} 'Recording started'; fi";

  # COLOR PICKER
  "Mod+Shift+P".spawn-sh = "${lib.getExe pkgs.hyprpicker} -a -n";

  # LOCK SCREEN
  "Mod+L".spawn-sh = lib.getExe pkgs.swaylock;

  # KEYBOARD LAYOUT
  "Mod+Space".switch-layout = null;

  # OVERVIEW
  "Mod+O".toggle-overview = null;

  # NAVIGATION
  "Mod+Left".focus-column-or-monitor-left = null;
  "Mod+Right".focus-column-or-monitor-right = null;
  "Mod+Home".focus-column-first = null;
  "Mod+End".focus-column-last = null;

  # FOCUS WINDOWS WITHIN A COLUMN
  "Mod+Up".focus-window-or-workspace-up = null;
  "Mod+Tab".focus-window-previous = null;

  # MOVE COLUMNS
  "Mod+Shift+Left".move-column-left-or-to-monitor-left = null;
  "Mod+Shift+Right".move-column-right-or-to-monitor-right = null;

  # MOVE WINDOWS WITHIN A COLUMN
  "Mod+Shift+Up".move-window-up-or-to-workspace-up = null;
  "Mod+Shift+Down".move-window-down-or-to-workspace-down = null;

  # COLUMN WIDTH
  "Mod+R".switch-preset-column-width = null;
  "Mod+Minus".set-column-width = "-10%";
  "Mod+Equal".set-column-width = "+10%";
  "Mod+Shift+E".expand-column-to-available-width = null;

  # WINDOW HEIGHT
  "Mod+Shift+Minus".set-window-height = "-10%";
  "Mod+Shift+Equal".set-window-height = "+10%";

  # MAXIMIZE & CENTER
  "Mod+M".maximize-column = null;

  # FLOATING
  "Mod+V".toggle-window-floating = null;
  "Mod+Shift+V".switch-focus-between-floating-and-tiling = null;

  # TABBED DISPLAY
  "Mod+W".toggle-column-tabbed-display = null;

  # WORKSPACES
  "Mod+Shift+PageDown".move-column-to-workspace-down = null;
  "Mod+Shift+PageUp".move-column-to-workspace-up = null;

  # MEDIA KEYS
  "XF86AudioRaiseVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+";
  "XF86AudioLowerVolume".spawn-sh = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-";
  "XF86AudioMute".spawn-sh = "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle";
  "XF86AudioPlay".spawn-sh = "${lib.getExe pkgs.playerctl} play-pause";
  "XF86AudioNext".spawn-sh = "${lib.getExe pkgs.playerctl} next";
  "XF86AudioPrev".spawn-sh = "${lib.getExe pkgs.playerctl} previous";
}
