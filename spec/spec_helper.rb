$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rubygems'
require 'rspec'
require 'mocha/api'
require 'cast'

RSpec.configure do |config|
  config.mock_with :mocha
  config.fail_fast = true
end

