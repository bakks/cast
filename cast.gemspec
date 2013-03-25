# encoding: utf-8
require File.expand_path("../lib/cast.rb", __FILE__)

Gem::Specification.new do |gem|
  gem.add_development_dependency 'mocha'
  gem.add_development_dependency 'rspec'
  gem.add_development_dependency 'autotest-standalone'
  gem.add_runtime_dependency 'peach'
  gem.add_runtime_dependency 'trollop'

  gem.authors = ["Peter Bakkum"]
  gem.bindir = 'bin'
  gem.description = %q{Execute remote commands via ssh on groups of machines}
  gem.email = ['pbb7c@virginia.edu']
  gem.executables = ['cast']
  gem.extra_rdoc_files = ['LICENSE.md', 'README.md']
  gem.files = Dir['LICENSE.md', 'README.md', 'cast.gemspec', 'Gemfile', '.rspec', '.travis.yml', 'lib/**/*', 'bin/*', 'spec/**/*']
  gem.homepage = 'http://github.com/bakks/cast'
  gem.name = 'cast-ssh'
  gem.rdoc_options = ["--charset=UTF-8"]
  gem.require_paths = ['lib']
  gem.required_rubygems_version = Gem::Requirement.new(">= 1.3.6")
  gem.summary = %q{Execute remote commands via ssh on groups of machines}
  gem.test_files = Dir['spec/**/*']
  gem.version = Cast::VERSION
  gem.license = 'MIT'
end

