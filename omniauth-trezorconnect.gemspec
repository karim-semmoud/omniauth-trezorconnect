# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'omniauth-trezorconnect/version'

Gem::Specification.new do |spec|
  spec.name          = "omniauth-trezorconnect"
  spec.version       = OmniAuth::Trezorconnect::VERSION
  spec.authors       = ["Karim Semmoud"]
  spec.email         = ["karim.semmoud@gmail.com"]

  spec.summary       = "OmniAuth strategy for authenticating against the Trezor Connect version 9"
  spec.description   = "Custom Omniatuh strategy using open source Javascript instead of a third party"
  spec.homepage      = "https://github.com/karim-semmoud/omniauth-trezorconnect"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "omniauth", "~> 2.1"
  spec.add_dependency "bitcoin", "~> 0.2"

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
end
