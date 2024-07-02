#!/bin/bash

# Function to install a package if it's not already installed
install_if_not_installed() {
    if ! dpkg -l | grep -q "$1"; then
        echo "Installing $1..."
        if ! sudo apt-get install -y "$1"; then
            echo "Failed to install $1. Continuing to next step."
        fi
    else
        echo "$1 is already installed."
    fi
}

# Update package list and upgrade existing packages
echo "Updating package list and upgrading existing packages..."
if ! sudo apt-get update -y && sudo apt-get upgrade -y; then
    echo "Failed to update and upgrade packages. Continuing to next step."
fi

# Install Python3 and pip
echo "Installing Python3 and pip..."
install_if_not_installed "python3"
install_if_not_installed "python3-pip"

# Install Rust and set the correct toolchain
echo "Installing Rust and setting up the toolchain..."
if ! command -v rustup &> /dev/null; then
    if ! curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y; then
        echo "Failed to install rustup. Continuing to next step."
    else
        source $HOME/.cargo/env
    fi
fi

if ! rustup update; then
    echo "Failed to update Rust. Continuing to next step."
fi

if ! rustup default stable; then
    echo "Failed to set Rust to stable. Continuing to next step."
fi

if ! rustup update nightly; then
    echo "Failed to update Rust nightly. Continuing to next step."
fi

if ! rustup target add wasm32-unknown-unknown --toolchain nightly; then
    echo "Failed to add wasm32-unknown-unknown target. Continuing to next step."
fi

echo "Installation and setup complete. Please restart your terminal."
