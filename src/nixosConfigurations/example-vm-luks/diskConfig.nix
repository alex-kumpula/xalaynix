{ inputs, ... }:
{
  flake.modules.nixos.example-vm-luks = {
    imports = [
      inputs.disko.nixosModules.default
    ];

    disko.devices = {
      disk = {
        main = {
          device = "/dev/vda";
          type = "disk";
          content = {
            type = "gpt";
            partitions = {
              boot = {
                name = "boot";
                size = "4M";
                type = "EF02";
              };
              esp = {
                name = "ESP";
                size = "2G";
                type = "EF00";
                content = {
                  type = "filesystem";
                  format = "vfat";
                  mountpoint = "/boot";
                };
              };
              swap = {
                size = "8G";
                content = {
                  type = "swap";
                  resumeDevice = true;
                };
              };
              root = {
                name = "root";
                size = "100%";
                content = {
                  type = "luks";
                  name = "root-crypt";
                  settings = {
                    allowDiscards = true;
                  };
                  content = {
                    type = "lvm_pv";
                    vg = "root_vg";
                  };
                };
              };
            };
          };
        };
      };
      lvm_vg = {
        root_vg = {
          type = "lvm_vg";
          lvs = {
            root = {
              size = "100%FREE";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];

                subvolumes = {
                  "/root" = {
                    mountpoint = "/";
                    mountOptions = ["subvol=root" "compress=zstd:3" "noatime"];
                  };

                  "/persistent" = {
                    mountOptions = ["subvol=persistent" "compress=zstd:3" "noatime"];
                    mountpoint = "/persistent";
                  };

                  "/nix" = {
                    mountOptions = ["subvol=nix" "compress=zstd:3" "noatime"];
                    mountpoint = "/nix";
                  };
                };
              };
            };
          };
        };
      };
    };
    

    
  };
}

