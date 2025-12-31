{ inputs, config, lib, ... }:
{
  flake.modules.nixos.startupTest =
    { pkgs, ... }:
    let
      # 1. Define a Nix variable for the build date (Example of Nix interpolation)
      # This date will be baked into the script when you run nixos-rebuild.

      # 2. Define the Script/Command
      # Note the mix of Nix and Bash variables below:
      systemReadyScript = pkgs.writeShellScriptBin "create-system-ready-file" ''
        #!/bin/sh

        # It gets the current time when the script executes.
        RUNTIME_TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)
        
        TARGET_DIR="/var"
        
        # Create the timestamped file. We include both timestamps for demonstration.
        FILENAME="$TARGET_DIR/system_ready_file_RUNTIME-$RUNTIME_TIMESTAMP.txt"
        
        # Use the Nix store path of 'touch' via NIX interpolation (BUILD TIME)
        if ${pkgs.coreutils}/bin/touch "$FILENAME"; then
          ${pkgs.coreutils}/bin/echo "System Ready File Created: $FILENAME"
        else
          ${pkgs.coreutils}/bin/echo "Error: Failed to create file $FILENAME" >&2
          exit 1
        fi
      '';
    in
    {
      config = {
        # 3. Add the script to the system's PATH
        environment.systemPackages = [
          systemReadyScript
        ];
        
        systemd.services.system-ready-timestamp = {
          description = "Create a timestamped file when the system is ready";

          # Options that go into the [Unit] section of the Systemd file
          unitConfig = {
            # Use the Nix option name, which corresponds to the Systemd option name
            # WantedBy is part of the [Install] section, but After is part of [Unit]
            After = [ "network-online.target" "nss-lookup.target" ];
          };

          # Options that go into the [Service] section of the Systemd file
          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${systemReadyScript}/bin/create-system-ready-file";
            RemainAfterExit = true;
          };
          
          # Options that go into the [Install] section
          # The 'WantedBy' is the most common install option used in NixOS
          wantedBy = [ "multi-user.target" ];
        };
      };
      
    };
}

