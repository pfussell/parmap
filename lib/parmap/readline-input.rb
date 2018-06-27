def shell

  base_actions = {:create => Cli.create,
                  :import => Cli.import,
                  :use => Cli.use,
                  :list => Cli.list,
                  :port => Cli.port,
                  :services => Cli.services,
                  :scan => Cli.scan
                 }

  # need to add the ability to detect OS and test if the scipt
  # path is present 
  list = Dir.entries("/usr/share/nmap/scripts")
  comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

  Readline.completion_append_character = " "
  Readline.completion_proc = comp

  while input = Readline.readline("> ", true)

    # pop base command
    # pass the remaining arguments as array to associated function
    # commands a, b, and c - hash = {:a => a_command(),:b => b_command ,:c => c_command}
    cmd = input.shift

    case action[0].to_sym
    when :create
      Cli.create
    when :import
      import
    end

    # Remove blank lines from history
    Readline::HISTORY.pop if input == ""
  end
end


shell
