# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'blender/salt/version'

Gem::Specification.new do |spec|
  spec.name          = 'blender-salt'
  spec.version       = Blender::Salt::VERSION
  spec.authors       = ['Grant Ridder']
  spec.email         = ['shortdudey123@gmail.com']
  spec.summary       = 'Salt backend for blender'
  spec.description   = 'Execute tasks using Salt'
  spec.homepage      = ''
  spec.license       = 'Apache 2'

  spec.files         = `git ls-files -z`.split("\x0").reject { |f|
    f.match(%r{^(test|spec|features)/})
  }
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'pd-blender'
  spec.add_dependency 'salt_client'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'rubocop'
end
