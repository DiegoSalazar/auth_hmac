# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'auth_hmac/version'

Gem::Specification.new do |gem|
  gem.name          = "auth_hmac"
  gem.version       = AuthHmac::VERSION
  gem.authors       = ["Sean Geoghegan", "ascarter", "Diego Salazar"]
  gem.email         = ["diego@1saleaday.com"]
  gem.description   = %q{A gem providing HMAC based authentication for HTTP}
  gem.summary       = %q{Simple API to authenticate HTTP requests between services}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($/)
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]
end
