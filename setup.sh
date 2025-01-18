#!/bin/bash

# Update package lists and upgrade installed packages
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y curl wget git

# Create a 1GB swap file and enable it
sudo dd if=/dev/zero of=/swapfile bs=1024 count=1048576
sudo mkswap /swapfile
sudo chmod 600 /swapfile
sudo swapon /swapfile

# Add the swap entry to /etc/fstab if it doesn't already exist
if ! grep -q '/swapfile none swap sw 0 0' /etc/fstab; then
    echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
fi

echo "Swap file created and enabled successfully."

# Clone and install zram-swap
git clone https://github.com/foundObjects/zram-swap.git
cd zram-swap && sudo ./install.sh
cd ..

# Update /etc/sysctl.conf with VM parameters and network settings
echo -e "\n# Custom VM settings" | sudo tee -a /etc/sysctl.conf
echo "vm.vfs_cache_pressure=500" | sudo tee -a /etc/sysctl.conf
echo "vm.swappiness=100" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_background_ratio=1" | sudo tee -a /etc/sysctl.conf
echo "vm.dirty_ratio=50" | sudo tee -a /etc/sysctl.conf

# Add network settings
echo -e "\n# Custom network settings" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
echo "net.core.default_qdisc = cake" | sudo tee -a /etc/sysctl.conf

# Apply the sysctl settings
sudo sysctl --system

# Update initramfs with zstd and z3fold modules
echo "zstd" | sudo tee -a /etc/initramfs-tools/modules
echo "z3fold" | sudo tee -a /etc/initramfs-tools/modules
sudo update-initramfs -u

# Run the BBR3 installation script
#bash <(curl -Ls https://raw.githubusercontent.com/Naochen2799/Latest-Kernel-BBR3/main/bbr3.sh)
wget https://raw.githubusercontent.com/byJoey/Actions-bbr-v3/refs/heads/main/install.sh
chmod +x install.sh
sudo ./install.sh
echo "Setup complete."
