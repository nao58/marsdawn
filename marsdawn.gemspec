# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'marsdawn/version'

Gem::Specification.new do |spec|
  spec.name          = "marsdawn"
  spec.version       = Marsdawn::VERSION
  spec.authors       = ["Naohiko MORI"]
  spec.email         = ["naohiko.mori@gmail.com"]
  spec.summary       = %q{Makes it easy to create documentation or references with MarkDown.}
  spec.description   = %q{Makes it easy to create documentation or references with MarkDown.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.5"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_dependency "kramdown"
end
