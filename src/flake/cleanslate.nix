{ inputs, ... }:
{
  flake-file.inputs = {
    cleanslate = {
      url = "github:alex-kumpula/nixos-cleanslate";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}