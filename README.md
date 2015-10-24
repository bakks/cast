# Cast

This is a Ruby gem that executes remote commands via ssh on groups of servers defined in a YAML file.

### Setup

Grab the gem:

```bash
gem install cast-ssh
```

Create your group file at ~/.cast.yml, like this:

```yaml
group1:
- host1
- host2
- host3

group2:
- host1
- host4
- host5
```

Run commands in your shell using this pattern:
```bash
cast [<flags>] <target> <command>
```

For example:
```bash
cast group1 echo test
cast group1,group2 sudo whoami
cast -s group1,host4 "df -h"
```

The output from the second command will look something like this:

```
[cast] loading groups from ~/.cast.yml
[cast] running ssh host1 'sudo whoami'
[cast] running ssh host2 'sudo whoami'
[cast] running ssh host3 'sudo whoami'
[cast] running ssh host4 'sudo whoami'
[host3] root
[host1] root
[host2] root
[host4] root
```

Note that the commands are run in parallel, so the output may be out of order.

### Options

             --serial, -s:   Execute commands serially, rather than in parallel over the group
          --delay, -d <f>:   Delay in seconds between execution of serial commands (switches to serial mode if defined)
      --groupfile, -g <s>:   YAML file of server groups (default: ~/.cast.yml)
               --list, -l:   Print out contents of groupfile without executing command
           --clusters, -c:   Print out only groupnames without executing command
            --ssh, -h <s>:   SSH command to run (default: ssh)
             --strict, -t:   Return a non-zero exit code if ANY of the ssh commands exit non-zero
  --controlfolder, -o <s>:   Path to look in for any ControlMaster tunnels (default: ~/.ssh/)
            --version, -v:   Print version and exit
               --help, -e:   Show this message


### API

You can also access the same functionality from within Ruby.

To include Cast in your code do:
```ruby
require 'cast'
```

The following methods are available:

* __Cast::remote__ host, cmd

  Run a remote command on the given host, sending output to stdout.

* __Cast::local__ cmd, options = {} -> int

  Run a command locally, printing stdout and stderr from the command. Returns the process' return value.

  You can use the following options:
  ```
  :ensure              - Raise exceptions if the command returns a non-zero error code.
  :prefix              - Prefix to use on lines when printing stdout/stderr.
  :clean_bundler_env   - Use a clean bundler environment when running the command.
  ```

* __Cast::log__ msg, source = 'cast', stream = $stdout

  Log a message through the Cast mutex using the given prefix and stream. Output will look like "[prefix] msg". The prefix box will be left out if the argument is nil.

* __Cast::load_groups__ file -> Hash

  Load Cast groups from the given file, returning them as a hash.

* __Cast::expand_groups__ cmdgroups, groups = @@groups -> Array

  Takes an array of groups and hosts, and expands the groups into their constituents given the input group hash. If no hash is given, use the value loaded most recently in load_groups. Returns an array of hostnames.

#### TODO

* Accept env vars for local and remote commands.
* Check for duplicate groups in groupfile.
* Propogate local signals to remote commands.

