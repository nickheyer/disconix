{ self, inputs, ... }: {

	flake.nixosModules.discoHardware = { config, lib, pkgs, modulesPath, ... }: {
		imports = [
			(modulesPath + "/profiles/qemu-guest.nix")
		];

		boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
		boot.initrd.kernelModules = [ ];
		boot.kernelModules = [ "kvm-intel" ];
		boot.extraModulePackages = [ ];

		fileSystems."/" = {
			device = "/dev/disk/by-uuid/bd15377a-556e-4f8e-bfbe-e73efaec2d28";
			fsType = "ext4";
		};

		swapDevices = [ ];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
	};
}


