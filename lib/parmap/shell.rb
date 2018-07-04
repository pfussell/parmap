## SHELL

require 'readline'

module Parmap
  data_set = false
  @@prompt_text = ""
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
    filename = args_ary[0].to_s
    puts "Setting active xml file: #{filename}"
    puts "setting prompt"
    @@prompt_text = "#{filename}"
  end


  # these are the parsing methods. Before any of these can
  # be used you must either set a project or xml file using
  # above methods
  def self.list
    puts "list hosts"
  end

  def self.port
    puts "lists hosts with port"
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
    loop do
      prompt = "#{@@prompt_text}>> "
      print prompt
      scan(gets.chomp)
    end
  end

end


  
#Cli.shell
