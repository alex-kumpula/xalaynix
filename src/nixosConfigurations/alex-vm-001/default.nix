{ inputs, ... }:
{
  flake.nixosConfigurations.alex-vm-001 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ 
      vm-configuration 
      vm-hardware-configuration 
    ] ++ [
      (import ./_disko.nix {
        device = "/dev/vda";
      })
    ];
  };
}