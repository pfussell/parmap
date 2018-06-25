## SHELL

require 'highline/import'
require 'tty-prompt'
require 'pastel'

def nmap_shell
  # need to add the ability to detect OS and test if the scipt
  # path is present 
  list = Dir.entries("/usr/share/nmap/scripts")
  comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

  Readline.completion_append_character = " "
  Readline.completion_proc = comp
  
  while input = Readline.readline("> ", true)
    break                       if input == "exit"
    puts Readline::HISTORY.to_a if input == "hist"

    # Remove blank lines from history
    Readline::HISTORY.pop if input == ""

    system(input)
  end
end

prompt = TTY::Prompt.new
loop do
  cmd = prompt.ask('>')
  case cmd
  when "hello"
    puts "hello to you too"
  when
    "exit"
    break if prompt.yes?("exit?")
  end
end
