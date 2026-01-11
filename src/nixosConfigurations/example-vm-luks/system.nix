{ ... }:
{
  flake.modules.nixos.example-vm-luks =
  { ... }: 
  {
    xalaynix.bootDevice = "/dev/vda";
  };
}