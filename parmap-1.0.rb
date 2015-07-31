
# !/usr/bin/env ruby
require 'nmap/xml'
require 'colorize'
require 'nmap/program'
require 'thor'

# Takes an nmap xml file as an argument
# and parses the results to various formats
class Parsing < Nmap::XML
  LINE_SEPERATOR = '|' + '-' * 114 + '|'

  def initialize(xmlfi)
    @xmlfi = Nmap::XML.open(xmlfi)
    @host_hash = {}
    hosts_hash # just an easy way to look at hosts/ports
  end

  def hosts_hash
    ports_arry = []
    @xmlfi.each_host do |host|
      @host_hash['host.ip']
      host.each do |port|
        ports_arry << port if port
        @host_hash[host] = ports_arry
      end
    end
  end

  def pretty_print
    @host_hash.each_key do |host|
      puts LINE_SEPERATOR
      host.each do |port|
        prod = "#{port.service.product.to_s.slice(0..34)} #{port.service.version.to_s.slice(0..24)}"
        printf("| %-18s | %-6d | %-4s | %-16s | %-56s | \n", host.ip, port.number, port.protocol.upcase, port.service.to_s.upcase, prod)
      end
    end
    puts LINE_SEPERATOR
  end

  def write_out(prt)
    outf = File.open("port_#{prt}.txt", 'a+')

    @host_hash.each_host do |host|
      host.each_port do |port|
        outf.write("#{host.ip}") if port.to_s == prt # prt needs to be a string
      end
    end
    outf.close
  end

  def report_out(outfi)
    out_file = File.open("#{outfi}", 'w')
    @xmlfi.each_host do |host|
      host.each do |port|
        out_file << "#{host.ip},#{port.number},#{port.protocol},#{port.service}, #{port.service.product} #{port.service.version}\n"
      end
    end
  end
end

# Use thor to manage the command line options
class Parmap < Thor
  option :file, :required => true
  desc 'parse FILE', 'parse the FILE and output the results to the screen'
  def parse_xml(file)
    parser = Parsing.new(file)
    parser.pretty_print
  end

  option :file, :required => true
  option :port
  desc 'ports FILE PORT', 'given a port number create a file with a list of hosts that have that port open'
  def ports(prt)
    parser = Parsing.new(file)
    write_out(prt)
  end

  option :file, :required => true
  option :outfile, :required => true
  desc 'csv FILE', 'create a csv of the output from parsing the nmap file'
  def csv
    parser = Parsing.new(file)
    report_out(outfile)
  end
end

Parmap.start
