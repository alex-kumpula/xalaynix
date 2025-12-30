{ config, lib, ... }:
let
  cfg = config.flakeConfig.git;

  gitModule = {
    options.flakeConfig.git = {
      userName = lib.mkOption {
        type = lib.types.str;
        default = "default";
        description = "The name to use in git commits.";
      };
      userEmail = lib.mkOption {
        type = lib.types.str;
        default = "default@example.com";
        description = "The email to use in git commits.";
      };
    };

    config = {
      programs.git.enable = true;
      programs.git.userName = cfg.userName;
      programs.git.userEmail = cfg.userEmail;
    };
  };

in
{
  flake.modules.nixos.git = gitModule;
}