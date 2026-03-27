{ ... }:
{
  flake.nixosModules.devtools =
    { pkgs, lib, ... }:
    {
      # DOCKER
      virtualisation.docker.enable = true;
      users.users.nick.extraGroups = [ "docker" ];

      # DEV TOOLS
      environment.systemPackages = with pkgs; [
        # GO
        go
        gopls

        # NODE + NPM
        nodejs

        # PYTHON
        python3

        # C / C++
        gcc
        gnumake
        cmake
        gdb

        # JAVA
        jdk17
        jdk21

        # PROTO
        buf
        protoc-gen-go
        protoc-gen-es

        # MISC SYS UTILS
        pkg-config
        gtk3
        webkitgtk_4_1
      ];

      # PKGCFG
      environment.variables.PKG_CONFIG_PATH = lib.makeSearchPath "lib/pkgconfig" [
        pkgs.gtk3.dev
        pkgs.webkitgtk_4_1.dev
        pkgs.glib.dev
        pkgs.cairo.dev
        pkgs.pango.dev
        pkgs.gdk-pixbuf.dev
        pkgs.atk.dev
        pkgs.harfbuzz.dev
        pkgs.libsoup_3.dev
      ];
    };
}
