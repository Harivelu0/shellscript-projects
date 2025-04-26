# Linux Server Information Script

A simple bash script to quickly retrieve and display system information on a Linux server.

## Overview

This script provides a comprehensive overview of a server's hardware, software, and network configuration, including:
- CPU count
- Memory usage (total and free)
- Disk size
- System architecture (32/64-bit)
- Running processes count
- Installed software packages count
- IP address

## Preview

```
$ sh getinfo.sh
cpu num: 8
memory total: 30G
memory free: 10867 M
disk size: 20G
system bit: 64
process: 40
software num: 1389
ip: 1.32.X.X
```

## Installation

1. Download the script:
   ```
   curl -O https://raw.githubusercontent.com/yourusername/linux-server-info/main/getinfo.sh
   ```

2. Make it executable:
   ```
   chmod +x getinfo.sh
   ```

## Usage

Simply run the script:
```
./getinfo.sh
```

Or with sh:
```
sh getinfo.sh
```

## Features

- **Cross-distribution compatibility**: Works on both Debian/Ubuntu and other Linux distributions
- **Automatic detection**: Uses available system commands with fallbacks when needed
- **Simple output**: Easy-to-read format with key system metrics

## Script Details

```bash
#!/bin/bash

cpu_num=$(nproc)
echo "cpu num: $cpu_num"

mem_total=$(free -h | grep "Mem" | awk '{print $2}')
echo "memory total: $mem_total"

mem_free=$(free -m | grep "Mem" | awk '{print $4}')
echo "memory free: $mem_free M"

disk_size=$(df -h / | grep "/" | awk '{print $2}')
echo "disk size: $disk_size"

system_bit=$(getconf LONG_BIT)
echo "system bit: $system_bit"

process_count=$(ps -e | wc -l)
echo "process: $process_count"

if command -v dpkg-query &> /dev/null; then
    sw_num=$(dpkg-query -f '${binary:Package}\n' -W | wc -l)
else
    sw_num=$(ls /usr/bin | wc -l)
fi
echo "software num: $sw_num"

ip_addr=$(hostname -I | awk '{print $1}')
echo "ip: $ip_addr"
```

## License

MIT

## Contributing

Contributions are welcome! Feel free to submit a Pull Request.