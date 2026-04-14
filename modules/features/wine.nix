{ ... }:
{
  flake.nixosModules.wine =
    { pkgs, ... }:
    {
      # TOOLS
      environment.systemPackages = with pkgs; [
        wineWow64Packages.stagingFull
        winetricks
      ];

      # 32-BIT WINE
      hardware.graphics.enable32Bit = true;

      # LIBGL
      programs.nix-ld.libraries = with pkgs; [
        libGL
        libglvnd
      ];
    };
}
