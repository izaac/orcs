# ORCS: OpenRC Service Manager

**ORCS** is a simple command-line tool for viewing OpenRC services.  
It provides a color-coded table of service statuses, PIDs, and runlevels, with options for filtering and sorting.

---

## Installation

1. **Place all three files (`orcs`, `orcs.awk`, and `style.sh`) into a single directory.**  
   A common location is `~/.local/bin/`.

   ```sh
   mkdir -p ~/.local/bin/
   mv orcs orcs.awk style.sh ~/.local/bin/
   ```

2. **Make the main script executable.**

   ```sh
   chmod +x ~/.local/bin/orcs
   ```

3. **Ensure your `~/.local/bin/` directory is in your shell's `PATH`.**  
   (Most modern systems do this automatically.)

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

# Display the help message
orcs -h

```
