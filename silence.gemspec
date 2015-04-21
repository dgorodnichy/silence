# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'silence/version'

Gem::Specification.new do |spec|
  spec.name          = "silence"
  spec.version       = Silence::VERSION
  spec.authors       = ["gorodni4ij"]
  spec.email         = ["gorodni4ij@gmail.com"]

  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "https://rubygems.org" #"TODO: Set to 'http://mygemserver.com' to prevent pushes to rubygems.org, or delete to allow pushes to any server."
  end

  spec.summary       = "Minimalistic functional framework"
  spec.description   = "Minimalistic functional framework"
  spec.homepage      = "https://github.com/dunst/silence"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "bin"
  #spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  #spec.executables   = "silence" 
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency 'thor'
  #spec.add_development_dependency 'thor', '~> 0.19', '>= 0.19.1'
  spec.add_development_dependency "bundler", "1.8.4"
  spec.add_development_dependency "rake", "10.0"
  spec.add_development_dependency "cucumber", "2.0.0.rc.4"
  spec.add_development_dependency "watir-webdriver", "0.6.11"
  spec.add_development_dependency "page-object", "1.0.3"
  spec.add_development_dependency "require_all", "1.3.2"
  spec.add_development_dependency "headless", "1.0.2"
  spec.add_development_dependency "faker", "1.4.3"
  spec.add_development_dependency "rspec", "3.2.0"
  spec.add_development_dependency "data_magic", "0.20"

end
