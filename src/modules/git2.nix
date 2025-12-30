# ./modules/git-simple.nix
{ self, lib, ... }:  # flake-parts module
{
  flake.modules.nixos.git = { 
    config, lib, ... 
    }: 
    {
      options.test12345.git = {
        enable = lib.mkOption {
          type = lib.types.bool;
          default = true;
          description = "Enable simple git configuration.";
        };
      };
  };

  # flake.modules.nixos.git = {
  #   programs.git.enable = true;
  # };
}