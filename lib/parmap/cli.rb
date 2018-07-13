require 'thor'

module Parmap
  class ParmapCLI < Thor
    
    desc "list NMAP_FILE --type [IP/NAME]", "print table of service scan results to stdout"
    option :type
    #option :out
    def list(file)
      parsed = Parmap::ParseScan.new(file)
      if options[:type]
        if options[:type].downcase == "name"
          parsed.live_hosts_to_stdout(:name)
        elsif options[:type].downcase == "ip"
          parsed.live_hosts_to_stdout
        else
          put "Please select a valid option for type (IP or NAME)"
        end
          
        else
          parsed.live_hosts_to_stdout
      end
    end
    
  end
end

#Parmap::ParmapCLI.start(ARGV)
