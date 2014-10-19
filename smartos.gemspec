# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'smartos/version'

Gem::Specification.new do |spec|
  spec.name          = "smartos"
  spec.version       = SmartOS::VERSION
  spec.authors       = ["John Knott"]
  spec.email         = ["john.knott@gmail.com"]
  spec.summary       = %q{Ruby library that wraps SmartOS executables such as vmadm, imgadm, and svcadm}
  spec.description   = %q{This library can be used to remotely provision a SmartOS global zone. It could be used in scripts to automate the initial setup of an infrastructure, before handing off to a fully featured config management tool such as Salt, Ansible, Puppet or Chef.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "rspec-nc"
  spec.add_development_dependency "guard"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "pry-remote"
  spec.add_development_dependency "pry-nav"
  spec.add_development_dependency "coveralls"
end
