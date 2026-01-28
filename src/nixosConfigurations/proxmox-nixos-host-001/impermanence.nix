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
        "var/lib/machines"  # Persist containers and VMs
        "var/lib/libvirt"   # Persist libvirt data
        "etc/libvirt"       # Persist libvirt config
        "etc/ssh"           # Persist SSH config and keys
      ];
      files = config.xalaynix.constants.commonPersistentFiles;
    };

    fileSystems."/persistent" = {
      neededForBoot = true;
    };
  };
}