#!/bin/bash

# Define variables
ROOTFS_SIZE_MB=100
ROOTFS_IMAGE_NAME=centos7-rootfs.img
CENTOS7_MINIMAL_URL=http://mirror.centos.org/centos/7.9.2009/os/x86_64/images/minimal/CentOS-7-x86_64-Minimal-2009.iso

# Download CentOS 7 minimal ISO image
echo "Downloading CentOS 7 minimal ISO image..."
curl -L -o centos7-minimal.iso $CENTOS7_MINIMAL_URL

# Extract rootfs from ISO image
echo "Extracting rootfs from CentOS 7 minimal ISO image..."
7z x -so centos7-minimal.iso \
  'CentOS_BuildTag' 'CentOS_BuildTime' 'EFI/BOOT/*' \
  'isolinux/*' 'LiveOS/*' 'Packages/*' 'repodata/*' | \
  xzcat | tar -xf - -C rootfs/

# Create rootfs image
echo "Creating rootfs image..."
dd if=/dev/zero of=$ROOTFS_IMAGE_NAME bs=1M count=$ROOTFS_SIZE_MB
mkfs.ext4 -F $ROOTFS_IMAGE_NAME
sudo mkdir -p /mnt/loop
sudo mount -o loop $ROOTFS_IMAGE_NAME /mnt/loop
sudo cp -a rootfs/* /mnt/loop/
sudo umount /mnt/loop

# Clean up
echo "Cleaning up..."
rm -rf rootfs/
rm centos7-minimal.iso

echo "Done!"
