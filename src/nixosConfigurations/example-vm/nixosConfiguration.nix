{ inputs, ... }:
{
  flake.nixosConfigurations.example-vm = inputs.nixpkgs.lib.nixosSystem {
    system = "x86_64-linux";
    modules = with inputs.self.modules.nixos; [ 
      example-vm
    ] ++ [
      inputs.xalaynix.modules.nixos.xalaynix
      inputs.xalaynixDesktop.modules.nixos.xalaynixDesktop
    ];
  };
}