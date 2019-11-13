require "../../src/clipper"

module Git
  class GitCommit
    def self.start(args = [] of String)
      new.run args
    end

    def run(args)
      options = clipper.parse args

      if options["--help"]
        show_help extended: true
      else
        puts "git commit with options:"
        pp options
      end
    end

    protected def show_help(extended = false)
      puts <<-HELP
      git commit - record changes to the repository

      Usage:
        git commit [options]
        git commit --help
      
      HELP

      if extended
        puts <<-EXTENDED
        Options:
          -h, --help
            show this help.

          -a, --all
            tell the command to automatically stage files that have been
            modified and deleted, but new files you have not told Git about
            are not affected.
          
          -m MSG, --message MSG
            Use the given MSG as the commit message. If multiple -m options
            are given, their values are concatenated as separate paragraphs.

        
        EXTENDED
      end
    end

    protected def clipper
      clipper = Clipper.new

      clipper.flag "--help", "-h"
      clipper.flag "--all", "-a"
      clipper.flag "--message MSG", "-m MSG"

      clipper
    end
  end
end
