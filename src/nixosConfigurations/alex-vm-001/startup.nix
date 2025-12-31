{ inputs, config, lib, ... }:
{
  flake.modules.nixos.startupTest =
    { pkgs, ... }:
    let
      # 1. Define a Nix variable for the build date (Example of Nix interpolation)
      # This date will be baked into the script when you run nixos-rebuild.
      BUILD_DATE = (builtins.currentTime);

      # 2. Define the Script/Command
      # Note the mix of Nix and Bash variables below:
      systemReadyScript = pkgs.writeShellScriptBin "create-system-ready-file" ''
        #!/bin/sh

        # It gets the current time when the script executes.
        RUNTIME_TIMESTAMP=$(${pkgs.coreutils}/bin/date +%Y-%m-%d_%H-%M-%S)
        
        # This is a NIX variable, replaced at BUILD TIME.
        # It gets the date the configuration was built.
        BUILD_DATE="${BUILD_DATE}" 
        
        TARGET_DIR="/var"
        
        # Create the timestamped file. We include both timestamps for demonstration.
        FILENAME="$TARGET_DIR/system_ready_file_RUNTIME-$RUNTIME_TIMESTAMP-BUILT-$BUILD_DATE.txt"
        
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
      # 3. Add the script to the system's PATH
      environment.systemPackages = [
        systemReadyScript
      ];
      
      # 4. Define the Standard Systemd Service (no changes needed here)
      systemd.services.system-ready-timestamp = {
        description = "Create a timestamped file when the system is ready";
        Service.Type = "oneshot";
        Service.ExecStart = "${systemReadyScript}/bin/create-system-ready-file";
        Unit.WantedBy = [ "multi-user.target" ];
        Unit.After = [ "network-online.target" ];
        Service.RemainAfterExit = true;
      };
    };
}

