{ inputs, ... }:
{
  flake.nixosConfigurations.alex-vm-001 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ 
      # ./_disk_config.nix
      # ./_persistence.nix
      vm-configuration 
      vm-hardware-configuration
      git
      alex-vm-001
      btrfs-impermanence
    ] ++ [
      # inputs.disko.nixosModules.default
      # inputs.impermanence.nixosModules.impermanence
    ];
  };
}