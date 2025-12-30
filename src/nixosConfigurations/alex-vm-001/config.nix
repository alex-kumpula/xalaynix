{ inputs, config, lib, ... }:
{
  flake.modules.nixos.hosts.alex-vm-001 = { 
      config, 
      lib, 
      ... 
    }: 
    {
      programs.ssh.enable = true;
  };
}