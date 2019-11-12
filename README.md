Clipper - Pure Command Line Arguments Parser
==================================================  

Clipper is a small wrapper around the standard `OptionParser` with these 
changes in concept:

1. It supports positional arguments (commands or positional parameters).
2. It simply returns a hash of all the expected flags and positional 
   arguments.
3. It does not concern itself with any help or usage strings - you need to 
   bring your own.


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

```crystal
require "clipper"

clipper = Clipper.new

clipper.flag "--cache", "-c"
clipper.flag "--long-only"
clipper.flag "--port PORT", "-p PORT", default: "3000"
clipper.arg "command"

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



