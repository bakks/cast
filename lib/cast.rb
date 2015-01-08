require 'thread'
require 'open3'
require 'yaml'
require 'peach'
require 'bundler'

STDOUT.sync = true
STDERR.sync = true

module Cast
  VERSION = '0.1.7'
  DEFAULTGROUPS = '~/.cast.yml'

  @@mux = Mutex.new
  @@pids = []
  @@groups = nil

  def self.log msg, source = 'cast', stream = $stdout
    @@mux.synchronize do
      prefix = "[#{source}] " unless source == nil
      stream.puts "#{prefix}#{msg}"
    end
  end

  def self.load_groups groupfile
    file = File.expand_path groupfile
    exists = File.exists? file
    @@groups ||= {}

    if !exists
      raise "could not find #{groupfile}" if groupfile != DEFAULTGROUPS
      log "no group file found at #{groupfile}"
    else
      log "loading groups from #{groupfile}"
      @@groups = YAML.load_file file
    end

    return @@groups
  end

  def self.expand_groups cmdgroups, groups = @@groups
    hosts = []
    cmdgroups.each do |group|
      if groups.include? group
        hosts += groups[group]
      else
        hosts << group
      end
    end

    return hosts.uniq
  end

  def self.run hosts, cmd, serial = false, delay = nil, ssh = 'ssh'
    if serial or delay
      hosts.each_with_index do |host, i|
        remote host, cmd, ssh
        if delay and i < hosts.size - 1
          log "delay for #{delay} seconds"
          sleep delay
        end
      end
    else
      hosts.peach { |host| remote host, cmd, ssh }
    end
  end

  def self.remote host, cmd, ssh = 'ssh'
    fullcmd = "#{ssh} #{host} '#{cmd}'"
    log "running #{fullcmd}"
    local fullcmd, {:prefix => host}
  end

  def self.local cmd, options = {}
    options = {} if options == nil
    prefix = options[:prefix]

    r = nil

    blk = Proc.new do |stdin, stdout, stderr, wait_thr|
      @@pids << wait_thr.pid
      stdin.close

      while wait_thr.status
        streams = []
        streams << stdout if stdout
        streams << stderr if stderr
        break unless streams.size > 0

        ios = IO.select streams

        ios.first.each do |stream|
          if stream == stdout
            line = stream.gets
            if line == nil
              stdout.close
              stdout = nil
              next
            end
            log line, prefix

          elsif stream == stderr
            line = stream.gets
            if line == nil
              stderr.close
              stderr = nil
              next
            end
            log line, prefix, $stderr

          else raise "unrecognized stream #{stream}"
          end
        end
      end

      r = wait_thr.value
    end

    if options[:clean_bundler_env]
      Bundler.with_clean_env do
        Open3.popen3(cmd, &blk)
      end
    else
      Open3.popen3(cmd, &blk)
    end

    if options[:ensure]
      unless r.exitstatus == 0
        raise "command failed: #{cmd}"
      end
    end

    return r.exitstatus
  end

end
