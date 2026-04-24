{ self, inputs, ... }:
{
  flake.nixosModules.cosmicf =
    { pkgs, lib, ... }:
    {

      # THUMBNAILS
      services.tumbler.enable = true;

      # GVFS (TRASH, REMOTE MOUNTS, NETWORK SHARES)
      services.gvfs.enable = true;

      # GTK THEMING
      environment.systemPackages = with pkgs; [
        cosmic-files
        adw-gtk3
        papirus-icon-theme
        file-roller
      ];

      environment.sessionVariables = {
        GTK_THEME = "adw-gtk3-dark";
        TERMINAL = "kitty";
      };
    };

}
