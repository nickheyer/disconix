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
        typescript
        typescript-language-server

        # PYTHON
        python3
        basedpyright
        ruff

        # RUST
        rustc
        cargo
        rustfmt
        clippy
        rust-analyzer

        # C / C++
        gcc
        gnumake
        cmake
        gdb
        clang-tools

        # JAVA
        jdk17
        jdk21
        jdt-language-server

        # NIX
        nil
        nixfmt

        # BASH / SHELL
        bash-language-server
        shellcheck
        shfmt

        # YAML / JSON / TOML
        yaml-language-server
        vscode-json-languageserver
        taplo

        # ZIG (MATCHES zig.zls.enabled IN VSCODE)
        zig
        zls

        # PROTO
        buf
        protoc-gen-go
        protoc-gen-es

        # MISC SYS UTILS
        pkg-config
        gtk3
        webkitgtk_4_1
        unzip
      ];

      # PKGCFG
      environment.pathsToLink = [ "/lib/pkgconfig" "/share/pkgconfig" ];
      environment.extraOutputsToInstall = [ "dev" ];
    };
}
