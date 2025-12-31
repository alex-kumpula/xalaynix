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

      # 1. Define Dependencies
      btrfsProgs = pkgs.btrfs-progs;
      coreUtils = pkgs.coreutils;
      
      # 2. Define the Script with Absolute Paths (Nix Interpolation)
      initialSnapshotScript = pkgs.writeShellScriptBin "create-initial-snapshot" ''
        #!${pkgs.runtimeShell}

        # Use absolute path for 'echo'
        ${coreUtils}/bin/echo "Making initial root snapshot..." >/dev/kmsg

        # Use absolute path for 'mkdir' and 'echo'
        ${coreUtils}/bin/mkdir -p /var/test-startup
        ${coreUtils}/bin/echo "Startup test completed successfully." > /var/test-startup/startup_test_complete.txt

        ${coreUtils}/bin/mkdir -p /snapshots

        # Use absolute path for 'btrfs'
        ${btrfsProgs}/bin/btrfs subvolume snapshot -r / /snapshots/initial_snapshot
        ${coreUtils}/bin/echo "Initial root snapshot made! ✅" >/dev/kmsg
      '';
    in
    {
      config = {
        # Ensure the script and its dependencies are available
        environment.systemPackages = [
          initialSnapshotScript
          btrfsProgs # Though not strictly needed here, good practice
          coreUtils
        ];
        
        systemd.services.system-ready-timestamp = {
          description = "Create a timestamped file when the system is ready";

          # script = testScript;

          # Options that go into the [Unit] section of the Systemd file
          unitConfig = {
            ConditionPathExists = "!/snapshots/initial_snapshot";
            ConditionKernelCommandLine = ["!resume="];
            # RequiresMountsFor = ["/dev/mapper/root_vg-root"];
            RequiresMountsFor = ["/"];
          };

          # Options that go into the [Service] section of the Systemd file
          serviceConfig = {
            ExecStart = "${initialSnapshotScript}/bin/create-initial-snapshot";
            StandardOutput = "journal+console";
            StandardError = "journal+console";
            Type = "oneshot";
            RemainAfterExit = true;
          };
          
          # Options that go into the [Install] section
          # The 'WantedBy' is the most common install option used in NixOS
          wantedBy = [ "multi-user.target" ];
          after = [ "local-fs.target" ];
        };
      };
    };
}

