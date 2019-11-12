Clipper - Pure Command Line Arguments Parser
==================================================  

Clipper is a small wrapper around the standard `OptionParser` with these 
conceptual changes:

1. It supports positional arguments (commands or positional parameters).
2. It simply returns a hash of all the expected flags and positional 
   arguments.
3. It is designed to let you separate the command line parsing from your
   actual implementation.
4. It does not concern itself with any help or usage strings - you need to 
   bring your own.
5. It stays out of your way.

Clipper does not assume anything about how you wish to build your command
line utility, or how you wish to display its usage.


Installation
---------------------------------------------------


1. Add the dependency to your `shard.yml`:

```yaml
dependencies:
 clipper:
   github: dannyben/clipper
```

2. Run `shards install`


Usage
--------------------------------------------------

Clipper contains three methods only:

- `#flag` - specify which flags are expected.
- `#arg` - specify which positional arguments are expected.
- `#parse` - convert the `ARGV` array to a Hash of all expected and actual
   options.

```crystal
require "clipper"

# Create a clipper instance:
clipper = Clipper.new

# Specify which flags are expected, using one of these general patterns:
clipper.flag "--cache", "-c"
clipper.flag "--long-only"
clipper.flag "--port PORT", "-p PORT", default: "3000"

# If you care about any positional arguments, give them a name by using this
# pattern:
clipper.arg "command"

# Finally, parse the options:
options = clipper.parse
#=> {"--cache" => false, "--long-only" => false, 
#=>  "--port" => "3000", "command" => false}

options = clipper.parse ["--cache", "-p", "4567"]
#=> {"--cache" => true, "--long-only" => false,
#=>  "--port" => "4567", "command" => false}

options = clipper.parse ["download"]
#=> {"--cache" => true, "--long-only" => false,
#=>  "--port" => "4567", "command" => "download"}
```

For more advanced examples, see the examples folder.
