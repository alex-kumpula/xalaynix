{ inputs, config, lib, ... }:
{
  flake.modules.nixos.btrfs-impermanence =
    { lib, pkgs, ... }:
    {
      options.xalaynix.testScript = lib.mkOption {
        type = lib.types.package;
        default = null;
        description = "A test script that echoes a message.";
      };

      config = {


        xalaynix.testScript = pkgs.writeShellScriptBin "testScript" ''
          #!/bin/sh
          set -e

          echo "THIS IS A TEST SCRIPT!!!"
          
        '';


      };

      
    };
}

