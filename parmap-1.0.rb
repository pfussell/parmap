#!/usr/bin/env ruby

require "nmap/xml"
require "thor"
require 'readline'


# Takes an nmap xml file as an argument
# and parses the results to various formats
class Parsing < Nmap::XML
  LINE_SEPERATOR = "|" + "-" * 114 + "|"

  def initialize(xmlfi)
    @xmlfi = Nmap::XML.open(xmlfi)
    @host_hash = {}
    hosts_hash # just an easy way to look at hosts/ports
  end

  def hosts_hash
    ports_arry = []
    @xmlfi.each_host do |host|
      @host_hash["host.ip"]
      host.each do |port|
        ports_arry << port if port
        @host_hash[host] = ports_arry
      end
    end
  end

  def show_livehosts
    @host_hash.each_key { |key| puts key }
  end

  def up_hst
    @xmlfi.up_hosts { puts host.ip }
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

  def hostList
    printf("| %-16s | %-30s | \n", "-"*16, "-"*30)
    printf("| %-16s | %-30s | \n", " IP ", " HOSTNAME ")
    printf("| %-16s | %-30s | \n", "-"*16, "-"*30)
    @host_hash.each_key do |host|
      printf("| %-16s | %-30s | \n", host.ip, host.hostname)
    end
  end

  def write_out(prt)
    outf = File.open("port_#{prt}.txt", "a+")

    @host_hash.each_key do |host|
      host.each_port do |port|
        outf.write("#{host.ip}\n") if port.to_s == prt # prt needs to be a string
      end
    end
    outf.close
  end

  def report_out(outfi)
    out_file = File.open("#{outfi}", "w")
    @xmlfi.each_host do |host|
      host.each do |port|
        out_file << "#{host.ip},#{port.number},#{port.protocol},#{port.service}, #{port.service.product} #{port.service.version}\n"
      end
    end
  end

  def parse_nse
    @xmlfi.each_host do |host|
      puts "[#{host.ip}]"

      host.scripts.each do |name,output|
        output.each_line { |line| puts "  #{line}" }
      end

      host.each_port do |port|
        puts "  [#{port.number}/#{port.protocol}]"

        port.scripts.each do |name,output|
          puts "    [#{name}]"

          output.each_line { |line| puts "      #{line}" }
        end
      end
    end
  end


end

def interactive

end

# Use thor to manage the command line options
class Parmap < Thor
  # option :file, :required => true
  desc 'parse FILE', 'parse the FILE and output the results to the screen'
  def parse_xml(file)
    parser = Parsing.new(file)
    parser.pretty_print
  end

  desc 'ports FILE PORT', 'create a file with a list of hosts where the port was open'
  def ports(file, prt)
    parser = Parsing.new(file)
    parser.write_out(prt)
  end

  desc 'csv FILE OUTPUT_FILE', 'create a csv of the output from parsing the nmap file'
  def csv(file, outfile)
    parser = Parsing.new(file)
    parser.report_out(outfile)
  end

  desc 'nse FILE', 'parse the NSE script data from an nmap scan'
  def nse(file)
    parser = Parsing.new(file)
    parser.parse_nse
  end

  desc 'hosts FILE', 'print a list of Up hosts in the file'
  def hosts(file)
    parser = Parsing.new(file)
    parser.show_livehosts
  end

  desc 'shell', 'run an interactive shell for reading nmap scan data'
  def ishell(file) 
    while input = Readline.readline("> ", true)
      break if input == "exit"
      
      case input
      when "hosts"
        parser = Parsing.new(file)
        parser.hostList
      when "ports"
        parser = Parsing.new(file)
        parser.pretty_print    
      end
      
      puts Readline::HISTORY.to_a if input == "history"

      # Remove blank lines from history
      Readline::HISTORY.pop if input == ""

      system(input)
    end  
  end

end

Parmap.start(ARGV)

def ishell(file)
  parser = Parser.new(file)
  
  while input = Readline.readline("> ", true)
    break if input == "exit"

    case input
    when "load"
      
    when "hosts"
      parser = Parsing.new(file)
      parser.hostList
    when "ports"
      parser = Parsing.new(file)
      parser.pretty_print
    end

    puts Readline::HISTORY.to_a if input == "history"

    # Remove blank lines from history
    Readline::HISTORY.pop if input == ""

    system(input)
  end
end
