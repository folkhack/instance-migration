# Folkhack's Instance Sync Script

This script allows you to sync/migrate specified directories and files from one location to another. It includes various features to ensure a smooth transfer, such as error handling, validation, and a dry-run option.

## Features

- **Dry-Run Mode**: See what would have been transferred without making any changes.
- **Validation**: Ensures the source and destination directories are valid and not the same.
- **Confirmation**: Asks for confirmation before syncing each directory or file.
- **Colorful Output**: Provides colored messages to enhance readability.

## Prerequisites

- Bash shell (UNIX-like operating system)
- rsync

## Usage

```
./sync.sh [--dry-run] <source_directory> <destination_directory>
```

### Options

- `--dry-run`: Show what would have been transferred without making any changes.

### Examples

```bash
./sync.sh --dry-run ./source_instance_dir ./destination_instance_dir
./sync.sh ./source_instance_dir ./destination_instance_dir
```

## Directories and Files to Migrate

The script is configured to migrate the following directories and files:

```
baritone
baritone/settings.txt
config/inventoryprofilesnext
config/litematica
config/minihud
config/personaldictionary
config/sound_physics_remastered
config/stendhal/books
config/voicechat
config/worldedit
Distant_Horizons_server_data
saves
schematics
screenshots
XaeroWaypoints
XaeroWorldMap
emi.json
realms_persistence.json
servers.dat
```

## Usage Notes

* Errors are handled gracefully with descriptive messages
* Existing files in the destination directory that match the ones in the source directory will be overwritten or synced
