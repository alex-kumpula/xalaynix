{ ... }:
{
  flake.modules.nixos.example-vm-luks =
  { ... }: 
  {
    hardware.facter.reportPath = ./facter.json;
  };
}