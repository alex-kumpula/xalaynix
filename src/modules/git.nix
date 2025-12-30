# ./modules/git-simple.nix
{ self, lib, ... }:  # flake-parts module
{
  flake.modules.git = 
    { config, lib, ... }: 
    {
    options.test123.git = {
      userName = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "Git user name";
      };
      
      userEmail = lib.mkOption {
        type = lib.types.str;
        default = "default@example.com";
        description = "Git user email";
      };
    };

    programs.git = {
      enable = true;
      userName = config.test123.git.userName;
      userEmail = config.test123.git.userEmail;
    };
  };
}