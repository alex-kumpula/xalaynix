{ inputs, lib, flake-parts-lib, ... }:
{
  flake-file = {
    inputs.home-manager.url = "github:nix-community/home-manager/release-25.11";
    inputs.home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];


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