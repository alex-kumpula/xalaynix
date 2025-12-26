{ inputs, ... }:
{
  flake.nixosConfigurations.my-host = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ vm-configuration vm-hardware-configuration ];
  };
}