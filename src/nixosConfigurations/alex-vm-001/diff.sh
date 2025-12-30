# 1. Mount the main Btrfs volume to find the subvolume ID
MAIN_BTRFS_DEV="/dev/mapper/root_vg-root"
TEMP_MOUNT_DIR="/mnt/btrfs_temp_id_check"
sudo mkdir -p "$TEMP_MOUNT_DIR"
sudo mount "$MAIN_BTRFS_DEV" "$TEMP_MOUNT_DIR"

# 2. Find the ID of the persistent marker snapshot
MARKER_ID=$(sudo stat -c %i "$TEMP_MOUNT_DIR/persistent/root_post_boot_marker")

# 3. Unmount
sudo umount "$TEMP_MOUNT_DIR"
sudo rm -rf "$TEMP_MOUNT_DIR"

echo "Reference Marker ID: $MARKER_ID"

# Find new blocks written to the current root (/) since the marker snapshot was created
sudo btrfs subvolume find-new / "$MARKER_ID" | \
# Convert the list of changed blocks (extents) back into file paths
sudo btrfs inspect-cache --seed-files-from-stdin / | \
# Extract just the file paths (usually the second column)
awk '{print $2}' | \
# Ensure each path is listed only once
sort -u