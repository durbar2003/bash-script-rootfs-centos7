#!/bin/bash

# Define variables
ROOTFS_SIZE_MB=100
ROOTFS_IMAGE_NAME=centos7-rootfs.img
DOCKERFILE_PATH=Dockerfile.centos7

# Build Docker image
echo "Building Docker image..."
docker build -f $DOCKERFILE_PATH -t centos7-firecracker .

# Run Docker container to extract rootfs files
echo "Extracting rootfs files..."
docker run --rm \
  -v "$(pwd)/rootfs:/rootfs" \
  centos7-firecracker \
  /bin/bash -c "mkdir -p /rootfs && rpm2cpio /tmp/centos7-minimal.rpm | cpio -idmv -D /rootfs"

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
docker rmi centos7-firecracker

echo "Done!"
