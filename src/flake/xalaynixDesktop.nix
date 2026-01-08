{ inputs, ... }:
{
  flake-file.inputs = {
    xalaynixDesktop = {
      url = "github:alex-kumpula/xalaynix-desktop";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}