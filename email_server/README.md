# Postfix Mail Server Setup

This repository contains instructions for setting up and configuring a Postfix mail server on Linux.

## Overview

Every day, we receive numerous emails but often remain unaware of the underlying mechanics of how emails are sent and received. This guide provides hands-on experience to understand the workings of a mail server and configure one yourself.

## What You'll Learn

- How to install and configure the Postfix mail server
- How to edit Postfix configuration files
- How to create a local user and set up email address mapping for routing emails
- How to send a test email and check its delivery

## Prerequisites

- A Linux environment (Ubuntu/Debian recommended)
- Root/sudo access
- Basic command line knowledge

## Key Components Explained

Before diving into installation, let's understand the main components of a Postfix mail server:

### 1. Postfix Configuration Files

- **main.cf**: The primary configuration file for Postfix. It contains settings that control how your mail server operates, including:
  - Domain names and hostnames
  - Network interfaces to listen on
  - Mail delivery destinations
  - Security settings
  - Mail routing rules

- **master.cf**: Controls the Postfix services and processes. It defines which services run and how they interact.

### 2. Virtual Aliases and Mapping

- **Virtual Aliases**: Allow you to create email addresses that don't correspond to actual system users. For example, routing emails for info@example.com to a specific user account.

- **Postmap Command**: Creates indexed lookup tables from text files. When you run `postmap /etc/postfix/virtual`, it converts your plain text mapping file into an indexed database that Postfix can search efficiently.

### 3. Mail Delivery Process

When an email arrives at your server:
1. Postfix receives the message
2. Checks the recipient address
3. Consults mapping tables to determine where to deliver
4. Delivers to the appropriate mailbox or forwards as needed

### 4. Mail Storage

- Local mail is typically stored in the `/var/mail/` directory with each user having their own mailbox file
- Users access this mail using command-line tools like `mail` or email clients

## Installation and Configuration Steps

### Step 1: Install Postfix and Required Utilities

```bash
sudo apt update
sudo apt install postfix mailutils -y
```

During installation, select "Internet Site" and enter your domain name when prompted.

### Step 2: Configure Postfix

Edit the main Postfix configuration file:

```bash
sudo vim /etc/postfix/main.cf
```

Key settings to configure:

```
# Basic Settings
myhostname = mail.example.com
mydomain = example.com
myorigin = $mydomain
inet_interfaces = all
mydestination = $myhostname, localhost.$mydomain, localhost, $mydomain, your-hostname

# Additional settings
mailbox_size_limit = 51200000
```

**What these settings mean:**

- `myhostname`: The fully-qualified domain name of your mail server (e.g., mail.example.com)
- `mydomain`: Your domain name without the hostname (e.g., example.com)
- `myorigin`: The domain that appears in outgoing mail (usually your domain name)
- `inet_interfaces`: Network interfaces Postfix listens on (`all` means listen on all interfaces)
- `mydestination`: Domains for which this server will deliver mail locally instead of forwarding
- `mailbox_size_limit`: Maximum size of a user's mailbox in bytes

Save and exit the editor.

### Step 3: Create a Local User for Email Testing

```bash
sudo adduser testuser
```

Follow the prompts to set a password and user information.

### Step 4: Set Up Email Address Mapping

Create a virtual alias file:

```bash
sudo vim /etc/postfix/virtual
```

Add mappings to route emails to local users:

```
info@example.com testuser
support@example.com testuser
```

**What this does:**
This creates "virtual" email addresses that don't correspond to actual system users. When someone sends an email to info@example.com, the system will deliver it to the mailbox of the "testuser" account instead.

Create a database file from the virtual map:

```bash
sudo postmap /etc/postfix/virtual
```

**Why we need postmap:**
The `postmap` command converts the plain text virtual file into an indexed database format (hash) that Postfix can search quickly and efficiently. Every time you modify the virtual file, you need to run postmap to update the database.

