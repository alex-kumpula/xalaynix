{ inputs, config, lib, ... }:
{
  flake.modules.nixos.hosts.alex-vm-001 = { 
      config, 
      lib, 
      ... 
    }: 
    {
      config = {
        networking.hostName = "alex-vm-001";
      };
  };
}