{ ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { ... }: 
  {
    hardware.facter.reportPath = ./facter.json;
  };
}