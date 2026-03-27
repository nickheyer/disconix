{ ... }:
{
  perSystem = { pkgs, ... }: {
    devShells.default = pkgs.mkShell {
      packages = with pkgs; [
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
      ];
    };
  };

  flake.nixosModules.devtools =
    { ... }:
    {
      virtualisation.docker.enable = true;
      users.users.nick.extraGroups = [ "docker" ];
    };
}
