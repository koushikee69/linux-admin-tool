# Linux System Administration Tool

This repository is my submission for the Capstone Project (Assignment 5). It is a single-script tool designed to automate common system maintenance tasks on a Linux (Ubuntu/Debian-based) system.

## Features

* **Argument-Based:** A professional, tool-like script that accepts tasks as arguments (e.g., `./system_tool.sh update`).
* **Automated Backups:** Backs up the `~/Projects` directory to `~/archive/project_backup`.
* **System Updater:** Safely updates package lists, upgrades all installed packages, and cleans up old dependencies.
* **Flexible Log Monitor:** Scans `/var/log/syslog` for any keyword you provide.
* **Full Logging:** All actions are automatically recorded in the `logs/admin.log` file for review.

## How to Run

1.  Clone the repository and `cd` into it.
2.  Make the script executable:
    ```bash
    chmod +x system_tool.sh
    ```
3.  Run the script with a task.

### Examples

* **To run a backup:**
    ```bash
    ./system_tool.sh backup
    ```
* **To run a system update:**
    ```bash
    ./system_tool.sh update
    ```
* **To monitor logs for the word "ERROR":**
    ```bash
    ./system_tool.sh monitor ERROR
    ```
* **To see the help message:**
    ```bash
    ./system_tool.sh
    ```

## Credits

Made by Koushikee[koushikee69]
