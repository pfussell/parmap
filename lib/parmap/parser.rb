require 'nmap/xml' #remove me please

module Parmap
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
    # because of the way ruby these objects you will
    # likely have duplicates if you check multiple ports
    def hosts_with_port(*check_port)
      has_port = []
      check_port.each do |targ_port|
        @xmlfi.each_host do |host|
          host.each_open_port do |port|
            has_port << host if port.to_i == targ_port
          end
        end
      end
      has_port
    end


    # need a method for parsing NSE data

    ## OUTPUT METHODS

    # need a method for printing NSE output

    # test scan type and print live hosts accordingly
    # if scan inlcudes a 'noping' rule we will only output
    # hosts with open ports (see 'parse_live_hosts')
    # TODO: out_type to select stdout or File for output
    def live_hosts_to_stdout(host_type = :ip)
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

    def live_hosts_to_file(host_type = :ip, filename)
      if host_type == :ip
        if @xmlfi.scanner["arguments"].include?("-Pn")
          File.open("#{filename}", 'w') do |f|
            parse_live_hosts.each { |host| f << "#{host.ip}\n" }
          end
        else
          File.open("#{filename}", 'w') do |f|            
            parse_up_hosts.each { |host| f << "#{host.ip}\n" }
          end
        end
      # if we want to print by name we need to check
      # if the host has a name otherwise still do by IP
      elsif host_type == :name
        host_ary = []
        if @xmlfi.scanner["arguments"].include?("-Pn")
          parse_live_hosts.each do |host|
            if host.hostname
              host_ary.push(host.hostname)
            else
              host_ary.push(host.ip)
            end
          end
        else
          parse_up_hosts.each do |host|
            if host.hostname
              host_ary.push(host.hostname)
            else
              host_ary.push(host.ip)
            end
          end
        end
        File.open("#{filename}", 'w') do |f|
          host_ary.each { |host| f.puts("#{host}\n") }
        end
      end
    end
    
    # print all hosts with given port
    # first arugment has to be :std OR :file depending on what you want to do
    # with the output
    # the second argument is an array (can be many numbers) of ports to test for
    def output_by_port(out_type = :std, *selected_port)
      hosts_array = []
      selected_port.each do |target_port|
        hosts_with_port(target_port).each { |host| hosts_array << host.ip.to_s }
      end

      if out_type == :std
        puts hosts_array.uniq
      elsif out_type == :file
        return hosts_array.uniq
      else
        puts "No valid output type selected."
      end

    end

    # quick parse method of ports
    # create output files with list of IPs for some
    # common ports
    def quick_parse_by_port
      # http (80,443, 8080)
      http_f = File.open('hosts_http.txt', 'w')
      output_by_port(:file, 80, 443, 8080).each { |final_host| http_f << "#{final_host}\n" }

      # ssh (22)
      ssh_f = File.open('hosts_ssh.txt' 'w')
      output_by_port(:file, 22).each { |final_host| ssh_f << "#{final_host}\n" }

      # telnet (23)
      telnet_f = File.open('hosts_telnet.txt' 'w')
      output_by_port(:file, 111, 2049).each { |final_host| ssh_f << "#{final_host}\n" }

      # ftp (21)
      ftp_f = File.open('hosts_ftp.txt' 'w')
      output_by_port(:file, 21).each { |final_host| ftp_f << "#{final_host}\n" }

      # smtp (25, 465, 587)
      smtp_f = File.open('hosts_smtp.txt' 'w')
      output_by_port(:file, 25, 465, 587).each { |final_host| ssh_f << "#{final_host}\n" }

      # smb/netbios (445, 139)
      smb_f = File.open('hosts_smb.txt', 'w')
      output_by_port(:file, 445).each { |final_host| smb_f << "#{final_host}\n" }

      nbns_f = File.open('hosts_nbns.txt', 'w')
      output_by_port(:file, 139).each { |final_host| nbns_f << "#{final_host}\n" }

      # nfs (111, 2049)
      nfs_f = File.open('hosts_nfs.txt', 'w')
      output_by_port(:file, 111, 2049).each { |final_host| nfs_f << "#{final_host}\n" }

      # sql (1433, 3306, 5432, 1521)
      mssql_f = File.open('hosts_mssql.txt', 'w')
      output_by_port(:file, 1433).each { |final_host| mssql_f << "#{final_host}\n" }
      mysql_f = File.open('hosts_mysql.txt', 'w')
      output_by_port(:file, 3306).each { |final_host| mysql_f << "#{final_host}\n" }
      pgsql_f = File.open('hosts_pgsql.txt', 'w')
      output_by_port(:file, 5432).each { |final_host| pgsql_f << "#{final_host}\n" }
      osql_f = File.open('hosts_osql.txt', 'w')
      output_by_port(:file, 1521).each { |final_host| osql_f << "#{final_host}\n" }

      # nosql (redis 6379 ,mongo, 27017)
      redis_f = File.open('hosts_redis.txt', 'w')
      output_by_port(:file, 6379).each { |final_host| redis_f << "#{final_host}\n" }
      mongo_f = File.open('hosts_mongo.txt', 'w')
      output_by_port(:file, 27017).each { |final_host| mongo_f << "#{final_host}\n" }

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
end
