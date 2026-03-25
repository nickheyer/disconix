{ self, inputs, ... }:
{
  flake.nixosModules.greetdeez =
    { pkgs, lib, ... }:
    let
      greetdeez = pkgs.buildGoModule rec {
        pname = "greetdeez";
        version = "1.0.34";

        src = pkgs.fetchFromGitHub {
          owner = "nickheyer";
          repo = "GreetDeez";
          rev = "v${version}";
          hash = ""; # nix will tell you the correct hash on first build
        };

        vendorHash = ""; # same — nix will tell you

        nativeBuildInputs = with pkgs; [
          pkg-config
          nodejs
          makeWrapper
        ];

        buildInputs = with pkgs; [
          webkitgtk_4_1
          gtk3
          glib
        ];

        buildPhase = ''
          runHook preBuild
          make build
          runHook postBuild
        '';

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp greetdeez $out/bin/
          runHook postInstall
        '';

        meta = {
          description = "Hackable display manager greeter for greetd";
          homepage = "https://github.com/nickheyer/GreetDeez";
          license = lib.licenses.mit;
        };
      };
    in
    {
      services.greetd = {
        enable = true;
        settings = {
          default_session = {
            command = "${pkgs.cage}/bin/cage -s -- ${greetdeez}/bin/greetdeez";
            user = "greeter";
          };
        };
      };

      # greetdeez needs these at runtime
      environment.systemPackages = [ greetdeez ];
    };
}