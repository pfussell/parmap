require 'fsdb'
require 'yaml'
require 'nmap/xml'

# Tell FSDB to use YAML format when it sees ".yml" and ".yaml" suffixes.
# It is easy to extend the recognition rules to handle other formats.
# db.formats = [FSDB::YAML_FORMAT] + db.formats

# db = FSDB::Database.new('/tmp/my-data')
# db['recent-movies/myself'] = ["The King's Speech", "Harry Potter 7"]
# puts db['recent-movies/myself'][1]              # ==> "Harry Potter 7"
# db.formats = [FSDB::YAML_FORMAT] + db.formats

# hosts up
# hosts down
# hosts all
# port 22 up date
# services
# port 22 up
# port 22 closed
# port 22 filtered

# hosts
#  UP
#  DOWN
#  ALL

# services
#  UP
#    PORT
#      - IP
#       - version data
#       - nse data
#  DOWN
#    PORT
#     - IP
#  FILTERED

#
module Parmap

  class Project < FSDB::Database

    def initialize(path)
      @db = FSDB::Database.new(path)
    end

    def add_file(scan)
      puts "[+] Adding data to project"
      # db['recent-movies/myself'] = ["The King's Speech", "Harry Potter 7"]
      #data = Parmap::ParseScan.new(scan)
      data =  Nmap::XML.new("test.xml")
      data.each_host do |host|
        @db["hosts/#{host.ip}"] = []
        host.each_port do |port|
          @db.edit "hosts/#{host.ip}" do |data|
            data << ["#{port.number}", "#{port.protocol}", "#{port.state}", "#{port.service}"]
          end
        end
      end
        #host.each_po do |port|
        #  @db["hosts/#{host.ip}"] = ["#{port.number}", "#{port.protocol}", "#{port.state}", "#{port.service}"]
        #end
    end

    def read_host(host_ip)
      puts @db["hosts/#{host_ip}"]
    end

  end
end

# hosts/all.yaml
#   - host
#      - status: up
# hosts/
