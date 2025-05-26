#!/bin/bash

# Stop and disable the service
sudo systemctl stop mtg
sudo systemctl disable mtg

# Remove the service file
sudo rm /etc/systemd/system/mtg.service

# Remove the configuration and binary
sudo rm -rf /etc/mtg

# Remove Go installation
sudo rm -rf /usr/local/go

# Remove Go from PATH (remove the line from .bashrc)
sed -i '/export PATH=$PATH:\/usr\/local\/go\/bin/d' ~/.bashrc

# Reload systemd
sudo systemctl daemon-reload

echo "MTProto proxy has been completely uninstalled!" 