#!/bin/bash

# Directories and files to migrate
dirs_and_files=(
    "baritone"
    "baritone/settings.txt"
    "config/inventoryprofilesnext"
    "config/litematica"
    "config/minihud"
    "config/personaldictionary"
    "config/sound_physics_remastered"
    "config/stendhal/books"
    "config/voicechat"
    "config/worldedit"
    "Distant_Horizons_server_data"
    "saves"
    "schematics"
    "screenshots"
    "XaeroWaypoints"
    "XaeroWorldMap"
    "emi.json"
    "realms_persistence.json"
    "servers.dat"
)

######################################################################################

echo
echo -e "\033[92m   ██████▓██   ██▓ ███▄    █  ▄████▄\033[0m"
echo -e "\033[92m ▒██    ▒ ▒██  ██▒ ██ ▀█   █ ▒██▀ ▀█\033[0m"
echo -e "\033[92m ░ ▓██▄    ▒██ ██░▓██  ▀█ ██▒▒▓█    ▄\033[0m"
echo -e "\033[92m   ▒   ██▒ ░ ▐██▓░▓██▒  ▐▌██▒▒▓▓▄ ▄██▒\033[0m"
echo -e "\033[92m ▒██████▒▒ ░ ██▒▓░▒██░   ▓██░▒ ▓███▀ ░\033[0m"
echo -e "\033[92m ▒ ▒▓▒ ▒ ░  ██▒▒▒ ░ ▒░   ▒ ▒ ░ ░▒ ▒  ░\033[0m"
echo -e "\033[92m ░ ░▒  ░ ░▓██ ░▒░ ░ ░░   ░ ▒░  ░  ▒\033[0m"
echo -e "\033[92m ░  ░  ░  ▒ ▒ ░░     ░   ░ ░ ░\033[0m"
echo -e "\033[92m       ░  ░ ░              ░ ░ ░\033[0m"
echo -e "\033[92m          ░ ░                ░\033[0m"
echo
echo "Folkhack's Instance Migration Script"

# Error handling function
function print_error() {
    echo
    echo -e "\e[31mERROR: $1\e[0m"
    echo "Exiting with status 1..."
    exit 1
}

# Help function with usage and example
function print_help() {
    echo
    echo "Usage: $0 [--dry-run] <source_directory> <destination_directory>"
    echo "Migrates specified directories/files from source to destination."
    echo "Make sure that both source and destination directories contain 'instance.json'."
    echo ""
    echo "Options:"
    echo "  --dry-run    Show what would have been transferred without making any changes."
    echo ""
    echo "Example:"
    echo "  $0 --dry-run ./source_instance_dir ./destination_instance_dir"
    echo "  $0 ./source_instance_dir ./destination_instance_dir"
    echo
}

# Check for --dry-run option
if [ "$1" == "--dry-run" ]; then
    dry_run="--dry-run"
    shift
else
    dry_run=""
fi

# Validate Source and Destination Separation
function validate_separation() {
    if [ "$1" == "$2" ]; then
        print_error "Source and destination directories cannot be the same."
    elif [ "$(readlink -f "$1")" == "$(readlink -f "$2")" ]; then
        print_error "Source and destination directories cannot resolve to the same location."
    elif [[ "$(readlink -f "$1")" == "$(readlink -f "$2")/"* ]]; then
        print_error "Destination directory cannot be a subdirectory of the source."
    fi
}

# Check for missing arguments
if [ -z "$1" ] || [ -z "$2" ]; then
    print_error "Both source and destination directories are required."
fi

# Check for invalid or missing directories
if [ ! -d "$1" ] || [ ! -d "$2" ]; then
    print_error "Invalid or missing source or destination directory."
fi

# Check for 'instance.json' within the directories
if [ ! -f "$1/instance.json" ] || [ ! -f "$2/instance.json" ]; then
    print_error "'instance.json' not found in source or destination directory."
fi

# Source and Destination Directories
old_instance_dir="$1"
new_instance_dir="$2"

# Validate Source and Destination Separation
validate_separation "$old_instance_dir" "$new_instance_dir"

# Verbose message for dry run
if [ -n "$dry_run" ]; then
    echo
    echo -e "\e[33mWARNING:\e[0m Dry run mode enabled. No changes will be made."
fi

echo
echo -e "\e[96m=== Starting sync! ===\e[0m"
echo

# Migrate directories/files:
for dir in "${dirs_and_files[@]}"; do
    if [ ! -e "$old_instance_dir/$dir" ]; then
        echo -e "Skipping \e[1;95m$dir\e[0m, not found in source directory."
        continue
    fi

    # Warn if directory/file exists in 
    if [ -e "$new_instance_dir/$dir" ]; then
        echo -e "\e[33mWARNING:\e[0m \e[1;95m$dir\e[0m exists in destination directory. Overwriting/syncing may occur."
    fi

    # Ensure to ask for migrating each directory
    while true; do
        echo -en "Sync \e[1;95m$dir\e[0m? (y/n): "
        read -r answer
        if [ "$answer" == "y" ] || [ "$answer" == "n" ]; then
            break
        fi
        echo "Invalid answer. Please enter y or n."
    done

    # Do the thing - the seds make the output light gray
    if [ "$answer" == "y" ]; then
        echo
        rsync -arvmh $dry_run "$old_instance_dir/$dir" "$new_instance_dir" | sed $'s/^/\e[90m/' | sed $'s/$/\e[0m/'
        echo
    fi
done

echo
echo "Done! Exiting with status 0..."
