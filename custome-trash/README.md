# Trash-Enabled rm Command

A custom Linux command that moves files to a trash directory instead of permanently deleting them.

## Overview

This project implements a safer alternative to the standard `rm` command in Linux. Instead of permanently deleting files, this custom implementation moves them to a designated trash directory where they can be recovered if needed.

## Features

- Creates a temporary trash directory (`/tmp/trash`)
- Moves files to trash instead of deleting them permanently
- Adds timestamps to filenames in trash to prevent conflicts
- Supports common rm options (-f, -r, -v)
- Easy to install and use for beginners

## Installation

1. Create the trash directory:
```bash
mkdir -p /tmp/trash
chmod 777 /tmp/trash
```

2. Create a personal bin directory:
```bash
mkdir -p ~/bin
```

3. Create the custom rm script:
```bash
touch ~/bin/rm
chmod +x ~/bin/rm
```

4. Edit the script with your favorite text editor (like nano or vim):
```bash
nano ~/bin/rm
```

5. Copy and paste the script content (see below)

6. Update your PATH to use the custom command:
```bash
echo 'export PATH="$HOME/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

## Script Content

```bash
#!/bin/bash

# Custom rm command that moves files to trash instead of deleting them

# Get the current date and time for uniqueness
DATE=$(date +%Y%m%d_%H%M%S)

# Process command line arguments
force=false
recursive=false
verbose=false
files=()

# Parse arguments
for arg in "$@"; do
  case $arg in
    -f|--force)
      force=true
      ;;
    -r|-R|--recursive)
      recursive=true
      ;;
    -v|--verbose)
      verbose=true
      ;;
    -*)
      # For other options, pass them to the real rm command if needed
      ;;
    *)
      files+=("$arg")
      ;;
  esac
done

# Check if no files were specified
if [ ${#files[@]} -eq 0 ]; then
  echo "rm: missing operand"
  echo "Try 'rm --help' for more information."
  exit 1
fi

# Process each file
for file in "${files[@]}"; do
  # Check if file exists
  if [ ! -e "$file" ] && [ ! -L "$file" ]; then
    if [ "$force" = true ]; then
      # If force option is used, silently ignore non-existent files
      continue
    else
      echo "rm: cannot remove '$file': No such file or directory"
      exit 1
    fi
  fi
  
  # Get the filename without path
  filename=$(basename "$file")
  
  # Create a unique name in case of duplicates in trash
  trash_name="${filename}_${DATE}"
  
  # Move the file to trash
  if mv "$file" "/tmp/trash/$trash_name"; then
    if [ "$verbose" = true ]; then
      echo "Moved '$file' to trash as '$trash_name'"
    fi
  else
    echo "Failed to move '$file' to trash"
    exit 1
  fi
done

exit 0
```

## Usage

Use the command just like you would use the regular `rm` command:

```bash
# Move a file to trash
rm file.txt

# Use the force option
rm -f file.txt

# Use the verbose option to see what's happening
rm -v file.txt

# Check what's in the trash
ls -la /tmp/trash
```

## Script Explanation

1. `#!/bin/bash` - Tells the system to use the Bash shell to interpret this script
2. `DATE=$(date +%Y%m%d_%H%M%S)` - Creates a timestamp for unique filenames
3. The script then processes any options passed to it (-f, -r, -v)
4. For each file specified, it:
   - Checks if the file exists
   - Creates a unique name using the original filename + timestamp
   - Moves the file to the trash directory instead of deleting it
   - Reports success or failure

## Additional Utilities (Optional)

### Trash Cleanup Script

```bash
#!/bin/bash
# trash-empty script to remove files older than 7 days
find /tmp/trash -type f -mtime +7 -exec /bin/rm -f {} \;
```

### File Recovery Script

```bash
#!/bin/bash
# trash-restore script
if [ $# -eq 0 ]; then
  echo "Usage: trash-restore FILENAME"
  exit 1
fi

ls -l /tmp/trash | grep $1
echo "Enter the exact filename to restore: "
read filename

if [ -f "/tmp/trash/$filename" ]; then
  # Extract original filename before the timestamp
  original=$(echo $filename | sed 's/_[0-9]\{8\}_[0-9]\{6\}$//')
  mv "/tmp/trash/$filename" "./$original"
  echo "Restored $filename as $original"
else
  echo "File not found in trash"
fi
```

## Important Notes

- Files in `/tmp/trash` may be deleted during system reboot (as /tmp is typically cleared)
- For a more permanent solution, consider using `~/.trash` instead
- This script is intended for educational purposes - consider using existing trash utilities for production environments


## Acknowledgments

- Inspired by the need to prevent accidental file deletion in Linux systems
- Created as a learning project for shell scripting basics