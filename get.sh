#!/bin/bash

# Check if port number is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <port_number>"
    exit 1
fi

PORT=$1

# Use lsof to check if any program is using the specified port
PROCESS_INFO=$(lsof -i :$PORT -t 2>/dev/null)

if [ -z "$PROCESS_INFO" ]; then
    echo "OK"
else
    # Get the first PID using the port
    PID=$(echo "$PROCESS_INFO" | head -1)
    
    # Use ps to get the full path of the program
    EXECUTABLE_PATH=$(ps -o comm= -p $PID)
    
    # For certain programs, we might need to check /proc filesystem for the full path
    if [ -e "/proc/$PID/exe" ]; then
        FULL_PATH=$(readlink -f /proc/$PID/exe)
        echo "$FULL_PATH"
    else
        echo "$EXECUTABLE_PATH"
    fi
fi