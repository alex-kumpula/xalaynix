{ inputs, config, lib, ... }:
{
  flake.modules.nixos.btrfs-impermanence =
    { lib, pkgs, ... }:
    {

      config.xalaynix = {


        testScript = pkgs.writeShellScript "testScript.sh" ''
          #!/bin/sh
          set -e

          echo "THIS IS A TEST SCRIPT!!!"
          
        '';


      };

      
    };
}

