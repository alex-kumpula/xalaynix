# ./modules/git-simple.nix
{ self, lib, ... }:  # flake-parts module
{
  flake.modules.nixos.git = 
    { config, lib, ... }: 
    {
    options.test123.git = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = true;
        description = "Enable simple git configuration.";
      };
    };

    config = {
      programs.git = {
        enable = config.test123.git.enable;
      };
    };
  };
}