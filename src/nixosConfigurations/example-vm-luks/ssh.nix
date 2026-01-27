{ ... }:
{
  flake.modules.nixos.example-vm-luks =
  { pkgs, ... }: 
  {
    services.openssh.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];

    users.users.defaultUser = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSfkRaThtgy+4kZlQIIh7dDxHBy/F3QqufQBRqEvZcY"
      ];
    };
  };
}