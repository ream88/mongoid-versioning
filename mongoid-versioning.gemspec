$: << File.expand_path('../lib', __FILE__)
require 'mongoid/versioning/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-versioning'
  gem.version       = Mongoid::Versioning::VERSION
  gem.authors       = 'Mario Uher'
  gem.email         = 'uher.mario@gmail.com'
  gem.homepage      = 'https://github.com/haihappen/mongoid-versioning'
  gem.summary       = 'Extraction of mongoid-versioning into its own gem.'
  gem.description   = "Mongoid supports simple versioning through inclusion of the Mongoid::Versioning module."

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport', '>= 3.0'
  gem.add_dependency 'mongoid', '~> 3.0'
end
