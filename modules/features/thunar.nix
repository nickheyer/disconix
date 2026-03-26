{ self, inputs, ... }:
{

  flake.nixosModules.thunar =
    { pkgs, lib, ... }:
    {
      programs.thunar = {
        enable = true;
        plugins = with pkgs; [
          thunar-archive-plugin
          thunar-volman
        ];
      };

      # THUMBNAILS
      services.tumbler.enable = true;

      # GVFS (TRASH, REMOTE MOUNTS)
      services.gvfs.enable = true;

      # GTK THEMING
      environment.systemPackages = with pkgs; [
        adw-gtk3
        papirus-icon-theme
      ];

      environment.sessionVariables = {
        GTK_THEME = "adw-gtk3-dark";
      };
    };

}
