{ ... }:
{
  flake.nixosModules.devtools =
    { pkgs, ... }:
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
      ];
    };
}
