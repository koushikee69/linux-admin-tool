#!/bin/bash
#
# Single-Script System Administration Tool
# This script combines all maintenance tasks into one file.
# It is argument-driven.
#

# --- Configuration ---
# Log file will be in a 'logs' directory next to the script
SCRIPT_DIR=$(dirname "$0")
LOG_FILE="$SCRIPT_DIR/logs/admin.log"

# Backup source and destination (Different from Student A)
BACKUP_SOURCE="/home/uvaers/Projects"
BACKUP_DEST="/home/uvaers/archive/project_backup"

# Log file to monitor
LOG_TO_MONITOR="/var/log/syslog"

# --- Utility Functions (Day 5: Logging) ---

# Ensures the log directory and file exist
setup_logging() {
    mkdir -p "$SCRIPT_DIR/logs"
    touch "$LOG_FILE"
}

# Appends a message to the log file
log_message() {
    # This appends the message ($1) to the log file with a timestamp
    echo "[\$(date +'%Y-%m-%d %H:%M:%S')] - \$1" >> "$LOG_FILE"
}

# --- Task Functions ---

# Day 1 Task: Run Backup
run_backup() {
    log_message "--- Backup Task Started ---"
    echo "Starting backup of $BACKUP_SOURCE..."
    
    mkdir -p "$BACKUP_DEST"
    log_message "Ensured backup destination exists: $BACKUP_DEST"

    # [cite_start]Using cp -r as specified in the Raspberry Pi module [cite: 4831]
    cp -r "$BACKUP_SOURCE" "$BACKUP_DEST"
    
    # Day 5: Error Handling
    if [ $? -eq 0 ]; then
        log_message "Backup successful."
        echo "Backup of $BACKUP_SOURCE completed successfully."
    else
        log_message "ERROR: Backup failed. 'cp' command returned an error."
        echo "ERROR: Backup failed. Check '$LOG_FILE' for details."
    fi
    log_message "--- Backup Task Finished ---"
}

# Day 2 Task: Run System Update
run_update() {
    log_message "--- Update Task Started ---"
    echo "Starting system update... This may take a while."
    
    # [cite_start]Using apt commands from the RPi module [cite: 4864]
    log_message "Running 'apt update'..."
    # '>> "$LOG_FILE" 2>&1' redirects all output (stdout and stderr) to the log file
    sudo apt update >> "$LOG_FILE" 2>&1
    
    # Error checking
    if [ $? -ne 0 ]; then
        log_message "ERROR: 'apt update' failed."
        echo "ERROR: 'apt update' failed. Check '$LOG_FILE'."
        exit 1
    fi
    
    log_message "Running 'apt upgrade -y'..."
    sudo apt upgrade -y >> "$LOG_FILE" 2>&1
    
    log_message "Running 'apt autoremove -y'..."
    sudo apt autoremove -y >> "$LOG_FILE" 2>&1
    
    log_message "--- Update Task Finished ---"
    echo "System update complete. See '$LOG_FILE' for details."
}

# Day 3 Task: Monitor Logs
run_monitor() {
    local KEYWORD=$1
    # Check if a keyword was provided
    if [ -z "$KEYWORD" ]; then
        echo "Error: No keyword specified for monitoring."
        echo "Usage: $0 monitor <keyword>"
        log_message "ERROR: 'monitor' task called without keyword."
        return 1
    fi
    
    log_message "--- Log Monitor Task Started (Keyword: $KEYWORD) ---"
    echo "Searching $LOG_TO_MONITOR for '$KEYWORD'..."
    
    # [cite_start]Using 'grep' from RPi module [cite: 4881]
    # We use 'sudo' because /var/log/syslog is protected
    # We save results to a *separate* file, not the main log
    sudo grep -i "$KEYWORD" "$LOG_TO_MONITOR" > "$SCRIPT_DIR/logs/monitor_results.txt"
    
    if [ $? -eq 0 ]; then
        log_message "Found matches for '$KEYWORD'. See 'logs/monitor_results.txt'."
        echo "Found matches. Results are in 'logs/monitor_results.txt'."
    else
        log_message "No matches found for '$KEYWORD'."
        echo "No matches found."
    fi
    log_message "--- Log Monitor Task Finished ---"
}

# --- Main Script Logic (Day 4: Combine) ---

# Show a help message if no arguments are given
if [ $# -eq 0 ]; then
    echo "UVAERS System Admin Tool"
    echo "Usage: $0 <task> [options]"
    echo ""
    echo "Tasks:"
    echo "  backup              - Back up the $BACKUP_SOURCE directory."
    echo "  update              - Update and clean the system."
    echo "  monitor <keyword>   - Monitor system logs for a keyword (e.g., $0 monitor ERROR)."
    exit 1
fi

# Setup logging
setup_logging

TASK=$1
log_message "Task initiated: $TASK"

# Use a 'case' statement to decide which function to run
case $TASK in
    backup)
        run_backup
        ;;
    update)
        run_update
        ;;
    monitor)
        # Pass the second argument (the keyword) to the function
        run_monitor "$2" 
        ;;
    *)
        log_message "Invalid task: $TASK"
        echo "Error: Invalid task '$TASK'."
        echo "Run with no arguments to see help."
        exit 1
        ;;
esac
