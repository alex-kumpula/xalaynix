{ inputs, ... }:
{
  flake.modules.nixos.btrfs-impermanence = {
    imports = [
      inputs.disko.nixosModules.default
    ];
  };
}

