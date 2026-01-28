{ inputs, ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { config, ... }: 
  {
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    environment.persistence."/persistent/system" = {
      enable = true;
      hideMounts = true;
      directories = config.xalaynix.constants.commonPersistentDirectories ++ [
        "/var/lib/machines"  # Persist containers and VMs
        "/var/lib/libvirt"   # Persist libvirt data
        "/var/lib/docker"    # Persist docker data
        "/var/lib/portables" # Persist portable services
        "/var/lib/fail2ban"  # Persist fail2ban data
      ];
      files = config.xalaynix.constants.commonPersistentFiles ++ [
        "/etc/subuid"
        "/etc/subgid"
      ];
    };

    fileSystems."/persistent" = {
      neededForBoot = true;
    };
  };
}