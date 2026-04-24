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
          vesktop
          claude-code
          kitty
          meslo-lgs-nf
          maple-mono.NF
          nerd-fonts.jetbrains-mono
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

        # PATH
        home.sessionPath = [
          "$HOME/go/bin"
        ];

        # NIRI
        home.pointerCursor = {
          name = "catppuccin-mocha-dark-cursors";
          package = pkgs.catppuccin-cursors.mochaDark;
          size = 24;
          gtk.enable = true;
        };

        # DIRENV AUTOSHELL
        programs.direnv = {
          enable = true;
          nix-direnv.enable = true;
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
            search() { nix search nixpkgs "$@" | less }
            shpkg() { nix shell nixpkgs#"$@"; }
            runpkg() { nix run nixpkgs#"$@"; }
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
            "editor.fontSize" = 12;
            "editor.fontFamily" = "'Maple Mono', 'monospace', monospace, 'JetBrainsMono Nerd Font'";
            "editor.scrollbar.vertical" = "visible";
            "editor.scrollbar.verticalScrollbarSize" = 12;
            "editor.scrollbar.horizontal" = "visible";
            "editor.minimap.enabled" = false;
            "editor.hover.delay" = 700;
            "editor.unicodeHighlight.nonBasicASCII" = false;
            "editor.largeFileOptimizations" = false;
            "explorer.confirmDelete" = false;
            "explorer.confirmDragAndDrop" = false;
            "explorer.confirmPasteNative" = false;
            "explorer.fileNesting.patterns" = {
              "*.ts" = "\${capture}.js";
              "*.js" = "\${capture}.js.map, \${capture}.min.js, \${capture}.d.ts";
              "*.jsx" = "\${capture}.js";
              "*.tsx" = "\${capture}.ts";
              "tsconfig.json" = "tsconfig.*.json";
              "package.json" = "package-lock.json, yarn.lock, pnpm-lock.yaml, bun.lockb, bun.lock";
              "Cargo.toml" = "Cargo.lock";
              "*.sqlite" = "\${capture}.\${extname}-*";
              "*.db" = "\${capture}.\${extname}-*";
              "*.sqlite3" = "\${capture}.\${extname}-*";
              "*.db3" = "\${capture}.\${extname}-*";
              "*.sdb" = "\${capture}.\${extname}-*";
              "*.s3db" = "\${capture}.\${extname}-*";
            };
            "git.autofetch" = true;
            "git.confirmSync" = false;
            "git.openRepositoryInParentFolders" = "never";
            "git.ignoreRebaseWarning" = true;
            "terminal.integrated.fontFamily" = "MesloLGS NF";
            "terminal.integrated.enableMultiLinePasteWarning" = "never";
            "terminal.integrated.hoveredLinkActivationModifier" = "";
            "terminal.integrated.showLinkHover" = false;
            "terminal.external.linuxExec" = "kitty";
            "terminal.explorerKind" = "both";
            "terminal.sourceControlRepositoriesKind" = "both";
            "security.workspace.trust.untrustedFiles" = "open";
            "security.workspace.trust.startupPrompt" = "never";
            "security.workspace.trust.enabled" = false;
            "workbench.editor.empty.hint" = "hidden";
            "workbench.secondarySideBar.defaultVisibility" = "hidden";
            "workbench.statusBar.visible" = false;
            "workbench.editorAssociations" = {
              "*.wav" = "vscode.audioPreview";
            };
            "window.titleBarStyle" = "custom";
            "chat.agent.enabled" = false;
            "update.mode" = "none";
            "telemetry.telemetryLevel" = "off";
            "redhat.telemetry.enabled" = false;
            "diffEditor.ignoreTrimWhitespace" = false;
            "makefile.configureOnOpen" = true;
            "go.toolsManagement.autoUpdate" = true;
            "zig.zls.enabled" = "on";
            "svelte.enable-ts-plugin" = true;
            "svelte.plugin.svelte.compilerWarnings" = {
              "a11y-aria-attributes" = "ignore";
              "a11y-incorrect-aria-attribute-type" = "ignore";
              "a11y-unknown-aria-attribute" = "ignore";
              "a11y-hidden" = "ignore";
              "a11y-misplaced-role" = "ignore";
              "a11y-unknown-role" = "ignore";
              "a11y-no-abstract-role" = "ignore";
              "a11y-no-redundant-roles" = "ignore";
              "a11y-role-has-required-aria-props" = "ignore";
              "a11y-accesskey" = "ignore";
              "a11y-autofocus" = "ignore";
              "a11y-misplaced-scope" = "ignore";
              "a11y-positive-tabindex" = "ignore";
              "a11y-invalid-attribute" = "ignore";
              "a11y-missing-attribute" = "ignore";
              "a11y-img-redundant-alt" = "ignore";
              "a11y-label-has-associated-control" = "ignore";
              "a11y-media-has-caption" = "ignore";
              "a11y-distracting-elements" = "ignore";
              "a11y-structure" = "ignore";
              "a11y-mouse-events-have-key-events" = "ignore";
              "a11y-missing-content" = "ignore";
              "a11y-no-static-element-interactions" = "ignore";
            };
          };
        };

        # WINE/EXE
        xdg.mimeApps = {
          enable = true;
          defaultApplications = {
            "application/x-ms-dos-executable" = "wine.desktop";
            "application/x-msdos-program" = "wine.desktop";
          };
        };

        # BOOKMARKS (COSMIC FILES SIDEBAR)
        gtk.gtk3.bookmarks = [
          "file:///mnt/primary Primary"
          "file:///mnt/secondary Secondary"
        ];

      };
    };
}