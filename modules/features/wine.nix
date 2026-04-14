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

      # COMMON LIBS FOR UNPATCHED BINARIES (NIX-LD)
      programs.nix-ld.libraries = with pkgs; [
        # GRAPHICS
        libGL
        libglvnd
        vulkan-loader

        # X11
        libx11
        libxext
        libxcursor
        libxrandr
        libxi
        libxfixes
        libxinerama
        libxscrnsaver
        libxxf86vm

        # WAYLAND
        wayland
        libxkbcommon

        # AUDIO
        alsa-lib
        libpulseaudio
        openal

        # SDL
        SDL2
        SDL2_image
        SDL2_ttf
        SDL2_mixer

        # COMMON RUNTIME DEPS
        zlib
        libffi
        stdenv.cc.cc.lib
        freetype
        fontconfig
        glib
        dbus
      ];
    };
}
