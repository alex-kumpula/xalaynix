# This is your home-manager configuration file
# Use this to configure your home environment (it replaces ~/.config/nixpkgs/home.nix)
{
  flake.modules.homeManager.alex =
    {
      inputs,
      outputs,
      lib,
      config,
      pkgs,
      ...
    }: {
      # You can import other home-manager modules here
      imports = [

      ];
      
      nixpkgs = {

        # Configure your nixpkgs instance
        config = {
          # Disable if you don't want unfree packages
          allowUnfree = true;
        };
      };

      # TODO - DONE: Set your username
      home = {
        username = "alex";
        homeDirectory = "/home/alex";
      };

      # Enable home-manager to install and manage itself
      programs.home-manager.enable = true;

      # Nicely reload system units when changing configs
      systemd.user.startServices = "sd-switch";

      # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
      home.stateVersion = "23.05";
    };
}
