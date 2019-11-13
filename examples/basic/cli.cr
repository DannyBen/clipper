require "../../src/clipper"

clipper = Clipper.new

clipper.flag "--cache", "-c"
clipper.flag "--long-only"
clipper.flag "--port PORT", "-p PORT", default: "3000"
clipper.arg "command"

options = clipper.parse
p options
# => {"--cache" => false, "--long-only" => false,
# => "--port" => "3000", "command" => false}

options = clipper.parse ["--cache", "-p", "4567"]
p options
# => {"--cache" => true, "--long-only" => false,
# => "--port" => "4567", "command" => false}

options = clipper.parse ["download"]
p options
# => {"--cache" => true, "--long-only" => false,
# => "--port" => "4567", "command" => "download"}
