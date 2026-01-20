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
      directories = config.xalaynix.constants.commonPersistentDirectories;
      files = config.xalaynix.constants.commonPersistentFiles;
    };

    fileSystems."/persistent" = {
      neededForBoot = true;
    };
  };
}