require "option_parser"

# `Clipper` lets you convert the ARGV array into a hash of all the expected
# and optional flags and arguments.
class Clipper
  # Specifies an expected flag.
  #
  # After running `#parse`, the value provided by the user will be available
  # using the *long* key.
  #
  #     clipper = Clipper.new
  #     clipper.flag "--port PORT", "-p PORT", default: "3000"
  #     options = clipper.parse ARGV
  #     options["--port"]  # => "3000"
  #
  # Both the *short* key and *default* value are optional.
  #
  def flag(long, short = nil, default = false)
    key = long.split(' ').first
    input[key] = default

    register key, long, short
  end

  # Specifies an expected positional argument.
  #
  # Use this method to capture any positional argument that is not associated
  # with any flag. This is useful to capture sub-commands:
  #
  #     clipper = Clipper.new
  #     clipper.arg "command"
  #     options = clipper.parse ["download", "the-internet"]
  #     options["command"]  # => "download"
  #
  # or, to capture positional arguments for a command:
  #
  #     clipper.arg "source"
  #     clipper.arg "target"
  #     options = clipper.parse ["source.txt"]
  #     options["source"]  # => "source.txt"
  #     options["target"]  # => false
  #
  def arg(name)
    arg_keys << name
  end

  # Parses a array and returns a hash of expected and actual options.
  #
  # This method typically expects ARGV as its input array.
  #
  # ```
  # clipper = Clipper.new
  #
  # clipper.flag "--cache", "-c"
  # clipper.flag "--long-only"
  # clipper.flag "--port PORT", "-p PORT", default: "3000"
  # clipper.arg "command"
  #
  # options = clipper.parse
  # # => {"--cache" => false, "--long-only" => false,
  # # => "--port" => "3000", "command" => false}
  #
  # options = clipper.parse ["--cache", "-p", "4567"]
  # # => {"--cache" => true, "--long-only" => false,
  # # => "--port" => "4567", "command" => false}
  #
  # options = clipper.parse ["download"]
  # # => {"--cache" => true, "--long-only" => false,
  # # => "--port" => "4567", "command" => "download"}
  # ```
  #
  def parse(args = [] of String)
    args = args.dup
    parser.invalid_option { }
    parser.parse args
    append_named_args args
    input
  end

  # Adds expected args (defined with `#arg`) to the resulting options hash.
  protected def append_named_args(args)
    arg_keys.each do |key|
      input[key] = args.empty? ? false : args.shift
    end
  end

  # Holds the list of expected positional args.
  protected def arg_keys
    @arg_keys ||= [] of String
  end

  # Registers a flag handler using `OptionParser`.
  # OPTIMIZE: There must be a prettier way to do this.
  protected def register(key, long, short)
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

  # Holds the result of `#parse`.
  protected def input
    @input ||= {} of String => String | Bool
  end

  # The `OptionParser` helper.
  protected def parser
    @parser ||= OptionParser.new
  end
end
