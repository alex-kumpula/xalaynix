{ inputs, ... }:
{
  flake.modules.nixos.example-vm-luks =
  { config, ... }: 
  {
    imports = [
      inputs.impermanence.nixosModules.impermanence
    ];

    environment.persistence."/persistent/system" = {
      enable = true;
      hideMounts = true;
      directories = config.xalaynix.commonPersistentDirectories;
      files = config.xalaynix.commonPersistentFiles;
    };

    fileSystems."/persistent" = {
      neededForBoot = true;
    };
  };
}