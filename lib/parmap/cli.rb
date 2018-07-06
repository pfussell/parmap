require 'thor'

module Parmap
  class ParmapCLI < Thor
    
    desc "parse FILE", "print table of service scan results to stdout"
    def parse(file)
      puts "Hello #{file}"
    end

    desc "list", "print a list of 'up' hosts from the scan results"
    def list(file)
    end

    desc "port PORT", "print a list of hosts with given PORT open"
    def port(file)
    end
    
  end
end

ParmapCLI.start(ARGV)
