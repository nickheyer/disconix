{ self, inputs, ... }:
{

  flake.nixosModules.discoConfiguration =
    { config, pkgs, ... }:
    {

      # NIX MODULES
      imports = [
        self.nixosModules.discoHardware
        self.nixosModules.niri
        self.nixosModules.thunar
        self.nixosModules.nickHome
        #self.nixosModules.greetdeez
      ];

      # NIX FLAGS
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];

      # BOOT LOADER
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;

      # KERNEL
      boot.kernelPackages = pkgs.linuxPackages_latest;
      
      # NETWORKING
      networking.hostName = "disco";
      networking.wireless.enable = true;
      networking.networkmanager.enable = true;
      
      # LOCALE
      time.timeZone = "America/Los_Angeles";
      i18n.defaultLocale = "en_US.UTF-8";
      i18n.extraLocaleSettings = {
        LC_ADDRESS = "en_US.UTF-8";
        LC_IDENTIFICATION = "en_US.UTF-8";
        LC_MEASUREMENT = "en_US.UTF-8";
        LC_MONETARY = "en_US.UTF-8";
        LC_NAME = "en_US.UTF-8";
        LC_NUMERIC = "en_US.UTF-8";
        LC_PAPER = "en_US.UTF-8";
        LC_TELEPHONE = "en_US.UTF-8";
        LC_TIME = "en_US.UTF-8";
      };

      # DISPLAY MANAGER + GREETER
      services.xserver.enable = true;
      services.displayManager.sddm.enable = true;
      services.displayManager.sddm.setupScript = let
        xrandr = "${pkgs.xrandr}/bin/xrandr";
        grep = "${pkgs.gnugrep}/bin/grep";
        cut = "${pkgs.coreutils}/bin/cut";
      in ''
        # Disable secondary monitor (Acer XF270H 27") to prevent duplicate/misrotated login screen
        for out in $(${xrandr} --query | ${grep} ' connected' | ${grep} '600mm x 340mm' | ${cut} -d' ' -f1); do
          ${xrandr} --output "$out" --off
        done
      '';
      services.displayManager.defaultSession = "niri";
      services.xserver.xkb = {
        layout = "us";
        variant = "";
      };

      # PRINTING (CUPS)
      services.printing.enable = true;

      # AUDIO
      services.pulseaudio.enable = false;
      security.rtkit.enable = true;
      services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      # GRAPHICS
      services.xserver.videoDrivers = [ "nvidia" ];

      # USER CONFIG
      users.users.nick = {
        isNormalUser = true;
        description = "Nicholas Heyer";
        extraGroups = [
          "networkmanager"
          "wheel"
        ];
        shell = pkgs.zsh;
        packages = with pkgs; [
          firefox
          vim
          nano
        ];
      };

      # PACKAGES
      programs.firefox.enable = true;
      programs.zsh.enable = true;
      nixpkgs.config.allowUnfree = true;
      environment.systemPackages = with pkgs; [
        git
        vscode-fhs
        wget
        obs-studio
        mangohud
        lutris
        protonup-qt
      ];

      # STEAM (NEEDS 32 BIT LIB INTEGRATION)
      programs.steam = {
        enable = true;
        remotePlay.openFirewall = true;
        gamescopeSession.enable = true;
      };

      # GAMING PERFORMANCE
      programs.gamemode.enable = true;

      # NIX RELEASE VERSION
      system.stateVersion = "25.11";

      # ENV
      environment.sessionVariables = {
        WLR_NO_HARDWARE_CURSORS = "1";
        NIXOS_OZONE_WL = "1";
      };
    };

}
