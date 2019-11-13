require "option_parser"

class Clipper
  getter :commands

  def initialize
    @commands = {} of String => Proc(Array(String), Nil)
  end

  def flag(long, short = nil, default = false)
    key = long.split(' ').first
    input[key] = default

    register key, long, short
  end

  def arg(name)
    arg_keys << name
  end

  def command(name, &handler : Array(String) ->)
    commands[name] = handler
  end

  def parse(args = [] of String)
    args = args.dup
    parser.invalid_option { }

    parser.parse args

    if args.size > 0 && commands.size > 0
      input = args[0]
      commands.each do |command, block|
        if command == input
          args.shift
          block.call args
        end
      end
    end

    append_named_args args
    input
  end

  protected def append_named_args(args)
    arg_keys.each do |key|
      input[key] = args.empty? ? false : args.shift
    end
  end

  protected def arg_keys
    @arg_keys ||= [] of String
  end

  protected def register(key, long, short)
    # FIXME: There must be a prettier way to do this
    if short
      parser.on short, long, "" do |value|
        input[key] = value.empty? ? true : value
      end
    else
      parser.on long, "" do |value|
        input[key] = value.empty? ? true : value
      end
    end
  end

  protected def input
    @input ||= {} of String => String | Bool
  end

  protected def parser
    @parser ||= OptionParser.new
  end
end
