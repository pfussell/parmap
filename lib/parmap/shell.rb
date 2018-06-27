## SHELL

require 'readline'

data_set = false
prompt_text = ""

# there will be four methods related to the importing
# of scan data to work with within the shell: create, import, use
#  set, create, import: set active project for already created project,
#  create a project, add data to project,
#  use: parse data from a single nmap xml file

def create(ary_of_args)
  puts "I will create stuff"
  puts "and do stuff to"
  ary_of_args.each do |a|
    puts a
  end
end

def import
  puts "I will import files into a project"
end

def use
  puts "use file"
end

def set(xml_file)
  puts "Setting active xml file"
end


# these are the parsing methods. Before any of these can
# be used you must either set a project or xml file using
# above methods
def list
  puts "list hosts"
end

def port
  puts "lists hosts with port"
end

def services
  puts "services"
end

def scan
  "run a scan"
end

def help
  puts "I am help text"
end

def scan(from_shell)
  user_input_ary = from_shell.split
  cmd = user_input_ary.shift

  case cmd.downcase
  when "create"
    create(user_input_ary)
  when "import"
    import
  when "list"
    list
  when "exit"
    exit
  else
    help
  end
  
end


#  I'd like to have the shell prompt refelct the xml file or project file
#  you are working with

prompt = "#{prompt_text}>> "

# going to use readline to handle this part
# that way we can easily add autocomplete and history
loop do
  print prompt
  scan(gets.chomp)
end
  
