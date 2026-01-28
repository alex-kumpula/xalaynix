{ ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { ... }: 
  {
    services.fail2ban = {
      enable = true;
      # Maximize security by banning for longer periods
      maxretry = 10;
      bantime = "24h"; 

      jails.sshd.settings = {
        enabled = true;
        backend = "systemd";
        maxretry = 10;
      };
    };
  };
}