{ inputs, config, lib, ... }:
{
  flake.modules.nixos.btrfs-impermanence =
    { lib, pkgs, ... }:
    {
      # options.xalaynix.testScript = lib.mkOption {
      #   type = lib.types.str;
      #   default = "";
      #   description = "A test script that echoes a message.";
      # };

      config = {


        xalaynix.testScript = pkgs.writeShellScript "testScript.sh" ''
          #!/bin/sh
          set -e

          echo "THIS IS A TEST SCRIPT!!!"
          
        '';


      };

      
    };
}

