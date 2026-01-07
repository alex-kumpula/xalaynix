{ ... }:
{
  flake.modules.nixos.example-vm =
  { ... }: 
  {
    xalaynix.bootDevice = "/dev/vda";
  };
}