#!/bin/bash

# Function to install a package if it's not already installed
install_if_not_installed() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installing $1..."
        sudo apt-get install -y "$1"
    else
        echo "$1 is already installed."
    fi
}

# Update package list and upgrade existing packages
echo "Updating package list and upgrading existing packages..."
sudo apt-get update && sudo apt-get upgrade -y

# Install build dependencies for Substrate
echo "Installing build dependencies for Substrate..."
dependencies=("build-essential" "clang" "libclang-dev" "curl" "libssl-dev" "llvm" "libudev-dev" "pkg-config" "zlib1g-dev" "git")
for package in "${dependencies[@]}"; do
    install_if_not_installed "$package"
done

# Install Python3 and pip
echo "Installing Python3 and pip..."
install_if_not_installed "python3"
install_if_not_installed "python3-pip"

# Install Rust and set the correct toolchain
echo "Installing Rust and setting up the toolchain..."
if ! command -v rustup &> /dev/null; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
fi

rustup update
rustup default stable
rustup update nightly
rustup target add wasm32-unknown-unknown --toolchain nightly

echo "Installation and setup complete. Please restart your terminal."
