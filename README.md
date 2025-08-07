# ORCS: OpenRC Service Manager

**ORCS** is a simple command-line tool for viewing and managing OpenRC services.
It provides a color-coded table of service statuses, PIDs, and runlevels, with options for filtering and sorting.

---

## Installation

### Easy Install (Recommended)

You can install ORCS with a single command using `curl` or `wget`. This will download and run an installer script that places all the necessary files in `~/.local/bin/`.

**With `curl`:**

```sh
curl -fsSL https://raw.githubusercontent.com/izaac/orcs/main/install.sh | sh
```

**With `wget`:**

```sh
wget -qO- https://raw.githubusercontent.com/izaac/orcs/main/install.sh | sh
```

### Manual Installation

If you prefer to install manually, for example after cloning from Git:

1. **Navigate to the project directory.**

   ```sh
   cd orcs-project
   ```

2. **Create a symbolic link to the `orcs` executable from a directory in your PATH.**
   This makes the `orcs` command available system-wide while keeping the project files self-contained. A standard location is `~/.local/bin/`.

   ```sh
   # Ensure the target directory exists
   mkdir -p ~/.local/bin

   # Create the symbolic link (use 'pwd' to get the absolute path)
   ln -s "$(pwd)/bin/orcs" ~/.local/bin/orcs
   ```

3. **Ensure `~/.local/bin` is in your shell's `PATH`.**
   Most modern systems configure this automatically. You can check by running `echo $PATH`. If it's not present, add the following line to your shell's startup file (e.g., `~/.bashrc`, `~/.zshrc`):

   ```sh
   export PATH="$HOME/.local/bin:$PATH"
   ```

---

## Uninstall

To remove ORCS from your system, simply delete the project directory and the symbolic link.

```sh
# Remove the symbolic link
rm ~/.local/bin/orcs

# Remove the project directory
rm -rf /path/to/your/orcs-project
```

---

## Usage

### Viewing Services

Run the script with `sudo` to ensure it has the necessary permissions to read all service statuses.

```sh
# Show all services
sudo orcs --all

# Show only inactive services
sudo orcs --inactive

# Sort active services by name
sudo orcs --sort-name
```

### Managing Services

Use the subcommands `start`, `stop`, or `restart` followed by the service name.

```sh
# Example: Stop the 'sshd' service
sudo orcs stop sshd

# Example: Start the 'docker' service
sudo orcs start docker
```

---

## Disclaimer

This tool is an independent project and is not affiliated with or endorsed by the official OpenRC project. It is a wrapper script designed for convenience and should be used at your own risk. The authors are not responsible for any damage to your system. When in doubt, always use the official `rc-service` and `rc-status` commands directly.
