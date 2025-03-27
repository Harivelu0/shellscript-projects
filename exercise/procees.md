# Linux Process Management: A Beginner's Guide

## 1. What Are Processes?

Processes are programs that are running on your system. Each process:
- Is managed by the Linux kernel
- Has a unique Process ID (PID) assigned in the order processes are created
- Requires CPU, memory, and other resources to run

The `ps` command shows running processes:

```bash
$ ps
PID     TTY     STAT   TIME     CMD
41230   pts/4   Ss     00:00:00 bash
51224   pts/4   R+     00:00:00 ps
```

For more detailed information, use `ps aux`:

```bash
$ ps aux
```

This shows:
- USER: Who owns the process
- PID: Process ID
- %CPU/%MEM: Resource usage
- TTY: Terminal associated with the process
- STAT: Process status
- START: When the process started
- TIME: CPU time used
- COMMAND: The command being run

To see processes in real-time rather than a snapshot, use:

```bash
$ top
```

## 2. Terminal Types and Process Association

There are two terminal types in Linux:

1. **Regular Terminal Devices (TTY)**: Native terminal devices accessed with Ctrl+Alt+F1 through F6
2. **Pseudoterminal Devices (PTS)**: Terminal windows in your graphical environment

Most processes are connected to a controlling terminal. If you close the terminal, the process terminates.

Daemon processes (system services) don't have a controlling terminal. In `ps` output, they show `?` in the TTY column.

## 3. Process Creation and Parent-Child Relationships

Every process in Linux (except the very first one) is created when an existing process clones itself using the `fork` system call:

- The original process becomes the "parent"
- The new copy becomes the "child"
- The child gets a new PID
- The parent's PID becomes the child's PPID (Parent PID)

The parent-child concept helps with:
- Organizing the system
- Resource inheritance
- Process control
- Clean termination
- Security boundaries

The very first process, `init` (PID 1), is created by the kernel during boot and becomes the ancestor of all other processes.

View process relationships with:

```bash
$ ps l
```

The PPID column shows each process's parent.

## 4. Process Termination

Processes can terminate in several ways:

1. **Normal Exit**: Using the `_exit` system call with a termination status (0 typically means success)
2. **Signal Termination**: When a process receives certain signals

The parent must acknowledge a child's termination using the `wait` system call.

Special cases:
- **Orphan Processes**: If a parent dies before its children, the children are adopted by the `init` process
- **Zombie Processes**: Terminated processes whose parents haven't called `wait` yet. They've freed resources but still have entries in the process table.

## 5. Signals

Signals are notifications sent to processes. They're used for:
- User control (Ctrl+C, Ctrl+Z)
- System notifications
- Inter-process communication

Common signals include:
- **SIGHUP (1)**: Hangup, sent when terminal is closed
- **SIGINT (2)**: Interrupt, sent by Ctrl+C
- **SIGKILL (9)**: Force kill, cannot be blocked
- **SIGSEGV (11)**: Segmentation fault
- **SIGTERM (15)**: Termination request
- **SIGSTOP**: Stop/suspend a process

## 6. Killing Processes

The `kill` command sends signals to processes:

```bash
$ kill 12445        # Sends SIGTERM (default)
$ kill -9 12445     # Sends SIGKILL (force terminate)
```

Signal differences:
- **SIGHUP**: Terminal closed, can be used to reload configurations
- **SIGINT**: Interrupt (Ctrl+C), allows graceful termination
- **SIGTERM**: Default kill signal, allows cleanup
- **SIGKILL**: Force kill, no cleanup possible
- **SIGSTOP**: Pause process execution

Best practice: Try SIGTERM first, only use SIGKILL if the process doesn't respond.

## 7. Process Priority with Niceness

Linux manages multiple processes by giving each small time slices of CPU. "Niceness" controls process priority:

- Scale: -20 to 19
- **Lower values**: Higher priority (less nice)
- **Higher values**: Lower priority (more nice)

View niceness with:
```bash
$ top      # Check the "NI" column
```

Set priority for new processes:
```bash
$ nice -n 5 command     # Run with lower priority
```

Change priority for running processes:
```bash
$ renice 10 -p 3245     # Make PID 3245 lower priority
$ sudo renice -10 -p 3245  # Make PID 3245 higher priority (needs root)
```

Examples:
- Run CPU-intensive backups with high niceness (lower priority)
- Run interactive applications with low niceness (higher priority)

## 8. Process States

The STAT column in `ps aux` shows process states:

- **R**: Running or runnable
- **S**: Interruptible sleep (waiting for event)
- **D**: Uninterruptible sleep (cannot be interrupted)
- **Z**: Zombie (terminated but not reaped)
- **T**: Stopped (suspended)

## 9. The /proc Filesystem

Linux represents processes as files in the `/proc` directory:

```bash
$ ls /proc
```

Each PID has its own directory with detailed information:

```bash
$ cat /proc/12345/status
```

This provides much more information about processes than `ps`.

## 10. Job Control

Job control lets you manage multiple processes in a single terminal:

1. **Running Jobs in Background**:
```bash
$ sleep 1000 &
```

2. **Viewing Background Jobs**:
```bash
$ jobs
```

3. **Moving Running Job to Background**:
```bash
$ sleep 1000
[Ctrl+Z]  # Suspend the job
$ bg       # Continue it in background
```

4. **Bringing Background Job to Foreground**:
```bash
$ fg %1    # Bring job #1 to foreground
$ fg       # Bring most recent job to foreground
```

5. **Killing Background Jobs**:
```bash
$ kill %1  # Kill job #1
```

Job control is useful when:
- Working with a single terminal
- Running long processes
- Multitasking in terminal environments
- Working on remote servers

## Summary

Processes in Linux follow a parent-child model, with each process having its own PID. They can be controlled through signals, prioritized with niceness values, and managed with job control. Understanding these concepts helps you effectively manage your Linux system resources.