# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rack/http_spy/version'

Gem::Specification.new do |spec|
  spec.name          = "rack-http_spy"
  spec.version       = Rack::HTTPSpy::VERSION
  spec.authors       = ["dave@kapoq.com"]
  spec.email         = ["dave@kapoq.com"]
  spec.summary       = %q{Rack middleware to trace and report all HTTP requests made by your app}
  spec.description   = %q{Rack middleware to trace and report all HTTP requests made by your app}
  spec.homepage      = "https://github.com/textgoeshere/rack-http_spy"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rspec", "~> 2.14"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "rake", "~> 0.9.2"
  spec.add_development_dependency "curb"
  spec.add_development_dependency "rack-test"

  spec.add_dependency "rack", "~> 1.0"
  spec.add_dependency "webmock"
end
