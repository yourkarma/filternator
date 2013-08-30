# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'filternator/version'

Gem::Specification.new do |spec|
  spec.name          = "filternator"
  spec.version       = Filternator::VERSION
  spec.authors       = ["iain"]
  spec.email         = ["iain@iain.nl"]
  spec.description   = %q{A very basic gem for generating JSON responses for collections.}
  spec.summary       = %q{A very basic gem for generating JSON responses for collections.}
  spec.homepage      = "https://github.com/yourkarma/filternator"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "activerecord", ">= 3.1"
  spec.add_dependency "will_paginate", ">= 3.0"
  spec.add_development_dependency "bundler"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "sqlite3"
end
