## SHELL

require 'readline'

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

def scan(from_shell)
  user_input_ary = from_shell.split
  cmd = user_input_ary.shift

  case cmd
  when "create"
    create(user_input_ary)
  when "import"
    import
  when "exit"
    exit
  end
  
end

loop do
  print "> "
  scan(gets.chomp)
end
  
