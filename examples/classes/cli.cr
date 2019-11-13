require "../../src/clipper"
require "./git_status"
require "./git_commit"

module Git
  class CLI
    def self.start(args = [] of String)
      new.run args
    end

    def run(args)
      options = clipper.parse args

      if options["command"] == "status"
        GitStatus.start args - ["status"]
      elsif options["command"] == "commit"
        GitCommit.start args - ["commit"]
      elsif options["--help"]
        show_help extended: true
      else
        show_help
      end
    end

    protected def show_help(extended = false)
      puts <<-HELP
      git cli example

      Usage:
        git COMMAND
        git -h, --help | --version

      Commands:
        status   Show the working tree status
        commit   Record changes to the repository
      
      HELP

      if extended
        puts <<-EXTENDED
        Options:
          -h, --help      Show this help
              --version   Show version number
        
        EXTENDED
      end
    end

    protected def clipper
      clipper = Clipper.new

      clipper.flag "--help", "-h"
      clipper.flag "--version"
      clipper.arg "command"

      clipper
    end
  end
end
