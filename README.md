PARMAP
======

Yet another Nmap xml file parsing and reporting script in ruby.
Using the wonderful ruby-nmap gem this script gives you a few options for displaying and outputting the information from an nmap XML file.

Requirements and Installation
------------

    gem install ruby-nmap

Once you clone the repo or download the file you can just link it to your /usr/local/bin

    ln -s /path/to/download/file.rb /usr/local/bin/

Usage and Features
-------

    parmap COMMAND NMAP_XML_FILE

Commands:
  parmap csv FILE OUTPUT_FILE  # create a csv of the output from parsing the nmap file
  parmap help [COMMAND]        # Describe available commands or one specific command
  parmap hosts FILE            # print a list of Up hosts in the file
  parmap nse FILE              # parse the NSE script data from an nmap scan
  parmap parse FILE            # parse the FILE and output the results to the screen
  parmap ports FILE PORT       # create a file with a list of hosts where the port was open

TODO
----

1. Add ability to run commonly used NSE scans against an IP set.
2. Add ability to run scans against a set of IP's based on a condition.
