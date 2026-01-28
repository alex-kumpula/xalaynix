{ ... }:
{
  flake.modules.nixos.proxmox-nixos-host-001 =
  { pkgs, ... }: 
  {
    users.mutableUsers = false;

    users.users.main = {
      isNormalUser = true;
      description = "Main";
      hashedPassword = "$6$ksiRALwz1vVKBvQo$yNdrzMs5OY06lB4tSxsKebQ3n08uDxjWQPu57a8wb3goQYNdNiSB2tarvG4oAAM9DNEOqkNpuRJrLazR306nj0";
      extraGroups = [ "networkmanager" "wheel" ];
      subUidRanges = [ { startUid = 100000; count = 65536; } ]; # Allow user namespaces for containers (fix for rootless docker)
      subGidRanges = [ { startGid = 100000; count = 65536; } ]; # Allow user namespaces for containers (fix for rootless docker)
      packages = with pkgs; [
      #  thunderbird
      ];
    };

    users.users.root = {
      hashedPassword = "$6$ksiRALwz1vVKBvQo$yNdrzMs5OY06lB4tSxsKebQ3n08uDxjWQPu57a8wb3goQYNdNiSB2tarvG4oAAM9DNEOqkNpuRJrLazR306nj0";
    };
  };
}