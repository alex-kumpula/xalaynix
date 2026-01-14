{ ... }:
{
  flake.modules.nixos.example-vm-luks =
  { ... }: 
  {
    programs.git.enable = true;
  };
}