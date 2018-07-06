## SHELL

require 'readline'

module Parmap
  @@data_set = false
  @@prompt_text = ""
  @@parsed_xml = ""

  def print_help
    puts "Data Setup Tasks:"
    puts "Before you can scan or parse any data you must either set an active project, create a project"
    puts "and import data from nmap output (eg. use create import) or set an xml file directly to work with"
    puts "(eg. set) "
    puts "  create NAME      # create a project with name NAME"
    puts "  import FILE      # import data from FILE into active project"
    puts "  use PROJ_NAME    # set the current active project to PROJ_NAME"
    puts "  set FILE         # set FILE as the active file to work with"
    puts "  cli help [TASK]  # Describe available tasks or one specific task"
    puts ""
    puts "Parsing and Scanning Tasks:"
    puts "  list out FILE             # list live hosts (this will be based on the scan type); optionally dump results to FILE"
    puts "  port PORT_NUM out FILE    # print output a list of hosts that have PORT open; optionally dump results to FILE"
    puts "  services out FILE         # generate a list of hosts and their associated open ports and service versions"
    puts "  qparse                    # generate a set of files containing host IPs based on a set of common ports"
    puts "  scan                      # scan TBD"
    puts "  help                      # print help text"
    puts "For help with a specific task append 'help' to the command"
    puts ">> set help"
    puts ""
    puts "examples: "
  end
  
  # there will be four methods related to the importing
  # of scan data to work with within the shell: create, import, use
  #  set, create, import: set active project for already created project,
  #  create a project, add data to project,
  #  use: parse data from a single nmap xml file

  def self.create(ary_of_args)
    puts "I will create stuff"
    puts "and do stuff to"
    ary_of_args.each do |a|
      puts a
    end
  end

  def self.import
    puts "I will import files into a project"
  end

  def self.use
    puts "use file"
  end

  def self.set(args_ary)
    if File.exists?(args_ary[0].to_s)
      filename = args_ary[0].to_s
      puts "Setting active xml file: #{filename}"
      @@parsed_xml = Parmap::ParseScan.new(filename)
      @@prompt_text = "#{filename}"
      @@data_set = true
    elsif args_ary.to_s.downcase == "help"
      puts "set FILE"
      puts "This command will set the active data soruce to the specific file"
      puts "Any additional parsing or scanning tasks will then be executed using"
      puts "that file as a data source."
    else
      print_help
    end
  end


  # these are the parsing methods. Before any of these can
  # be used you must either set a project or xml file using
  # above methods
  # I can also output by hostname if present so I need to add
  # that option in here
  def self.list
    puts "list hosts"
    @@parsed_xml.live_hosts_to_stdout
  end

  # need to write in check for output file option 
  # parsing library also supports passing multiple ports into this arg
  # need to go back and add that functionality here 
  def self.port(args_ary)
    if @@data_set
      puts "Checking for hosts with port #{args_ary[0]} open: "
      @@parsed_xml.output_by_port(:std, args_ary[0].to_i)
    else
      puts "Please select a data source first."
    end
  end

  def self.services
    puts "services"
  end

  def self.scan
    "run a scan"
  end

  def self.help
    puts "I am help text"
  end

  def self.scan(from_shell)
    user_input_ary = from_shell.split
    cmd = user_input_ary.shift

    case cmd.downcase
    when "create"
      create(user_input_ary)
    when "import"
      import
    when "list"
      list
    when "set"
      set(user_input_ary)
    when "port"
      port(user_input_ary)
    when "exit"
      exit
    else
      help
    end
    
  end

  # this is the loop that will handle the user input
  # going to use readline to handle this part
  # that way we can easily add autocomplete and history  
  #  I'd like to have the shell prompt refelct the xml file or project file
  #  you are working with
  def self.shell
    #loop do
    #  prompt = "#{@@prompt_text}>> "
    #  print prompt
    #  scan(gets.chomp)
    #end

    list = Dir.entries("/usr/share/nmap/scripts")
    comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    while input = Readline.readline("#{@@prompt_text}>> ", true)
      # Remove blank lines from history
      scan(input)
      Readline::HISTORY.pop if input == ""
    end
  end
  


end


  
#Cli.shell
