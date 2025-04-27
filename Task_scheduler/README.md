# Bash Task Scheduler

A lightweight command-line task scheduler for Unix-based systems that provides a user-friendly interface to manage cron jobs without requiring advanced knowledge of crontab syntax.

![Bash Task Scheduler](https://via.placeholder.com/800x400.png?text=Bash+Task+Scheduler)

## Features

- Interactive menu-based interface
- View all currently scheduled tasks
- Add new scheduled tasks with simplified timing options:
  - Hourly execution
  - Daily execution
  - Weekly execution
  - Custom cron expressions for advanced users
- Remove existing tasks easily
- No external dependencies beyond standard Unix utilities

## Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/yourusername/bash-task-scheduler.git
   ```

2. Make the script executable:
   ```bash
   chmod +x task-scheduler.sh
   ```

3. Run the script:
   ```bash
   ./task-scheduler.sh
   ```

## Usage

The script provides a simple menu-driven interface with the following options:

### 1. Display Scheduled Tasks
Shows all currently scheduled tasks with their timing and commands.

### 2. Add a New Task
Guides you through adding a new scheduled task with various timing options:
- **Hourly**: Runs every hour at a random minute
- **Daily**: Runs once per day at a random time
- **Weekly**: Runs once per week on a random day at a random time
- **Custom**: Enter your own cron expression for advanced scheduling

### 3. Remove a Task
Displays all tasks with numbers and allows you to remove a specific task by its number.

### 4. Exit
Exits the Task Scheduler.


## How It Works

The script provides a wrapper around the standard Unix `crontab` utility, making it easier to schedule and manage recurring tasks without needing to remember the crontab syntax. It reads and modifies your user's crontab entries to manage the scheduled tasks.

## Requirements

- Bash shell
- Unix-based operating system (Linux, macOS, etc.)
- Standard Unix utilities: `crontab`, `grep`, `awk`, etc.

## Limitations

- Manages only the current user's crontab
- Does not support environment variables or multi-line commands
- Random scheduling cannot be set to specific preferred times

