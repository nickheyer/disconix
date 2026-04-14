{ self, inputs, ... }:
{

  flake.nixosModules.discoHardware =
	{ config, lib, pkgs, modulesPath, ... }:

	{
		imports =
		[ (modulesPath + "/installer/scan/not-detected.nix")
		];

		boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
		boot.initrd.kernelModules = [ ];
		boot.kernelModules = [ "kvm-intel" ];
		boot.extraModulePackages = [ ];

		fileSystems."/" =
		{ device = "/dev/disk/by-uuid/a08607df-169e-4ad5-bc57-750f1f4e70be";
			fsType = "ext4";
		};

		fileSystems."/boot" =
		{ device = "/dev/disk/by-uuid/89D6-E557";
			fsType = "vfat";
			options = [ "fmask=0077" "dmask=0077" ];
		};

		fileSystems."/mnt/primary" =
		{ device = "/dev/disk/by-uuid/5c71721f-5c0f-4fc4-a440-b0982fd6fe23";
			fsType = "ext4";
			options = [ "noauto" "x-systemd.automount" "x-systemd.idle-timeout=300" ];
		};

		fileSystems."/mnt/secondary" =
		{ device = "/dev/disk/by-uuid/e4856135-703e-4fee-8dbd-8f22f88ca8da";
			fsType = "ext4";
			options = [ "noauto" "x-systemd.automount" "x-systemd.idle-timeout=300" ];
		};

		fileSystems."/mnt/backups" =
		{ device = "192.168.1.184:/mnt/user/backups";
			fsType = "nfs";
			options = [ "defaults" "_netdev" ];
		};

		fileSystems."/mnt/media" =
		{ device = "192.168.1.184:/mnt/user/Media";
			fsType = "nfs";
			options = [ "defaults" "_netdev" ];
		};

		fileSystems."/mnt/isos" =
		{ device = "192.168.1.184:/mnt/user/isos";
			fsType = "nfs";
			options = [ "defaults" "_netdev" ];
		};

		swapDevices = [ ];

		nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
		hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

		hardware.nvidia = {
			modesetting.enable = true;
			open = false;
			nvidiaSettings = true;
			package = config.boot.kernelPackages.nvidiaPackages.stable;
			powerManagement.enable = true;
		};
		
		hardware.graphics.enable = true;
	};

}
