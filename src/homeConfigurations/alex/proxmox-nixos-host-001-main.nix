{ inputs, config, ... }:
{
  flake.homeConfigurations.proxmox-nixos-host-001-main = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance

    modules = with config.flake.modules.homeManager; [
      proxmox-nixos-host-001-main
    ];
  };

  flake.modules.homeManager.proxmox-nixos-host-001-main = {
    pkgs,
    ...
  }: {
    imports = [
      inputs.xalaynix.modules.homeManager.xalaynix
    ];

    home = {
      username = "main";
      homeDirectory = "/home/main";
    };

    xalaynix = {
      enable = true;
      preset = "minimal";
    };

    # Some example packages
    programs.firefox.enable = true;
    programs.lazydocker.enable = true;
    home.packages = with pkgs; [
      # godot
    ];

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };
}