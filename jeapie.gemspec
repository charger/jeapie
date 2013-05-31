# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jeapie/version'

Gem::Specification.new do |gem|
  gem.name          = 'jeapie'
  gem.version       = Jeapie::VERSION
  gem.authors       = ['Lutsko Dmitriy']
  gem.email         = %w(regrahc@gmail.com)
  gem.date          = Time.now.strftime('%Y-%m-%d')
  gem.description   = 'Wrapper for Jeapie push service http://jeapie.com'
  gem.summary       = 'Allow send push notification to your Android and Apple devices'
  gem.homepage      = 'https://github.com/charger/jeapie'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)

  gem.add_dependency('activesupport')
  gem.add_development_dependency 'fakeweb', ['~> 1.3']
end
