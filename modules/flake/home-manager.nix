{ inputs, lib, flake-parts-lib, ... }:
{
  flake-file = {
    inputs.home-manager.url = "github:nix-community/home-manager/release-25.11";
    inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];


  flake.homeConfigurations = {
    # FIXME - DONE replace with your username@hostname
    "alex" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = inputs.nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance

      modules = [
        ./home.nix
      ];
    };
  };

  # homeConfigurations = {
  #     # FIXME - DONE replace with your username@hostname
  #     "alex" = home-manager.lib.homeManagerConfiguration {
  #       pkgs = nixpkgs.legacyPackages.x86_64-linux; # Home-manager requires 'pkgs' instance
  #       extraSpecialArgs = mySpecialArgs;
  #       modules = [
  #         # > Our main home-manager configuration file <
  #         ./homes/alex/home.nix
  #         {
  #           home.packages = [affinity-nix.packages.x86_64-linux.v3];
  #         }
  #       ];
  #     };
  #   };


  # Required to define `homeConfigurations` in multiple files.
  # Otherwise:
  #   The option `flake.homeConfigurations' is defined multiple times while it's expected to be unique.
  # options = {
  #   flake = flake-parts-lib.mkSubmoduleOptions {
  #     homeConfigurations = lib.mkOption {
  #       type = with lib.types; lazyAttrsOf raw;
  #       default = { };
  #     };
  #   };
  # };
}