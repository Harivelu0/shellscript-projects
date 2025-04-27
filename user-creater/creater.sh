#!/bin/bash

# userctr.sh - User Control Script for Classroom Environment
# This script automates the creation and deletion of teacher and student accounts

# Function to display usage information
usage() {
    echo "Usage: $0 add|del teacher_username student_prefix student_count"
    echo "       $0 delsingle username"
    echo "Example: $0 add teacher stu 6"
    echo "         $0 del teacher stu 6"
    echo "         $0 delsingle stu3"
    exit 1
}

# Function to generate a random password
generate_password() {
    # Generate a 6-digit random number
    echo $((100000 + RANDOM % 900000))
}

# Function to add a user
add_user() {
    local username=$1
    local password=$(generate_password)
    local is_teacher=$2
    
    # Create the user
    useradd -m -s /bin/bash "$username"
    
    # Set the password
    echo "$username:$password" | chpasswd
    
    # If this is a teacher, add to sudo group
    if [ "$is_teacher" = true ]; then
        usermod -aG sudo "$username"
    fi
    
    # Output the username and password
    echo "$username:$password"
}

# Function to delete a user
delete_user() {
    local username=$1
    
    # Delete the user and their home directory
    userdel -r "$username" 2>/dev/null
    
    # Provide feedback that the user was deleted
    if [ $? -eq 0 ]; then
        echo "User $username has been deleted."
    else
        echo "User $username does not exist or could not be deleted."
    fi
}

# Main script execution
# Check if the script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root" >&2
    exit 1
fi

# Check if at least one argument is provided
if [ $# -lt 1 ]; then
    usage
fi

action=$1

# Handle the delsingle action
if [ "$action" = "delsingle" ]; then
    if [ $# -ne 2 ]; then
        echo "Error: 'delsingle' action requires a username."
        usage
    fi
    username=$2
    delete_user "$username"
    exit 0
fi

# For add and del actions, check if correct number of arguments
if [ $# -ne 4 ]; then
    usage
fi

teacher_username=$2
student_prefix=$3
student_count=$4

# Validate the action
if [ "$action" != "add" ] && [ "$action" != "del" ]; then
    echo "Invalid action: $action. Use 'add', 'del', or 'delsingle'."
    usage
fi

# Validate student count is a number
if ! [[ "$student_count" =~ ^[0-9]+$ ]]; then
    echo "Student count must be a number."
    usage
fi

# Perform the requested action
if [ "$action" = "add" ]; then
    # Create teacher account
    add_user "$teacher_username" true
    
    # Create student accounts
    for i in $(seq 1 "$student_count"); do
        add_user "${student_prefix}${i}" false
    done
else
    # Delete teacher account
    delete_user "$teacher_username"
    
    # Delete student accounts
    for i in $(seq 1 "$student_count"); do
        delete_user "${student_prefix}${i}"
    done
fi

exit 0