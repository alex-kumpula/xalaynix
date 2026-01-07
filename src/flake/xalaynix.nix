{ inputs, ... }:
{
  flake-file.inputs = {
    xalaynix = {
      url = "github:alex-kumpula/xalaynix-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}