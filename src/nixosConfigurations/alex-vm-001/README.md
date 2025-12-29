# A NixOS Configuration
This NixOS configuration uses [Impermanence](https://github.com/nix-community/impermanence) with [Btrfs](https://en.wikipedia.org/wiki/Btrfs).

The result is a system that has a clean root after each boot, with opt-in persistence.

## Installation
1. Download a NixOS ISO from https://nixos.org/download/ and boot into it on your machine.
2. Run `export NIX_CONFIG="experimental-features = nix-command flakes"` to enable these experimental Nix features temporarily.
3. Run `nix shell nixpkgs#git`.
4. Clone this Git repository to your home folder and `cd` into the folder this README is in.
5. Run `lsblk` to get the name of the disk you will be formatting.
6. Edit [_disko.nix](./_disko.nix) to change the device variable at the top of the file to the name of the disk you will be formatting.
7. Format your disk with [Disko](https://github.com/nix-community/disko). **WARNING: This will delete any existing data on this disk!**
   1. Run `sudo nix --experimental-features "nix-command flakes" run github:nix-community/disko/latest -- --mode destroy,format,mount ./_disko.nix`