PARMAP
======

Using the wonderful ruby-nmap gem, this script gives you a few options for displaying and outputting the information from an nmap XML file.

Currently in development is version 2. I'm re-writing this from scratch. At the moment this is more like an extension to the ruby-nmap library to make basic parsing tasks more available. The end goal will be a shell that allows interaction with Nmap XML files for parsing and allows the user to run Nmap scripts against subsets of hosts.

The reason behind this is that Nmap has a ton of great scripts to make scanning/testing more effective but finding and running them can be a little arduous. This way you can ask the shell to execute a/several NSE scripts against a set of hosts that have port 80 open. 

Requirements and Installation
------------

    gem install ruby-nmap

