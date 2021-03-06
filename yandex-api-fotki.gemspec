# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'yandex/api/fotki/version'

Gem::Specification.new do |spec|
  spec.name          = "yandex-api-fotki"
  spec.version       = Yandex::API::Fotki::VERSION
  spec.authors       = ["github.com/1v"]
  spec.email         = ["forwardin@yandex.ru"]

  spec.summary       = %q{Yandex Fotki API wrapper}
  spec.description   = %q{Yandex Fotki API wrapper}
  spec.homepage      = "https://github.com/1v/yandex-api-fotki"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.required_ruby_version = '>= 2.2.2'

  spec.add_runtime_dependency "activesupport", ">= 4.0.0"
  spec.add_runtime_dependency "rest-client", "~> 2.0"

  spec.add_development_dependency "bundler", "~> 1.13"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "codeclimate-test-reporter", "~> 1.0"
end
