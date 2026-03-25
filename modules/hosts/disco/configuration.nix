{ self, inputs, ... }: {

	flake.nixosModules.discoConfiguration = { config, pkgs, ... }: {
		imports = [
      			self.nixosModules.discoHardware
			self.nixosModules.niri
    		];

		nix.settings.experimental-features = [ "nix-command" "flakes" ];
  		boot.loader.grub.enable = true;
		boot.loader.grub.device = "/dev/vda";
  		boot.loader.grub.useOSProber = true;
  		boot.kernelPackages = pkgs.linuxPackages_latest;
		networking.hostName = "disco";
		networking.wireless.enable = true;
		networking.networkmanager.enable = true;
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

		services.xserver.enable = true;
		services.displayManager.gdm.enable = true;
		services.desktopManager.gnome.enable = true;
		services.xserver.xkb = {
			layout = "us";
			variant = "";
		};

		services.printing.enable = true;

		services.pulseaudio.enable = false;
		security.rtkit.enable = true;
		services.pipewire = {
			enable = true;
			alsa.enable = true;
			alsa.support32Bit = true;
			pulse.enable = true;
			jack.enable = true;
		};
		
		users.users.nick = {
			isNormalUser = true;
			description = "Nicholas Heyer";
			extraGroups = [ "networkmanager" "wheel" ];
			packages = with pkgs; [
				firefox
				vim
				nano
			];
		};

		programs.firefox.enable = true;
		nixpkgs.config.allowUnfree = true;

		# List packages installed in system profile. To search, run:
		# $ nix search wget
		environment.systemPackages = with pkgs; [
			git
			vscode-fhs
			wget
		#  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
		#  wget
		];

		# NixOS release
		system.stateVersion = "25.11";

	};

}
