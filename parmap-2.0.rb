require 'nmap/xml'


class ParseScan < Nmap::XML
  LINE_SEPERATOR = "|" + "-" * 114 + "|"
  EMPTY = " " * 42 + "|"
  
  def initialize(xmlfi)
    @xmlfi = Nmap::XML.open(xmlfi) 
  end

  ## PARSING METHODS
  
  # get a list of live hosts based on up status(ie. ping) 
  # return the array of 'host' objects
  def parse_up_hosts
    @xmlfi.up_hosts
  end

  # get a list of live hosts based on the presence of open ports
  # return the array of 'host' objects where the host has at least
  # one open port
  def parse_live_hosts
    has_ports = []
    @xmlfi.each_host do |host|
      host.each_open_port { |port| has_ports << host }
    end
    return has_ports.uniq
  end

  # get an array of host objects that have a given
  # port open 
  def hosts_with_port(check_port)
    has_port = []
    @xmlfi.each_host do |host|
      host.each_open_port do |port|
        has_port << host if port.to_i == check_port
      end
    end
    return has_port
  end


  ## OUTPUT METHODS

  # test scan type and print live hosts accordingly
  # if scan inlcudes a 'noping' rule we will only output
  # hosts with open ports (see 'parse_live_hosts')
  # TODO: out_type to select stdout or File for output 
  def live_hosts_to_stdout(host_type = :ip, out_type = :std)
    if host_type == :ip
      if @xmlfi.scanner["arguments"].include?("-Pn")
        parse_live_hosts.each {|host| puts host.ip}
      else
        parse_up_hosts.each {|host| puts host.ip}
      end
    # if we want to print by name we need to check
    # if the host has a name otherwise still do by IP
    elsif host_type == :name
      if @xmlfi.scanner["arguments"].include?("-Pn")
        parse_live_hosts.each do |host|
          if host.hostname
            puts host.hostname
          else
            puts host.ip
          end
        end
      else
        parse_up_hosts.each do |host|
          if host.hostname
            puts host.hostname
          else
            puts host.ip
          end
        end
      end
    end
  end

  # print all hosts with given port
  def output_by_port(selected_port)
    hosts_with_port(selected_port).each { |host| puts host.ip }
  end

  # quick parse method of ports
  # create output files with list of IPs for some
  # common ports
  def quick_parse_by_port
    # http
    # ssh
    # ftp
    # smtp
    # smb/netbios
    # nfs
    # sql
    # nosql (redis,mongo)
  end

  # this needs some serious work
  # need to detect if we have just service OR version scan and print
  # accordingly
  # and need to fix the formatting
  # maybe give more printing options in final product (this is org table for now) 
  def pretty_service_output
    @xmlfi.each_host do |host|
      puts LINE_SEPERATOR
      host.each do |port|
        unless port.service.product
          printf("| %-18s | %-6d | %-4s | %-44s \n", host.ip, port.number, port.protocol.upcase, EMPTY)
        else
          prod = "#{port.service.product.to_s.slice(0..24)} #{port.service.version.to_s.slice(0..24)}"
          printf("| %-18s | %-6d | %-4s | %-28s | %-44s | \n", host.ip, port.number, port.protocol.upcase,
                 port.service.to_s.upcase, prod)
        end
      end
    end
    puts LINE_SEPERATOR
  end
  

end

#puts ARGV[0]
#test = ParseScan.new(ARGV[0])
#test.live_hosts_to_stdout
