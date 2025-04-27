
# Classroom User Management Script

A bash script for efficiently managing user accounts in a classroom server environment.

## Overview

`creater.sh` is a command-line utility that automates the creation and deletion of user accounts for teachers and students. It's designed for educational environments where administrators need to quickly set up and tear down class accounts.

## Features

- Create teacher accounts with sudo privileges
- Create multiple student accounts with sequential numbering
- Generate random secure passwords for each new account
- Delete individual users or groups of users
- Simple command-line interface

## Requirements

- Linux environment
- Root/sudo privileges
- Bash shell

## Installation

1. Clone this repository or download the script:
```bash
git clone https://github.com/yourusername/classroom-user-management.git
```

2. Make the script executable:
```bash
chmod +x creater.sh
```

## Usage

### Adding Users

To add a teacher and multiple students:
```bash
sudo ./creater.sh add teacher_username student_prefix student_count
```

Example:
```bash
sudo ./creater.sh add teacher stu 6
```
This creates:
- One teacher account named "teacher" with sudo privileges
- Six student accounts named "stu1" through "stu6"
- Random 6-digit passwords for each account

Output example:
```
teacher:617533
stu1:345893
stu2:183263
stu3:404525
stu4:571165
stu5:251940
stu6:716130
```

### Deleting Users

To delete a teacher and multiple students:
```bash
sudo ./creater.sh del teacher_username student_prefix student_count
```

Example:
```bash
sudo ./creater.sh del teacher stu 6
```

### Deleting a Specific User

To delete a single user:
```bash
sudo ./creater.sh delsingle username
```

Example:
```bash
sudo ./creater.sh delsingle stu3
```

## How It Works

The script:
1. Validates input parameters
2. Creates or deletes accounts based on the specified action
3. Sets appropriate permissions (sudo for teachers)
4. Generates and displays random passwords when creating accounts

## Security Considerations

- Always run this script with sudo/root privileges
- Save the generated passwords securely after account creation
- Consider implementing password rotation for long-term deployments



