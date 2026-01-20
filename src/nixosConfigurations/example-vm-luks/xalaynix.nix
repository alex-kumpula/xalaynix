{ inputs, ... }:
{
  flake.modules.nixos.example-vm-luks =
  { ... }: 
  {
    imports = [
      inputs.xalaynix.modules.nixos.xalaynix
    ];
    
    xalaynix = {
      enable = true;
      preset = "minimal";
      boot.bootDevice = "/dev/vda";
    };

  };
}