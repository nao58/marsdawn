# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marsdawn/version'

Gem::Specification.new do |spec|
  spec.name          = "marsdawn"
  spec.version       = Marsdawn::VERSION
  spec.authors       = ["Naohiko MORI"]
  spec.email         = ["naohiko.mori@gmail.com"]
  spec.summary       = %q{Easy static document builder & traverser.}
  spec.description   = %q{Make it easy to create static document site by building markdown documents and traverse them.}
  spec.homepage      = "https://github.com/nao58/marsdawn"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake", "~> 10.3"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_dependency "kramdown", "~> 1.3"
end
