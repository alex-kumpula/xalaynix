{ inputs, config, ... }:
{
  flake.homeConfigurations.alex = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance

    modules = with config.flake.modules.homeManager; [
      alex
    ];
  };

  flake.modules.homeManager.alex = {
    inputs,
    outputs,
    lib,
    config,
    pkgs,
    ...
  }: {
    nixpkgs = {
      config = {
        allowUnfree = true;
      };
    };

    home = {
      username = "alex";
      homeDirectory = "/home/alex";
    };

    # Enable home-manager to install and manage itself
    programs.home-manager.enable = true;

    # Nicely reload system units when changing configs
    systemd.user.startServices = "sd-switch";

    # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
    home.stateVersion = "25.11";
  };
}