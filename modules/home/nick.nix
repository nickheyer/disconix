{ self, inputs, ... }:
{
  flake.nixosModules.nickHome =
    { pkgs, ... }:
    {
      imports = [ inputs.home-manager.nixosModules.home-manager ];

      home-manager.useGlobalPkgs = true;
      home-manager.useUserPackages = true;

      home-manager.users.nick = {
        home.stateVersion = "25.11";

        # PACKAGES
        home.packages = with pkgs; [
          discord
          claude-code
          kitty
          meslo-lgs-nf
        ];

        # ZSH
        programs.zsh = {
          enable = true;
          autosuggestion.enable = true;
          syntaxHighlighting.enable = true;

          plugins = [
            {
              name = "powerlevel10k";
              src = pkgs.zsh-powerlevel10k;
              file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
            }
          ];

          initExtra = ''
            [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
          '';
        };

        # GIT
        programs.git = {
          enable = true;
          userName = "nickheyer";
          userEmail = "nick@heyer.app";
        };

        # KITTY
        programs.kitty = {
          enable = true;
          settings = {
            font_size = 11;
            background_opacity = "0.9";
            font_family = "MesloLGS Nerd Font";
          };
        };

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