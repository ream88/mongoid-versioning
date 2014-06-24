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

  gem.add_dependency 'activesupport'
  gem.add_dependency 'mongoid', '~> 4.0.0'
  gem.add_development_dependency 'mongoid-paranoia', '1.0.0.beta1'
  gem.add_development_dependency 'rake'
  gem.add_development_dependency 'rspec', '~> 3'
end
