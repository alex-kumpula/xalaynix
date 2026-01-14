{ inputs, ... }:
{
  flake.modules.nixos.example-vm-luks = {
    imports = [
      inputs.disko.nixosModules.default
      ./_diskConfig.nix
    ];
  };
}

