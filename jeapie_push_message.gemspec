# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jeapie_push_message/version'

Gem::Specification.new do |gem|
  gem.name          = 'jeapie_push_message'
  gem.version       = JeapiePushMessage::VERSION
  gem.authors       = ['Lutsko Dmitriy']
  gem.email         = %w(regrahc@gmail.com)
  gem.description   = 'Wrapper for Jeapie push service'
  gem.summary       = 'Allow send push notification to your Android and Apple devices'
  gem.homepage      = 'http://jeapie.com'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = %w(lib)
end
