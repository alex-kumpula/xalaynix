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
      packages = with pkgs; [
      #  thunderbird
      ];
    };
  };
}