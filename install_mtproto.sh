#!/bin/bash

# Update system
sudo apt update
sudo apt upgrade -y

# Install required packages
sudo apt install -y git curl build-essential libssl-dev zlib1g-dev

# Install Go
wget https://go.dev/dl/go1.21.6.linux-amd64.tar.gz
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf go1.21.6.linux-amd64.tar.gz
rm go1.21.6.linux-amd64.tar.gz

# Add Go to PATH
echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
source ~/.bashrc

# Clone MTProto proxy repository
git clone https://github.com/9seconds/mtg.git
cd mtg

# Build MTProto proxy
go build

# Create configuration directory
sudo mkdir -p /etc/mtg

# Generate secret
SECRET=$(./mtg generate-secret -c google.com)

# Create systemd service
sudo tee /etc/systemd/system/mtg.service << EOF
[Unit]
Description=MTProto proxy service
After=network.target

[Service]
Type=simple
User=root
WorkingDirectory=/etc/mtg
ExecStart=/etc/mtg/mtg run /etc/mtg/mtg.toml
Restart=always
RestartSec=10

[Install]
WantedBy=multi-user.target
EOF

# Create configuration file
sudo tee /etc/mtg/mtg.toml << EOF
secret = "${SECRET}"
bind-to = "0.0.0.0:443"
EOF

# Copy binary to configuration directory
sudo cp mtg /etc/mtg/

# Start and enable service
sudo systemctl daemon-reload
sudo systemctl enable mtg
sudo systemctl start mtg

# Print connection information
echo "MTProto proxy has been installed and started!"
echo "Secret: ${SECRET}"
echo "Port: 443"
echo "You can check the status with: sudo systemctl status mtg" 