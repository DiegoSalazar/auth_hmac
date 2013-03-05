require 'openssl'
require 'base64'

def require_libs
  require "auth_hmac/version"
  require "auth_hmac/headers"
  require "auth_hmac/canonical_string"
  require "auth_hmac/rack/middleware"
  require "auth_hmac/rails/controller_filter"
  require "auth_hmac/rails/active_resource_extension"
  require "auth_hmac/auth_hmac"
end

begin
  require_libs
rescue LoadError
  require 'bundler'
  Bundler.setup
  require_libs
end