 /etc/apt/sources.list - to display all the predefined source for package installing


 File Archiving and Compression

Archives (.zip, .rar, etc.): Single files containing multiple files
Compression: Reduces file size

gzip - File Compression

Compresses individual files with .gz extension
Compress: gzip filename
Decompress: gunzip filename.gz
Limitation: Can't archive multiple files together

tar - File Archiving

Creates archives with .tar extension containing multiple files
Create archive: tar cvf archive.tar file1 file2

c: create
v: verbose (show progress)
f: specify filename


Extract archive: tar xvf archive.tar

x: extract
v: verbose
f: specify filename



tar with gzip - Combined Archiving and Compression

Creates/extracts .tar.gz files in a single step
Create compressed archive: tar czf archive.tar.gz files

z: use gzip compression


Extract compressed archive: tar xzf archive.tar.gz

z: use gzip decompression


Remember: "eXtract all Zee Files"

The "z" option eliminates the need for separate gzip/gunzip commands when working with compressed tar archives.


package dependecy - help other packages to run the package if it crash package wont run properly


Package Management Layers in Debian-based Systems

dpkg (Lower Level)

The basic package manager for Debian-based systems
Handles direct installation, removal, and querying of .deb files
Doesn't automatically resolve dependencies
Commands like dpkg -i package.deb to install


apt (Higher Level)

Built on top of dpkg
The package manager you normally use day-to-day
Automatically handles dependencies
Connects to repositories to download packages
Commands like apt install package or apt update
