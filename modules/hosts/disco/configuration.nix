{ self, inputs, ... }:
{

  flake.nixosModules.discoConfiguration =
    { config, pkgs, ... }:
    {

      # NIX MODULES
      imports = [
        self.nixosModules.discoHardware
        self.nixosModules.niri
        self.nixosModules.greeter
        self.nixosModules.thunar
        self.nixosModules.nickHome
        self.nixosModules.devtools
        self.nixosModules.wine
      ];

      # NIX FLAGS
      nix.settings.experimental-features = [
        "nix-command"
        "flakes"
      ];
      nix.gc.automatic = true;
      nix.gc.dates = "weekly";
      nix.gc.options = "--delete-older-than 30d";

      # AUTO UPDATE
      system.autoUpgrade = {
        enable = true;
        flake = "/home/nick/disconix";
        flags = [ "--update-input" "nixpkgs" ];
        dates = "daily";
        allowReboot = false;
      };

      # BOOT LOADER
      boot.loader.systemd-boot.enable = true;
      boot.loader.efi.canTouchEfiVariables = true;
      boot.loader.systemd-boot.configurationLimit = 3;

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
      programs.nix-ld.enable = true;
      environment.systemPackages = with pkgs; [
        git
        vscode
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
        ELECTRON_OZONE_PLATFORM_HINT = "auto";
      };
    };

}
