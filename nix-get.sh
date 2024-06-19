#!/bin/bash

# Check if the script is run as root
if [ "$EUID" -ne 0 ]; then
    echo "Please run as root (use sudo)"
    exit 1
fi

# Check if a package name is provided
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 [--system] install <package-name>"
    exit 1
fi

# Parse the arguments
SYSTEM_WIDE=false
if [ "$1" == "--system" ]; then
    SYSTEM_WIDE=true
    ACTION=$2
    PACKAGE_NAME=$3
else
    ACTION=$1
    PACKAGE_NAME=$2
fi

if [ "$ACTION" != "install" ]; then
    echo "Invalid action. Usage: $0 [--system] install <package-name>"
    exit 1
fi

# Configuration file path
CONFIG_FILE="/etc/nixos/configuration.nix"

# Check if the configuration file exists
if [ ! -f "$CONFIG_FILE" ]; then
    echo "Configuration file not found: $CONFIG_FILE"
    exit 1
fi

if [ "$SYSTEM_WIDE" == true ]; then
    # Function to add the package system-wide
    add_system_package() {
        sed -i "/environment.systemPackages = with pkgs; \[/ s/\[/\[ $PACKAGE_NAME /" "$CONFIG_FILE"
    }

    # Check if the package is already in the system-wide list
    if grep -q "environment.systemPackages = with pkgs;.*\b$PACKAGE_NAME\b" "$CONFIG_FILE"; then
        echo "Package '$PACKAGE_NAME' is already in the system-wide list."
    else
        # Append the package to the system-wide packages list
        add_system_package
        # Rebuild the NixOS configuration to apply changes
        nixos-rebuild switch

        echo "Package '$PACKAGE_NAME' added system-wide and system rebuilt successfully."
    fi
else
    # Get the username of the current user
    USERNAME=$(logname)

    # Function to add the package to the user section
    add_user_package() {
        sed -i "/users.users.$USERNAME = {/,/};/ s/packages = with pkgs; \[/&\n    $PACKAGE_NAME/" "$CONFIG_FILE"
    }

    # Check if the package is already in the user's list
    if grep -q "users.users.$USERNAME.*packages = with pkgs;.*\b$PACKAGE_NAME\b" "$CONFIG_FILE"; then
        echo "Package '$PACKAGE_NAME' is already in the list for user '$USERNAME'."
    else
        # Append the package to the user's packages list
        add_user_package
        # Rebuild the NixOS configuration to apply changes
        nixos-rebuild switch

        echo "Package '$PACKAGE_NAME' added to user '$USERNAME' environment and system rebuilt successfully."
    fi
fi
