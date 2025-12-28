{ inputs, ... }:
{
  flake.nixosConfigurations.alex-vm-001 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ 
      ./_disko.nix
      # ./_filesystems.nix
      vm-configuration 
      vm-hardware-configuration
    ];
  };
}