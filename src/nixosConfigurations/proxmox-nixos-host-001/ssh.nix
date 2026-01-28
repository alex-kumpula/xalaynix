{ ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { pkgs, ... }: 
  {
    # Enable and configure OpenSSH server
    services.openssh = {
      enable = true;
      # Use persistent storage for SSH host keys
      hostKeys = [
        {
          path = "/persistent/system/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
        {
          path = "/persistent/system/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
          bits = 4096;
        }
      ];
    };

    # Allow SSH through the firewall
    networking.firewall.allowedTCPPorts = [ 22 ];

    users.users.main = {
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJSfkRaThtgy+4kZlQIIh7dDxHBy/F3QqufQBRqEvZcY"
      ];
    };
  };
}