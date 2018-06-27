## SHELL

require 'readline'

module Cli

  base_actions = ["create", "import", "use", "list", "port", "services", "scan"]
  create_args = []
  list_args = []
  port_args = []
  scan_args = []


  def shell
    # need to add the ability to detect OS and test if the scipt
    # path is present 
    list = Dir.entries("/usr/share/nmap/scripts")
    comp = proc { |s| list.grep(/^#{Regexp.escape(s)}/) }

    Readline.completion_append_character = " "
    Readline.completion_proc = comp

    while input = Readline.readline("> ", true)

      action = input.split

      case input
      when ""
      when "exit"
        break
      end

      # Remove blank lines from history
      Readline::HISTORY.pop if input == ""
    end
  end


  # figure out if a project already exists
  # with the given name
  def proj_exists?(name)
  end

  # create the project file
  # .name.yaml
  def proj_createj(name)
    # test to see if the proj already exsists
    # and throw an error if it does
  end

  def proj_import
  end

end



