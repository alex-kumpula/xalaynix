{ inputs, ... }:
{
  flake.nixosConfigurations.proxmox-nixos-host-001 = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ 
      proxmox-nixos-host-001
    ];
  };
}