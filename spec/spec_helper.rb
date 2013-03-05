require 'rubygems'
require 'bundler/setup'
require 'net/http'
require 'time'
require 'yaml'
require 'auth_hmac'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[File.join(File.expand_path('support/', File.dirname(__FILE__)), "**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # optional config
end
