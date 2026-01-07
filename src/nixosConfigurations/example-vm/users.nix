{ ... }:
{
  flake.modules.nixos.example-vm =
  { pkgs, ... }: 
  {
    users.users.defaultUser = {
      isNormalUser = true;
      description = "Default User";
      initialPassword = "changeme";
      extraGroups = [ "networkmanager" "wheel" ];
      packages = with pkgs; [
      #  thunderbird
      ];
    };
  };
}