# Nix-Get 📦

`nix-get` is a simple script to manage NixOS packages, similar to the `apt-get` CLI tool. This script allows you to install packages either for the current user or system-wide.

## Features ✨

- 📥 Install packages for the current user
- 🌐 Install packages system-wide
- 🛠 Automatically detects the current user
- 🔍 Checks for duplicate packages before adding

## Usage 🚀

1. **Download and make the script executable:**

    ```bash
    chmod +x nix-get.sh
    ```

2. **Install a package for the current user:**

    ```bash
    sudo ./nix-get.sh install <package-name>
    ```

3. **Install a package system-wide:**

    ```bash
    sudo ./nix-get.sh --system install <package-name>
    ```

    Replace `<package-name>` with the name of the package you want to install.

## Example 🔧

To install `htop` for the current user:

```bash
sudo ./nix-get.sh install htop
```

To install `htop` system-wide:

```bash
sudo ./nix-get.sh --system install htop
```

## Script Explanation 📝

1. **Root Check:** Ensures the script is run with sudo.
2. **Argument Check:** Validates that the required arguments are provided.
3. **Argument Parsing:** Checks for the `--system` flag.
4. **Action Validation:** Ensures the action is `install`.
5. **Configuration File Check:** Verifies the existence of `/etc/nixos/configuration.nix`.
6. **System-Wide Installation:**
    - Checks if the package is already in the system-wide list.
    - Appends the package if not present.
    - Rebuilds the NixOS configuration.
7. **User-Specific Installation:**
    - Detects the current user.
    - Checks if the package is already in the user's list.
    - Appends the package if not present.
    - Rebuilds the NixOS configuration.
8. **Output Message:** Provides feedback on the success or failure of the operation.

## License 📜

This project is licensed under the MIT License.

## Contributions ❤️

Contributions are welcome! Please fork the repository and submit a pull request.

## Contact 📬

For any questions or feedback, please open an issue on the GitHub repository.
