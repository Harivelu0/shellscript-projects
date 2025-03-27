htop. It's like a dashboard that gives you a real-time view of what's happening inside your computer.
htop shows:
Top: CPU and memory usage, as well as how long your computer has been running (uptime).
Middle: A list of all the running programs (processes).
Bottom: Options for interacting with htop.



Sometimes typing commands can get really repetitive, or if you need to type a long command many times, it’s best to have an alias you can use for that. To create an alias for a command you simply specify an alias name and set it to the command.

$ alias foobar='ls -la'
Now instead of typing ls -la, you can type foobar and it will execute that command, pretty neat stuff. Keep in mind that this command won't save your alias after reboot, so you'll need to add a permanent alias in:

~/.bashrc
or similar files if you want to have it persist after reboot.

You can remove aliases with the unalias command:

$ unalias foobar


/etc/passwd
This file contains basic user account information:

etc/shadow
This file stores encrypted user passwords and password policy information:

/etc/group
This file defines the groups on the system:

useradd
This is a low-level utility for adding users:

adduser
This is a more user-friendly wrapper around useradd:

umask
Think of umask as a template for new files and folders. It's like a "permission filter" that determines what permissions new files get when you create them.

umask works by subtracting permissions from the maximum possible
Common value: 022 (meaning new files get 644/rw-r--r--)
Check your umask by typing umask in the terminal
Higher umask numbers = more restrictive permissions

SETUID (Set User ID)
Imagine borrowing someone's ID card temporarily. SETUID lets a program run as if it were started by the file's owner, not you.

Appears as an 's' in the owner's execute position: -rwsr-xr-x
Example: The passwd command runs as root (so you can update password files)
Set with: chmod u+s filename or chmod 4755 filename
Useful but can be dangerous if misused

SETGID (Set Group ID)
Similar to SETUID, but for groups. Programs run with the permissions of the file's group.

Appears as an 's' in the group's execute position: -rwxr-sr-x
On directories: new files inside inherit the directory's group
Set with: chmod g+s filename or chmod 2755 filename
Great for team collaboration folders

Process Permissions
When you start a program, it runs with your permissions (usually). This means:

A process can only access files you can access
SETUID/SETGID can change this behavior
Processes inherit permissions from the parent process
Root processes (UID 0) can do almost anything

Sticky Bit
The sticky bit is like a "no delete" sign for shared directories.

Appears as a 't' in the "others" execute position: drwxrwxrwt
Only the owner of a file can delete it (even in writable directories)
Common example: /tmp directory
Set with: chmod +t directory or chmod 1777 directory



The commands `ps`, `ps -ef`, `ps aux`, and `top` are all used in Linux to monitor running processes, but they display information in different ways. Let's break down each command:


### **Key Differences Summary**
| Command   | Scope | Format | Updates Continuously | Extra Features |
|-----------|-------|--------|----------------------|----------------|
| `ps`      | Current session only | Simple | ❌ No | Basic info |
| `ps -ef`  | All processes | Full format | ❌ No | Shows PPID, UID |
| `ps aux`  | All processes | BSD format | ❌ No | Shows CPU & memory usage |
| `top`     | All processes | Dynamic | ✅ Yes | Interactive monitoring |

Let me know if you need more details! 🚀