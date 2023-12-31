# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'whack/version'

Gem::Specification.new do |spec|
  spec.name          = 'whack'
  spec.licenses      = ['MIT']
  spec.version       = Whack::VERSION
  spec.authors       = ['Alex Ford']
  spec.email         = ['alexford@hey.com']
  spec.required_ruby_version = '>= 3.2.0'

  spec.summary       = 'Rack for games'
  spec.homepage      = 'https://github.com/alexford/whack'

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path(__dir__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.require_paths = ['lib']
  spec.executables << "whackup"

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'stackprof'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'rubocop-minitest'
  spec.add_development_dependency 'rubocop-rake'
  spec.add_development_dependency 'yard', '~> 0.9'

  spec.add_dependency 'zeitwerk'
  spec.add_dependency 'gosu', '~> 1.4', '>= 1.4.6'
end
