require "option_parser"

class Clipper
  VERSION = "0.1.0"

  def flag(long, short = nil, default = false)
    key = long.split(' ').first
    input[key] = default

    register key, long, short
  end

  def arg(name)
    arg_keys << name
  end

  def parse(args = [] of String)
    args = args.dup
    parser.parse args
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
