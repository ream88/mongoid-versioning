$LOAD_PATH << File.expand_path('../lib', __FILE__)
require 'mongoid/versioning/version'

Gem::Specification.new do |gem|
  gem.name          = 'mongoid-versioning'
  gem.version       = Mongoid::Versioning::VERSION
  gem.authors       = ['Durran Jordan', 'Mario Uher']
  gem.email         = ['durran@gmail.com', 'uher.mario@gmail.com']
  gem.homepage      = 'https://github.com/haihappen/mongoid-versioning'
  gem.summary       = 'Extraction of mongoid-versioning into its own gem.'
  gem.description   = 'Mongoid supports simple versioning through inclusion of the Mongoid::Versioning module.'
  gem.licenses      = ['MIT']

  gem.files         = `git ls-files`.split("\n")
  gem.require_path  = 'lib'

  gem.add_dependency 'activesupport', '>= 4.0'
  gem.add_dependency 'mongoid', '>= 6.0.0', '< 7.0.0'
  gem.add_development_dependency 'rake', '~> 10.0'
  gem.add_development_dependency 'rspec', '~> 3'
end
