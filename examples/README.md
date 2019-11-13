Clipper Examples
==================================================

Basic Example
--------------------------------------------------

The most minimal setup.

    $ cd examples/basic
    $ crystal run cli.cr -- --help 


Classes Example
--------------------------------------------------

Separate subcommands to their own classes. 

    $ cd examples/classes
    $ crystal run git.cr -- --help 
    $ crystal run git.cr -- status --help 
    $ crystal run git.cr -- status --short
    $ crystal run git.cr -- commit --help