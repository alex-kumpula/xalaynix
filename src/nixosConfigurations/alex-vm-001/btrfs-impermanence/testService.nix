{ inputs, config, lib, ... }:
{
  flake.modules.nixos.btrfs-impermanence =
    { lib, pkgs, ... }:
    {

      config = {


        boot.initrd.systemd = {
          enable = true;
          extraBin = {
            grep = "${pkgs.gnugrep}/bin/grep";
          };
          services = {
            test-service = {
              wantedBy = ["initrd-root-device.target"];
              wants = ["lvm2-activation.service"];
              # See https://github.com/nix-community/impermanence/issues/250#issuecomment-2603848867
              after = ["lvm2-activation.service" "local-fs-pre.target"];
              before = ["sysroot.mount"];
              # Run on cold boot only, never on resume from hibernation
              unitConfig = {
                ConditionKernelCommandLine = ["!resume="];
                RequiresMountsFor = ["/dev/mapper/root_vg-root"];
              };
              serviceConfig = {
                ExecStart = config.xalaynix.testScript;
                StandardOutput = "journal+console";
                StandardError = "journal+console";
                Type = "oneshot";
              };
              # script = rootCleanupScript;
            };
          };
        };


      };

      
    };
}

