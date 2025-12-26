{ inputs, ... }:
{
  flake.nixosConfigurations.my-host = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.nixosModules; [ vm-configuration vm-hardware-configuration ];
  };
}