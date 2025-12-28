
{
  config,
  ...
}:
{
  flake.modules.nixos.vm-hardware-configuration =
  { config, lib, pkgs, modulesPath, ... }:
  {
    imports =
      [ (modulesPath + "/profiles/qemu-guest.nix")
      ];
  
    boot.initrd.availableKernelModules = [ "ahci" "xhci_pci" "virtio_pci" "sr_mod" "virtio_blk" ];
    boot.initrd.kernelModules = [ "dm-snapshot" ];
    boot.kernelModules = [ "kvm-intel" ];
    boot.extraModulePackages = [ ];
  
    # fileSystems."/" =
    #   { device = "/dev/disk/by-uuid/f5576cec-052d-4bb2-91df-c369c73a2034";
    #     fsType = "ext4";
    #   };
  
    swapDevices = [ ];
  
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  };
}