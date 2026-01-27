{ ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { ... }: 
  {
    programs.git.enable = true;
  };
}