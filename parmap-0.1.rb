#!/usr/bin/env ruby
require 'nmap/xml'
require 'colorize'
require 'rubygems'
require 'optparse'
require 'nmap/program'

# This program is a simple ruby script for performing some common nmap file parsing activities

options = {}

opt_parser = OptionParser.new do |opt|
  opt.on("-f","--file <xml file>","the xml file to parse or file containing hosts ip's for scanning") do |file|
    options[:file] = file
  end
  
  opt.on("-s","--stdout","Print the output of the parsed file to the screen") do |stdout|
    options[:stdout] = stdout
  end
  
  opt.on("-p","--port <port>"," from the given xml create a list of hosts that match a given port. ex: 80 will output all hosts with port 80 open to 80_hosts.txt") do |port|
    options[:port] = port
  end
  
  opt.on("-r","--report <output file>","output to a CSV suitable for reporting") do |report|
    options[:report] = report
  end
  
  opt.on("-a","--admins","Parse an smb share scan for local admin rights") do |admins|
    options[:admins] = admins
  end
  
  opt.on("-l","--list","Print a list of live hosts to stdout") do |list|
    options[:list] = list
  end
  
  opt.on("-h","--help","help") do
    puts opt_parser
  end
end

opt_parser.parse!

$host_hash = {}

class Parsing
  def initialize(xmlfi,trg_port,out_fi)
    @xmlfi = xmlfi
    @trg_port = trg_port
    @out_fi = out_fi
  end

  def create_hash(xmlfi) # I added this in case I wanted to do some more dynamic parsing activites in the future/ not currently used
    ports_arry = Array.new
    Nmap::XML.new(xmlfi) do |xml|
      xml.each_host do |host|
        $host_hash["host.ip"]
        host.each do |port|
          ports_arry << port
          $host_hash["#{host.ip}"] = ports_arry.to_s
        end
      end
    end
  end
  
  def parse_stdout(xmlfi) # Print a readable format out to the screen
    host_array = Array.new
    Nmap::XML.new(xmlfi) do |xml|
      xml.each_host do |host|
        host.each { |port| port ? host_array << host.ip : next }
        if host_array.include?(host.ip)
          printf("|------------------------------------------------------------------------------------------------------------------|\n")
          host.each do |port|
            hst = "#{host.ip}"
            prod = "#{port.service.product.to_s.slice(0..34)} #{port.service.version.to_s.slice(0..24)}" # Took me a while to get this formatting right
            printf("| %-18s | %-6d | %-4s | %-16s | %-56s | \n",hst,port.number,port.protocol.upcase,port.service.to_s.upcase,prod) # The problem is the spacing throws off the alignment
          end
        end
      end
      printf("|------------------------------------------------------------------------------------------------------------------|\n")
    end
  end

  def live_hosts(xmlfi) # This is my lazy version for now; I need to add a test for Ping or No ping to determine how we will test if a host is 'up' or not
    Nmap::XML.new(xmlfi) do |xml|
      xml.each_host do |host|
        puts "#{host.ip}" if host.status.state == :up 
      end
    end
  end
  
  def write_out(xmlfi, prt) # Easy way to create a file with a list of IP's for a given port
    iparry = Array.new
    outf = File.open("port_#{prt}.txt", "a+")

    Nmap::XML.new(xmlfi) do |xml|
      xml.each_host do |host|
        host.each { |port| port.to_s == "#{prt}" ? iparry << host.ip : next } 
      end
      
      iparry.uniq!
      iparry.each {|ip| outf.write("#{ip}\n")}
    end
  end    

  def reporter(xmlfi, outfi)
#    output = ""
    out_file = File.open("#{outfi}", "w")
    Nmap::XML.new(xmlfi) do |xml|
      xml.each_host do |host|
        host.each do |port|
          out_file << "#{host.ip},#{port.number},#{port.protocol},#{port.service}, #{port.service.product} #{port.service.version}\n"
        end
      end
    end
  end


  def lcl_admin(xmlfi)

    Nmap::XML.new(xmlfi) do |xml|
      xml.each_host do |host|

        host.scripts.each do |name,output|
          count = 0

          output.each_line do |line|
            break if count == 2
            
            line.index(/[^ ]/).to_i == 2 ? count += 1 : count += 0

            if line.include?("ADMIN$")  || line.include?("C$")  || line.include?("D$")  || line.include?("E$")
              line1 = line
            elsif line.include?("Current user") && line.include?("READ/WRITE") 
              line2 = line
            else
              next
            end

            puts host.ip if "#{line1} #{line2}".size > 10
            
          end
        end
      end
    end
  end
      
  
end
# result.create_hash(options[:file]) -- this could be used to create a hash of host => arry of ports ( for script scanning)
result = Parsing.new(options[:file],options[:port],"out.csv")

case
when options[:stdout]
  result.parse_stdout(options[:file])
when options[:port]
  result.write_out(options[:file], options[:port].to_i)
when options[:report]
  result.reporter(options[:file], options[:report])
when options[:list]
  result.live_hosts(options[:file])
when options[:admins]
  result.lcl_admin(options[:file])
when options[:disc]
  result.find_live_hosts(options[:file])
else
  puts "please select an option"
  puts opt_parser
end
