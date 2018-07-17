PARMAP
======

Using the wonderful ruby-nmap gem, this script gives you a few options for displaying and outputting the information from an nmap XML file.

Currently in development is version 2. I'm re-writing this from scratch. At the moment this is more like an extension to the ruby-nmap library to make basic parsing tasks more available. The end goal will be a shell that allows interaction with Nmap XML files for parsing and allows the user to run Nmap scripts against subsets of hosts.

The reason behind this is that Nmap has a ton of great scripts to make scanning/testing more effective but finding and running them can be a little arduous. This way you can ask the shell to execute a/several NSE scripts against a set of hosts that have port 80 open. 

Requirements and Installation
------------

    gem install ruby-nmap
    gem install fsdb
    gem install thor
    gem install readline

Current Goals/TODOs
--------------

Status:

### Shell

So far the shell has some partial functionality. It can parse data from a supplied nmap xml file via its `set` funtion. My intent is to extend this to be able to create (use the ruby fsdb gem) a project that you can then import data into. This will let the user import nmap results from multiple files and then parse them. In a future version I want to add the data supplied to these files such as timestamps of each import scan to allow diffing of scan results and data like NSE results to allow parsing of files by service version data (eg. search all host with string Windows 7 in smb version scan results). 

At this point you can do a few things like set your active xml file. List live hosts or have them output to a supplied file name. An example run: 

```
>> set scan.xml
Setting active xml file: scan.xml
scan.xml>> list stdout
stdout
192.168.0.1
192.168.0.103
192.168.0.110
192.168.0.132
192.168.0.135
192.168.0.159
192.168.0.185
192.168.0.189
192.168.0.194
192.168.0.193
scan.xml>> 
```

If you look at the help output below you can tell it doesn't match exactly with the commands. I  will update this as soon as I write a few more functions. I am going to rearrange the help file so that help for each command can be shown with `help COMMAND` format. This is what the help looks like so far: 

$ parmap ishell
```
>> help
Data Setup Tasks:
Before you can scan or parse any data you must either set an active project, create a project
and import data from nmap output (eg. use create import) or set an xml file directly to work with
(eg. set) 
  create NAME      # create a project with name NAME
  import FILE      # import data from FILE into active project
  use PROJ_NAME    # set the current active project to PROJ_NAME
  set FILE         # set FILE as the active file to work with
  cli help [TASK]  # Describe available tasks or one specific task

Parsing and Scanning Tasks:
  list FILE             # list live hosts (this will be based on the scan type); optionally dump results to FILE
  port PORT_NUM FILE    # print output a list of hosts that have PORT open; optionally dump results to FILE
  services out FILE     # generate a list of hosts and their associated open ports and service versions
  qparse                # generate a set of files containing host IPs based on a set of common ports
  scan                  # scan TBD
  help                  # print help text

For help with a specific task append 'help' to the command
>> set help

examples: 
```


### Command Line Tool Interface
Commands:
  parmap help [COMMAND]  # Describe available commands or one specific command
  parmap ishell          # start an interactive shell for parsing data or executing NSE scans
  parmap list NMAP_FILE  # Output a list of live hosts. `parmap help list` for additional options
  parmap port PORT       # List hosts that have a give PORT open
  parmap qparse FILE     # Create a file for each of a set of common ports containing a list of IPs of hosts found having that port open
  parmap services FILE   # Output a list of found services and their enumerated versions by port


### Libraries

The parser needs a function to handle processing NSE scan data. It also needs some cleanup on the services output function. 

The shell needs functions to handle project creation, data import, management etc. 