# ORCS: OpenRC Service Manager

**ORCS** is a simple command-line tool for viewing and managing OpenRC services.  
It provides a color-coded table of service statuses, PIDs, and runlevels, with options for filtering and sorting.

---

## Installation

### Easy Install (Recommended)

You can install ORCS with a single command. The installer must be run with `sudo` because it places the files in system-wide directories (`/usr/local/lib` and `/usr/local/bin`).

**With curl:**

```sh
curl -fsSL https://raw.githubusercontent.com/izaac/orcs/main/install.sh | sudo sh
```

**With wget:**

```sh
wget -qO- https://raw.githubusercontent.com/izaac/orcs/main/install.sh | sudo sh
```

### Manual Installation

If you prefer to install manually after cloning the repository:

1. Navigate to the project directory:

   ```sh
   cd orcs
   ```

2. Create a symbolic link to the `orcs` executable from a directory in your `PATH`.  
   A standard location for system-wide commands is `/usr/local/bin/`:

   ```sh
   sudo ln -s "$(pwd)/bin/orcs" /usr/local/bin/orcs
   ```

---

## Uninstall

To remove ORCS from your system, simply delete the project directory and the symbolic link.

```sh
# Remove the symbolic link
sudo rm /usr/local/bin/orcs

# Remove the project's library files
sudo rm -rf /usr/local/lib/orcs
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

This tool is an independent project and is not affiliated with or endorsed by the official [OpenRC](https://github.com/OpenRC/openrc) project.  
It is a wrapper script designed for convenience and should be used at your own risk.  
The authors are not responsible for any damage to your system.  
When in doubt, always use the official `rc-service` and `rc-status` commands directly.
