require "../../src/clipper"

module Git
  class GitStatus
    def self.start(args = [] of String)
      new.run args
    end

    def run(args)
      options = clipper.parse args

      if options["--help"]
        show_help extended: true
      else
        puts "git status with options:"
        pp options
      end
    end

    protected def show_help(extended = false)
      puts <<-HELP
      git status - show the working tree status

      Usage:
        git status [options]
        git status --help
      
      HELP

      if extended
        puts <<-EXTENDED
        Options:
          -s, --short    Give the output in the short-format.
          -b, --branch   Show the branch even in short-format.
          --show-stash   Show the number of entries currently stashed away.
          -h, --help     Show this help.

        EXTENDED
      end
    end

    protected def clipper
      clipper = Clipper.new

      clipper.flag "--help", "-h"
      clipper.flag "--short", "-s"
      clipper.flag "--branch", "-b"
      clipper.flag "--show-stash"
      clipper
    end
  end
end
