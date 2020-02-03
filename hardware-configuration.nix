# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
# configs file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, ... }:

{
  imports =
    [
    <nixos-hardware/lenovo/thinkpad/x1-extreme/gen2>
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];
  hardware.firmware = [ pkgs.firmwareLinuxNonfree ];
  fileSystems."/" =
    { device = "/dev/disk/by-uuid/3bf45666-424c-4c32-974d-b0bbe8ca0fb2";
      fsType = "ext4";
    };

  fileSystems."/boot" =
  { device = "/dev/disk/by-uuid/2A09-3DED";
      fsType = "vfat";
  };

  swapDevices =
    [
      { device = "/dev/disk/by-uuid/7fca9b8a-a91f-4a5b-b553-da91981fc16e"; }
    ];

  nix.maxJobs = lib.mkDefault 12;
  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  i18n.consoleFont = lib.mkDefault "${pkgs.terminus_font}/share/consolefonts/ter-u28n.psf.gz";

  hardware.nvidia.optimus_prime.enable = true;
  hardware.nvidia.optimus_prime.nvidiaBusId = "PCI:1:0:0";
  hardware.nvidia.optimus_prime.intelBusId = "PCI:0:2:0";
  hardware.nvidia.modesetting.enable = true;
  hardware.opengl.driSupport32Bit = true;

  hardware.trackpoint = {
    fakeButtons = true;
    sensitivity = 200;
    speed = 110;
  };
}
