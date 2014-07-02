parmap
======

Nmap xml file parsing and reporting script



Features

Easy viewing of open ports and services in the terminal
Create CSV to be used in reporting documents
Output lists of hosts based on a port/service specificed at the command line
Parse shares script scan for access to $ADMIN shares
Create a list of live hosts - ping scan (up) or hosts with open ports (open)


``` plain
parmap-0.2 -h
Usage: parmap-0 [options]
    -f, --file <xml file>            The xml file to parse or file containing hosts ip's for scanning
    -s, --stdout                     Print the output of the parsed file to the screen
    -l, --list                       Print a list of live hosts to stdout
    -k, --check                      Print a list of live hosts to stdout based on open ports
    -p, --port <port>               From the given xml create a list of hosts that match a given port. ex: 80 will output all hosts with port 80 open to 80_hosts.txt
    -r, --report <output file>      Output to a CSV suitable for reporting
    -a, --admins                     Parse an smb share scan for local admin rights
    -h, --help                       help
```
