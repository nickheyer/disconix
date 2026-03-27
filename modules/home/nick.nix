{ self, inputs, ... }:
{
  flake.nixosModules.nickHome =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;
      home-manager.backupFileExtension = "backup";

      home-manager.users.nick = {
        home.stateVersion = "25.11";

        # PACKAGES
        home.packages = with pkgs; [
          discord
          claude-code
          kitty
          meslo-lgs-nf
          satty

          # MEDIA + AUDIO
          mpv
          playerctl
          pavucontrol
          cava

          # RICE
          fastfetch
          btop
          swaylock
          hyprpicker
          cliphist
          libnotify
        ];

        # NIRI
        home.pointerCursor = {
          name = "catppuccin-mocha-dark-cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
          size = 24;
          gtk.enable = true;
        };

        # ZSH
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;
          shellAliases = {
            rebuild = "sudo nixos-rebuild switch --flake ~/disconix#disco";
            ff = "fastfetch";
          };
          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
          ];

          initContent = ''
            source ${./p10k.zsh}
          '';
        };

        # GIT
        programs.git = {
          enable = true;
          settings.user.name = "nickheyer";
          settings.user.email = "nick@heyer.app";
        };

        # YAZI
        programs.yazi = {
          enable = true;
          enableZshIntegration = true;
          shellWrapperName = "y";
        };

        # MPV
        programs.mpv = {
          enable = true;
          config = {
            gpu-api = "vulkan";
            hwdec = "auto-safe";
            vo = "gpu-next";
          };
        };

        # KITTY
        programs.kitty = {
          enable = true;
          settings = {
            # FONT
            font_family = "MesloLGS NF";
            font_size = 12;
            disable_ligatures = "never";

            # WINDOW
            background_opacity = "0.75";
            window_padding_width = 12;
            placement_strategy = "center";
            hide_window_decorations = "yes";
            confirm_os_window_close = 0;

            # CURSOR
            cursor_shape = "beam";
            cursor_beam_thickness = "1.5";
            cursor_blink_interval = 0;

            # SCROLLBACK
            scrollback_lines = 10000;

            # TABS
            tab_bar_edge = "bottom";
            tab_bar_style = "powerline";
            tab_powerline_style = "slanted";

            # URL
            url_style = "curly";
            detect_urls = "yes";

            # BELL
            enable_audio_bell = "no";
            visual_bell_duration = "0.0";

            # CATPPUCCIN MOCHA
            foreground = "#CDD6F4";
            background = "#1E1E2E";
            selection_foreground = "#1E1E2E";
            selection_background = "#F5E0DC";
            cursor = "#F5E0DC";
            cursor_text_color = "#1E1E2E";
            url_color = "#F5E0DC";
            active_border_color = "#B4BEFE";
            inactive_border_color = "#6C7086";
            bell_border_color = "#F9E2AF";
            active_tab_foreground = "#11111B";
            active_tab_background = "#CBA6F7";
            inactive_tab_foreground = "#CDD6F4";
            inactive_tab_background = "#181825";
            tab_bar_background = "#11111B";

            # BLACK
            color0 = "#45475A";
            color8 = "#585B70";
            # RED
            color1 = "#F38BA8";
            color9 = "#F38BA8";
            # GREEN
            color2 = "#A6E3A1";
            color10 = "#A6E3A1";
            # YELLOW
            color3 = "#F9E2AF";
            color11 = "#F9E2AF";
            # BLUE
            color4 = "#89B4FA";
            color12 = "#89B4FA";
            # MAGENTA
            color5 = "#F5C2E7";
            color13 = "#F5C2E7";
            # CYAN
            color6 = "#94E2D5";
            color14 = "#94E2D5";
            # WHITE
            color7 = "#BAC2DE";
            color15 = "#A6ADC8";
          };
        };

        # VSCODE
        programs.vscode = {
          enable = true;
          profiles.default.userSettings = {
            "terminal.integrated.fontFamily" = "MesloLGS NF";
            "git.confirmSync" = false;
            "security.workspace.trust.untrustedFiles" = "open";
            "chat.agent.enabled" = false;
          };
        };

        # BOOKMARKS (THUNAR SIDEBAR)
        gtk.gtk3.bookmarks = [
          "file:///mnt/primary Primary"
          "file:///mnt/secondary Secondary"
        ];

        # DESKTOP OVERRIDES
        xdg.desktopEntries.discord = {
          name = "Discord";
          exec = "discord --ozone-platform=wayland --enable-features=UseOzonePlatform";
          icon = "discord";
          type = "Application";
        };
      };
    };
}