Update the main.cf file to include this mapping:

```bash
sudo vim /etc/postfix/main.cf
```

Add these lines:

```
virtual_alias_domains = 
virtual_alias_maps = hash:/etc/postfix/virtual
```

**What these settings mean:**
- `virtual_alias_maps`: Tells Postfix where to look for virtual alias mappings
- `hash:/etc/postfix/virtual`: Specifies that we're using a hash database created from the /etc/postfix/virtual file
- `virtual_alias_domains`: Specifies domains for which this server accepts mail via virtual aliases (left empty here to use the default domains)

### Step 5: Restart Postfix

Apply all changes:

```bash
sudo systemctl restart postfix
```

### Step 6: Send Test Emails

Send a test email to verify your configuration:

```bash
echo "This is a test email" | mail -s "Test Email" testuser@localhost
```

### Step 7: Check Email Delivery

Check if the test user received the email:

```bash
su - testuser
mail
```

Type the number of the email to read it, then `q` to exit. You should see output similar to this:

```
testuser@LAPTOP-IRJDO1DT:~$ mail
"/var/mail/testuser": 2 messages 2 new
>N   1 hari@LAPTOP-IRJDO1 Sat Apr 26 16:29  14/446   Virtual Test
 N   2 hari@LAPTOP-IRJDO1 Sat Apr 26 16:29  14/432   Local Test
```

This shows that your mail server is working correctly, with 2 received emails!

## Troubleshooting Tips

If you encounter issues:

1. Check log files: `sudo tail -f /var/log/mail.log`
2. Verify Postfix is running: `sudo systemctl status postfix`
3. Ensure mail directory exists: `sudo mkdir -p /var/mail`
4. Check permissions: `sudo chmod 1777 /var/mail`
5. Update aliases database: `sudo newaliases`
6. Check for syntax errors: `sudo postfix check`

## How Email Flows Through Postfix

To better understand what we've set up, let's follow an email's journey through your Postfix server:

1. **Receiving an Email** (e.g., to info@example.com):
   - Someone sends an email to info@example.com
   - The email arrives at your server on port 25 (SMTP)
   - Postfix's smtpd service accepts the message

2. **Processing the Email**:
   - Postfix checks the recipient address (info@example.com)
   - Looks up this address in virtual_alias_maps
   - Finds that it should be delivered to the local user "testuser"

3. **Delivering the Email**:
   - Postfix routes the message to the local delivery agent
   - The message is stored in /var/mail/testuser
   - The user can now read this message using the "mail" command

4. **Sending an Email** (from your server):
   - A user on your system sends an email
   - Postfix processes the outgoing message
   - Adds domain information based on your myorigin setting
   - Delivers it to the appropriate destination

## Implementation Experience

During the implementation of this mail server project, I gained practical experience with:

1. **Package Installation and Management**
   - Installing and configuring Postfix and mail utilities
   - Resolving package dependency issues

2. **Configuration File Editing**
   - Using vim/nano to edit system configuration files
   - Understanding key mail server parameters

3. **System Services Management**
   - Starting, stopping, and restarting system services
   - Monitoring service status and logs

4. **Mail Routing Configuration**
   - Setting up virtual email mapping
   - Configuring local mail delivery

5. **Troubleshooting Skills**
   - Analyzing log files for error messages
   - Resolving configuration issues
   - Testing and verifying mail delivery

6. **User and Permission Management**
   - Creating system users for mail testing
   - Setting appropriate file permissions

The process involved several challenges, including resolving initial configuration errors related to the `mydomain` parameter and ensuring proper local mail delivery. Through systematic troubleshooting and configuration adjustments, I successfully implemented a functioning mail server that can handle local mail delivery.

## Conclusion

Setting up a Postfix mail server provides valuable insights into how email systems work. This project demonstrates the core concepts of mail server configuration and management, giving you a foundation to build upon for more advanced email setups.
