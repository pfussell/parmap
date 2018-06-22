PARMAP
======

Using the wonderful ruby-nmap gem, this script gives you a few options for displaying and outputting the information from an nmap XML file.

Currently in development is version 2. I'm re-writing this from scratch. At the moment this is more like an extension to the ruby-nmap library to make basic parsing tasks more available. The end goal will be a shell that allows interaction with Nmap XML files for parsing and allows the user to run Nmap scripts against subsets of hosts.

The reason behind this is that Nmap has a ton of great scripts to make scanning/testing more effective but finding and running them can be a little arduous. This way you can ask the shell to execute a/several NSE scripts against a set of hosts that have port 80 open. 

Requirements and Installation
------------

    gem install ruby-nmap

Current Goals/TODOs
--------------

Status:
The shell frame is in place. Probably need to write a class to better handle state and variables.  
The command line method does not exsist yet. Need to start that. I think I'd like to use Thor for this.  
Need to fix the pretty_service_output method (see issues).


###Write Shell

The shell will provide 3 main functions. 1) Basic reading a parsing of the an Nmap XML file. Do things like list hosts and output by open ports. 2) Make NSE scanning much easier. Nmap has a ton of useful scripts but many often get overlooked. The shell will allow you to select a group of hosts (based on port?) and execute an NSE script against them. 3) Provide a way to read/interact with scan data in a useful way. For instance, compare live hosts found from 2 different scans. Output a list of hosts that have a particular value in an NSE scan (eg. hosts running Window 7).

I've gone back and forth on how to handle this. I think the best approach for the long term is to base the data the shell will work with on a project file. The user would navigate to a directory where the Nmap files are stored and 'create PROJECT_NAME' as a first step. Then the XML file(s) can be imported. The project file will be a list of hosts by IP with some set of attributes that allow for sorting/comparison etc. 


example:
```
> create 'project'
> import 'file.xml'
> port 445
> port set 445
(active:port 445)> scan smb-enum-users
> set 'file.txt'
(active:file.txt)> scan script.nse

```


###Write Command Line Tool

The intention for the command line tool is to provide all basic parsing functions.

```
parmap show 'file.xml'                      -- pretty print of ports and serivces
parmap quick 'file.xml'                     -- create output files for set of common ports (eg. port_445.txt)
parmap port PORT                            -- print hosts with port open to stdout
parmap port PORT out 'out.txt'              -- print hosts with port open to 'out.txt'
parmap up 'file.xml'                        -- print hosts in Up state to stdout (there is some logic for detecting state bulit in) 
parmap up 'file.xml out 'out.txt'           -- print hosts in Up state to 'out.txt'
parmap shell                                -- launch shell 
```