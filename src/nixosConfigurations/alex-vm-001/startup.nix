{ inputs, config, lib, ... }:
{
  flake.modules.nixos.startupTest =
    { pkgs, ... }:
    let
      # 1. Define a Nix variable for the build date (Example of Nix interpolation)
      # This date will be baked into the script when you run nixos-rebuild.

      # 2. Define the Script/Command
      # Note the mix of Nix and Bash variables below:
      # systemReadyScript = pkgs.writeShellScriptBin "create-system-ready-file" ''
      #   #!/bin/sh

      #   # It gets the current time when the script executes.
      #   RUNTIME_TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)
        
      #   TARGET_DIR="/var"
        
      #   # Create the timestamped file. We include both timestamps for demonstration.
      #   FILENAME="$TARGET_DIR/system_ready_file_RUNTIME-$RUNTIME_TIMESTAMP.txt"
        
      #   # Use the Nix store path of 'touch' via NIX interpolation (BUILD TIME)
      #   if ${pkgs.coreutils}/bin/touch "$FILENAME"; then
      #     ${pkgs.coreutils}/bin/echo "System Ready File Created: $FILENAME"
      #   else
      #     ${pkgs.coreutils}/bin/echo "Error: Failed to create file $FILENAME" >&2
      #     exit 1
      #   fi
      # '';

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
            ConditionKernelCommandLine = ["!resume="];
            RequiresMountsFor = ["/dev/mapper/root_vg-root"];
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
          after = [ "network-online.target" "nss-lookup.target" ];
        };
      };
    };
}

