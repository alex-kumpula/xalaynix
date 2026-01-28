{ inputs, ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 = {
    # See https://wiki.nixos.org/wiki/Docker

    virtualisation.docker = {
      enable = true;
      # Set up resource limits
      daemon.settings = {
        experimental = true;
        default-address-pools = [
          {
            base = "172.30.0.0/16";
            size = 24;
          }
        ];
      };
    };

  };
}

