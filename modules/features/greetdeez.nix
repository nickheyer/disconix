{ self, inputs, ... }:
{
  flake.nixosModules.greetdeez =
    { pkgs, lib, ... }:
    let
      greetdeez = pkgs.stdenv.mkDerivation rec {
        pname = "greetdeez";
        version = "1.0.34";

        src = pkgs.fetchurl {
          url = "https://github.com/nickheyer/GreetDeez/releases/download/v${version}/greetdeez_${version}_linux_amd64.tar.gz";
          hash = "sha256-SyJv9y9gARr/Neh3UC/PAFusxwcZMOAjzrYMofIoEOs=";
        };

        sourceRoot = ".";

        nativeBuildInputs = [ pkgs.autoPatchelfHook ];

        buildInputs = with pkgs; [
          webkitgtk_4_1
          gtk3
          glib
        ];

        installPhase = ''
          mkdir -p $out/bin
          cp greetdeez $out/bin/
          chmod +x $out/bin/greetdeez
        '';

        meta = {
          description = "Hackable display manager greeter for greetd";
          homepage = "https://github.com/nickheyer/GreetDeez";
          license = lib.licenses.mit;
          platforms = [ "x86_64-linux" ];
        };
      };
    in
    {
      services.greetd = {
        enable = true;
        settings.default_session = {
          command = "${pkgs.cage}/bin/cage -s -- ${greetdeez}/bin/greetdeez";
          user = "greeter";
        };
      };

      environment.etc."greetd/greetdeez.conf".text = ''
        [ui]
        theme = "cyber"

        [sessions]
        dirs = [
            { path = "/run/current-system/sw/share/wayland-sessions", type = "wayland" },
            { path = "/run/current-system/sw/share/xsessions", type = "x11" },
        ]
      '';
    };
}
