# ./modules/git.nix

{ lib, config, ... }: 
# No 'config' in the function signature needed here, as we defer its use
# and let the inner NixOS module evaluation provide it.

{
  # The Flake Parts export path
  flake.modules.nixos.git = { 
    # This is the actual NixOS module set

    # 1. Define the options (Standard NixOS attribute)
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

    # 2. Configure the system (Standard NixOS attribute)
    config = 
      let 
        # Define cfg lazily inside the config block to avoid the missing attribute error
        cfg = config.flakeConfig.git; 
      in
      {
      # 🌟 Access 'config' and its attributes DIRECTLY here (Scope B)
      programs.git.enable = true;
      programs.git.userName = cfg.userName;
      programs.git.userEmail = cfg.userEmail;
    };
  };
}