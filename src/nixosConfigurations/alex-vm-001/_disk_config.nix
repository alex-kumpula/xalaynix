{ lib, pkgs, ... }:
let
  device = "/dev/vda";

  rootExplosion = ''
    echo "Time to 🧨" >/dev/kmsg
    # Back up / with timestamp under /old_roots
    mkdir /btrfs_tmp
    mount /dev/mapper/root_vg-root /btrfs_tmp

    # TODO: uncomment for actual 🧨
    # Root impermanence
    if [[ -e /btrfs_tmp/root ]]; then
        mkdir -p /btrfs_tmp/persistent/old_roots
        timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%d_%H:%M:%S")
        if [[ ! -e /btrfs_tmp/persistent/old_roots/$timestamp ]]; then
          mv /btrfs_tmp/root "/btrfs_tmp/persistent/old_roots/$timestamp"
        else
          btrfs subvolume delete /btrfs_tmp/root
        fi
    fi

    ###
    # GC
    ###
    # Recursively Garbage Collect: old_roots older than 30 days
    delete_subvolume_recursively() {
        IFS=$'\n'

        # If we accidentally end up with a file or directory under old_roots,
        # the code will enumerate all subvolumes under the main volume.
        # We don't want to remove everything under true main volume. Only
        # proceed if this path is a btrfs subvolume (inode=256).
        if [ $(stat -c %i "$1") -ne 256 ]; then return; fi

        for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
            echo "Performing GC on $i" >/dev/kmsg
            delete_subvolume_recursively "/btrfs_tmp/$i"
        done
        btrfs subvolume delete "$1"
    }
    latest_snapshot=$(find /btrfs_tmp/persistent/old_roots/ -mindepth 1 -maxdepth 1 -type d | sort -r | head -n 1)
    # Only delete old snapshots if there's at least one that will remain after deletion
    if [ -n "$latest_snapshot" ]; then
        for i in $(find /btrfs_tmp/persistent/old_roots/ -mindepth 1 -maxdepth 1 -mtime +30 | grep -v -e "$latest_snapshot"); do

            delete_subvolume_recursively "$i"
        done
    fi

    # TODO: uncomment for actual 🧨
    btrfs subvolume create /btrfs_tmp/root
    umount /btrfs_tmp
    echo "Done with 🧨. Au revoir!" >/dev/kmsg
  '';
in
{
  # boot.initrd.systemd.services.recreate-root = {
  #   description = "Rolling over and creating new filesystem root";

  #   wantedBy = [ "initrd.target" ];
  #   requires = [ "initrd-root-device.target" ];
  #   after = [
  #     "initrd-root-device.target"
  #     "local-fs-pre.target"
  #   ];
  #   before = [
  #     "sysroot.mount"
  #     "create-needed-for-boot-dirs.service"
  #   ];

  #   unitConfig.DefaultDependencies = "no";
  #   serviceConfig.Type = "oneshot";

  #   script = ''
  #     mkdir /btrfs_tmp
  #     mount /dev/root_vg/root /btrfs_tmp
  #     if [[ -e /btrfs_tmp/root ]]; then
  #         mkdir -p /btrfs_tmp/old_roots
  #         timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #         mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #     fi

  #     delete_subvolume_recursively() {
  #         IFS=$'\n'
  #         for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #             delete_subvolume_recursively "/btrfs_tmp/$i"
  #         done
  #         btrfs subvolume delete "$1"
  #     }

  #     for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #         delete_subvolume_recursively "$i"
  #     done

  #     btrfs subvolume create /btrfs_tmp/root
  #     umount /btrfs_tmp
  #   '';
  # };

  # boot.initrd.postResumeCommands = lib.mkAfter ''
  #   mkdir /btrfs_tmp
  #   mount /dev/root_vg/root /btrfs_tmp
  #   if [[ -e /btrfs_tmp/root ]]; then
  #       mkdir -p /btrfs_tmp/old_roots
  #       timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
  #       mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
  #   fi

  #   delete_subvolume_recursively() {
  #       IFS=$'\n'
  #       for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
  #           delete_subvolume_recursively "/btrfs_tmp/$i"
  #       done
  #       btrfs subvolume delete "$1"
  #   }

  #   for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
  #       delete_subvolume_recursively "$i"
  #   done

  #   btrfs subvolume create /btrfs_tmp/root
  #   umount /btrfs_tmp
  # '';

  
  # Explode / on every boot and resume, see https://grahamc.com/blog/erase-your-darlings/
  boot.initrd.systemd = {
    extraBin = {
      grep = "${pkgs.gnugrep}/bin/grep";
    };
    services = {
      root-explode = {
        wantedBy = ["initrd-root-device.target"];
        wants = ["lvm2-activation.service"];
        # See https://github.com/nix-community/impermanence/issues/250#issuecomment-2603848867
        after = ["lvm2-activation.service" "local-fs-pre.target"];
        before = ["sysroot.mount"];
        # Run on cold boot only, never on resume from hibernation
        unitConfig = {
          ConditionKernelCommandLine = ["!resume="];
          RequiresMountsFor = ["/dev/mapper/nixos--vg-root"];
        };
        serviceConfig = {
          StandardOutput = "journal+console";
          StandardError = "journal+console";
          Type = "oneshot";
        };
        script = rootExplosion;
      };
    };
  };

  boot.tmp.cleanOnBoot = true;

  fileSystems."/persistent" = {
    # device = "/dev/root_vg/root";
    neededForBoot = true;
    # fsType = "btrfs";
    # options = [ "subvol=persist" ];
  };

  environment.persistence."/persistent/system" = {
    enable = true;
    hideMounts = true;
    directories = [
      "/var/lib/nixos"
      "/var/lib/systemd/coredump"
      "/var/lib/systemd/timers"
      "/var/lib/udisks2"
      "/var/log"
    ];
    # files = [
    #   "/etc/machine-id"
    #   # "/var/lib/logrotate.status" # TODO: doesn't play nicely with the service yet
    # ];
  };

  disko.devices = {
    disk.main = {
      inherit device;
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
              type = "lvm_pv";
              vg = "root_vg";
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
}