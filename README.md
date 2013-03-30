# Cast

This is a Ruby gem that executes remote commands via ssh on groups of servers defined in a YAML file.

### Setup

Grab the gem:

    gem install cast-ssh

Create your group file at ~/.cast.yml, like this:

    group1:
    - host1
    - host2
    - host3

    group2:
    - host1
    - host4
    - host5

Run commands in your shell:

    cast group1 echo test
    cast group1,group2 sudo whoami
    cast -s group1,host4 df -h

The output from the second command will look something like this:

    [cast] loading groups from ~/.cast.yml
    [cast] running ssh host1 'sudo whoami'
    [cast] running ssh host2 'sudo whoami'
    [cast] running ssh host3 'sudo whoami'
    [cast] running ssh host4 'sudo whoami'
    [cast] running ssh host5 'sudo whoami'
    [host3] root
    [host1] root
    [host2] root
    [host5] root
    [host4] root

Note that the commands are run in parallel, so the output may be out of order.

### Options

           --serial, -s:   Execute commands serially, rather than in parallel over the group
        --delay, -d <f>:   Delay in seconds between execution of serial commands (switches to serial mode if defined)
    --groupfile, -g <s>:   YAML file of server groups (default: ~/.cast.yml)
             --list, -l:   Print out contents of groupfile without executing command
         --clusters, -c:   Print out only groupnames without executing command
          --ssh, -h <s>:   SSH command to run (default: ssh)
          --version, -v:   Print version and exit
             --help, -e:   Show this message

### API

You can also access the same functionality from within Ruby. The following methods are available:

* __Cast::remote__ host, cmd

  Run a remote command on the given host, sending output to stdout.

* __Cast::local__ cmd, prefix = nil -> int

  Run a command locally, printing stdout and stderr from the command. Returns the process' return value.

* __Cast::ensure_local__ cmd, prefix = nil -> int

  Run a command locally but raise an exception if it fails.

* __Cast::log__ msg, source = 'cast', stream = $stdout

  Log a message through the Cast mutex using the given prefix and stream. Output will look like "[prefix] msg". The prefix box will be left out if the argument is nil.

* __Cast::load_groups__ file -> Hash

  Load Cast groups from the given file, returning them as a hash.

* __Cast::expand_groups__ cmdgroups, groups = @@groups -> Array

  Takes an array of groups and hosts, and expands the groups into their constituents given the input group hash. If no hash is given, use the value loaded most recently in load_groups. Returns an array of hostnames.

