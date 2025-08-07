# ORCS: OpenRC Service Viewer

**ORCS** is a simple command-line tool for viewing OpenRC services.  
It provides a color-coded table of service statuses, PIDs, and runlevels, with options for filtering and sorting.

---

## Installation

### Easy Install (Recommended)

Install ORCS with a single command using `curl` or `wget`. This will download and run the installer script, placing all necessary files in `~/.local/bin/`.

**With curl:**

```sh
curl -fsSL https://raw.githubusercontent.com/user/orcs/main/install.sh | sh
```

**With wget:**

```sh
wget -qO- https://raw.githubusercontent.com/user/orcs/main/install.sh | sh
```

### Manual Installation

1. Place all four files (`orcs`, `orcs-parse.awk`, `orcs-format.awk`, and `style.sh`) into a single directory, e.g. `~/.local/bin/`:

   ```sh
   mkdir -p ~/.local/bin/
   mv orcs orcs-parse.awk orcs-format.awk style.sh ~/.local/bin/
   ```

2. Make the necessary scripts executable:

   ```sh
   chmod +x ~/.local/bin/orcs
   chmod +x ~/.local/bin/orcs-parse.awk
   chmod +x ~/.local/bin/orcs-format.awk
   ```

3. Ensure your `~/.local/bin/` directory is in your shell's `PATH`.  
   (Most modern systems do this automatically.)

---

## Uninstall

To remove ORCS from your system, simply delete the script files from the installation directory:

```sh
rm ~/.local/bin/orcs \
   ~/.local/bin/orcs-parse.awk \
   ~/.local/bin/orcs-format.awk \
   ~/.local/bin/style.sh
```

---

## Usage

Run the script with `sudo` to ensure it has the necessary permissions to read all service statuses.

```sh
# Show active services (default)
sudo orcs

# Show all services (active and inactive)
sudo orcs --all

# Show only inactive services
sudo orcs --inactive

# Sort active services by name
sudo orcs --active --sort-name

# Show all services sorted by runlevel
sudo orcs --all --sort-runlevel

# Display the help
```

