{ inputs, config, lib, ... }:
{
  flake.modules.nixos.alex-vm-001 = { 
      xalaynix.git.enable = false;
  };
}