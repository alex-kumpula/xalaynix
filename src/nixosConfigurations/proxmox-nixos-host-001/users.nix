{ ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { pkgs, ... }: 
  {
    users.users.main = {
      isNormalUser = true;
      description = "Main";
      initialPassword = "changeme";
      extraGroups = [ "networkmanager" "wheel" ];
      subUidRanges = [ { startUid = 100000; size = 65536; } ]; # Allow user namespaces for containers (fix for rootless docker)
      subGidRanges = [ { startGid = 100000; size = 65536; } ]; # Allow user namespaces for containers (fix for rootless docker)
      packages = with pkgs; [
      #  thunderbird
      ];
    };
  };
}