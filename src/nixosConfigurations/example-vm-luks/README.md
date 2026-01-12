To bootstrap this configuration do the following:

1. Clone this repo, as you will need to make some changes.
2. Generate a new facter.json on the system you intend for this NixOS configuration to be used for, and replace the current facter.json.
3. Change the main disk in diskConfig.nix from "/dev/vda" to your main disk you want to format.
4. Format your disk with the disko config from diskConfig.nix.
5. Change the bootDevice in system.nix from "/dev/vda" to the disk your boot partition resides on. If you are using the disko config as-is, this will be the same as your main disk.

With that, you should be able to build the configuration on your machine!

To do this from an official NixOS ISO live environment, do the following:
1. Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./#example-vm-luks`
2. Run `sudo nixos-install --root /mnt --flake ./#example-vm-luks`