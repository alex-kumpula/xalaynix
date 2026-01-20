{ inputs, ... }:
{
  flake.nixosConfigurations.example-vm-luks = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ 
      example-vm-luks
    ] ++ [
      inputs.xalaynixDesktop.modules.nixos.xalaynixDesktop
    ];
  };
}