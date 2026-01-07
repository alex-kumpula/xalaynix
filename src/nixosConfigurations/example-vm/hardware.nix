{ ... }:
{
  flake.modules.nixos.example-vm =
  { ... }: 
  {
    hardware.facter.reportPath = ./facter.json;
  };
}