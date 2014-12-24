# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'amqp_rpc/version'

Gem::Specification.new do |spec|
  spec.name          = 'amqp_rpc'
  spec.version       = AmqpRpc::VERSION
  spec.authors       = ['doodzik']
  spec.email         = ['frederik.dudzik@gmail.com']

  spec.summary       = 'TODO: a short summary, because Rubygems requires one.'
  spec.description   = 'TODO: Write a longer description or delete this line.'
  spec.homepage      = 'TODO: Put your gem\'s website or public repo URL here.'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0").reject do
                          |f| f.match(/^(test|spec|features)\//)
  end
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'msgpack'
  spec.add_dependency 'bunny'

  spec.add_development_dependency 'bundler', '~> 1.7'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-bundler'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-rspec'
  spec.add_development_dependency 'reek'
  spec.add_development_dependency 'yard'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'byebug'
  spec.add_development_dependency 'did_you_mean'
end
