{ inputs, config, lib, ... }:
{
  flake.modules.nixos.hosts.alex-vm-001 = {
    flakeConfig.git.userName = "Alex Kumpula";
    flakeConfig.git.userEmail = "alex.kumpula@example.com";
  };
}