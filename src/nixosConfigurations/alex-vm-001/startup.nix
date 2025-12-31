{ inputs, config, lib, ... }:
{
  flake.modules.nixos.startupTest =
    { pkgs, ... }:
    let
      testScript = ''
        #!/bin/sh

        echo "Making initial root snapshot..." >/dev/kmsg

        mkdir -p /var/test-startup
        echo "Startup test completed successfully." > /var/test-startup/startup_test_complete.txt

        mkdir -p /snapshots

        btrfs subvolume snapshot -r / /snapshots/initial_snapshot
        echo "Initial root snapshot made! ✅" >/dev/kmsg
      '';
    in
    {
      config = {
        systemd.services.system-ready-timestamp = {
          description = "Create a timestamped file when the system is ready";

          script = testScript;

          # Options that go into the [Unit] section of the Systemd file
          unitConfig = {
            ConditionPathExists = "!/snapshots/initial_snapshot";
            ConditionKernelCommandLine = ["!resume="];
            # RequiresMountsFor = ["/dev/mapper/root_vg-root"];
            RequiresMountsFor = ["/"];
          };

          # Options that go into the [Service] section of the Systemd file
          serviceConfig = {
            StandardOutput = "journal+console";
            StandardError = "journal+console";
            Type = "oneshot";
          };
          
          # Options that go into the [Install] section
          # The 'WantedBy' is the most common install option used in NixOS
          wantedBy = [ "multi-user.target" ];
          after = [ "local-fs.target" ];
        };
      };
    };
}

