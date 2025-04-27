#!/bin/zsh

# netcheck.sh - Network Data Packet Statistics
# This script monitors network packets on a specific port for 3 seconds

# Check if port number is provided
if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <port_number>"
    exit 1
fi

# Validate if input is a valid port number
if ! [[ $1 =~ ^[0-9]+$ ]] || [[ $1 -lt 1 ]] || [[ $1 -gt 65535 ]]; then
    echo "Error: Please provide a valid port number (1-65535)"
    exit 1
fi

PORT=$1

# Use tcpdump to capture packets for the specified port
# Run for 3 seconds using timeout
# Count total packets (sent and received)
PACKET_COUNT=$(timeout 3 tcpdump -q "port $PORT" 2>/dev/null | wc -l)

# Display the result
echo "Packages: $PACKET_COUNT"

exit 0