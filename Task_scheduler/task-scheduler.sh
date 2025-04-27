#!/bin/bash

# Task Scheduler using Bash
# This script allows for managing scheduled tasks using crontab

# Function to display header
display_header() {
    clear
    echo "====================================="
    echo "        BASH TASK SCHEDULER          "
    echo "====================================="
    echo
}

# Function to display all scheduled tasks
display_tasks() {
    display_header
    echo "CURRENTLY SCHEDULED TASKS:"
    echo "====================================="
    
    # Check if crontab exists
    if crontab -l 2>/dev/null | grep -v "^#" | grep -q .; then
        # Display tasks with line numbers
        crontab -l | grep -v "^#" | grep . | nl -w2 -s') '
    else
        echo "No tasks currently scheduled."
    fi
    
    echo
    echo "Press Enter to continue..."
    read -r
}

# Function to add a new task
add_task() {
    display_header
    echo "ADD NEW SCHEDULED TASK"
    echo "====================================="
    echo
    echo "Please select the schedule type:"
    echo "1) Hourly"
    echo "2) Daily"
    echo "3) Weekly"
    echo "4) Custom (Advanced)"
    echo "5) Return to main menu"
    echo
    read -p "Enter your choice (1-5): " schedule_type
    
    case $schedule_type in
        1) # Hourly
            minute=$(( RANDOM % 60 ))
            cron_time="$minute * * * *"
            timing_desc="Hourly at $minute minutes past the hour"
            ;;
        2) # Daily
            minute=$(( RANDOM % 60 ))
            hour=$(( RANDOM % 24 ))
            cron_time="$minute $hour * * *"
            timing_desc="Daily at $hour:$minute"
            ;;
        3) # Weekly
            minute=$(( RANDOM % 60 ))
            hour=$(( RANDOM % 24 ))
            day_of_week=$(( RANDOM % 7 ))
            day_names=("Sunday" "Monday" "Tuesday" "Wednesday" "Thursday" "Friday" "Saturday")
            cron_time="$minute $hour * * $day_of_week"
            timing_desc="Weekly on ${day_names[$day_of_week]} at $hour:$minute"
            ;;
        4) # Custom
            echo
            read -p "Enter cron expression (e.g., '30 2 * * 1' for Monday at 2:30 AM): " cron_time
            timing_desc="Custom schedule: $cron_time"
            ;;
        5) # Return to main menu
            return
            ;;
        *)
            echo "Invalid selection. Please try again."
            sleep 2
            add_task
            return
            ;;
    esac
    
    # Get the command to execute
    echo
    echo "Schedule: $timing_desc"
    echo
    read -p "Enter the command to execute: " task_command
    
    if [ -z "$task_command" ]; then
        echo "Command cannot be empty. Task not added."
        sleep 2
        return
    fi
    
    # Add task to crontab
    (crontab -l 2>/dev/null; echo "$cron_time $task_command # Scheduled via Task Scheduler") | crontab -
    
    echo
    echo "Task added successfully!"
    echo "Schedule: $timing_desc"
    echo "Command: $task_command"
    echo
    echo "Press Enter to continue..."
    read -r
}

# Function to remove a task
remove_task() {
    display_header
    echo "REMOVE SCHEDULED TASK"
    echo "====================================="
    echo
    
    # Check if crontab exists
    if ! crontab -l 2>/dev/null | grep -v "^#" | grep -q .; then
        echo "No tasks currently scheduled."
        echo
        echo "Press Enter to continue..."
        read -r
        return
    fi
    
    # Display tasks with line numbers
    crontab -l | grep -v "^#" | grep . | nl -w2 -s') '
    
    echo
    read -p "Enter the number of the task to remove (0 to cancel): " task_number
    
    if [ "$task_number" -eq 0 ]; then
        return
    fi
    
    # Get the total number of tasks
    task_count=$(crontab -l | grep -v "^#" | grep . | wc -l)
    
    if [ "$task_number" -gt 0 ] && [ "$task_number" -le "$task_count" ]; then
        # Create a temporary file with all tasks except the one to be removed
        crontab -l | grep -v "^#" | grep . | awk "NR != $task_number" > /tmp/crontab.tmp
        
        # Update crontab with the modified content
        crontab /tmp/crontab.tmp
        rm /tmp/crontab.tmp
        
        echo
        echo "Task removed successfully!"
    else
        echo
        echo "Invalid task number. No tasks were removed."
    fi
    
    echo
    echo "Press Enter to continue..."
    read -r
}

# Main menu loop
while true; do
    display_header
    echo "MAIN MENU"
    echo "====================================="
    echo "1) Display scheduled tasks"
    echo "2) Add a new task"
    echo "3) Remove a task"
    echo "4) Exit"
    echo
    read -p "Enter your choice (1-4): " choice
    
    case $choice in
        1) display_tasks ;;
        2) add_task ;;
        3) remove_task ;;
        4) 
            echo "Exiting Task Scheduler. Goodbye!"
            exit 0 
            ;;
        *)
            echo "Invalid selection. Please try again."
            sleep 1
            ;;
    esac
done