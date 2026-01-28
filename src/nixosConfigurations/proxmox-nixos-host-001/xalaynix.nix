{ inputs, ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { ... }: 
  {
    imports = [
      inputs.xalaynix.modules.nixos.xalaynix
    ];
    
    xalaynix = {
      enable = true;
      preset = "minimal";
      boot.bootDevice = "/dev/sda";
      desktop.niri.enable = true;
    };

  };
}