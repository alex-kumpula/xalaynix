{ inputs, ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 = {
    imports = [
      inputs.disko.nixosModules.default
      ./_diskConfig.nix
    ];
  };
}

