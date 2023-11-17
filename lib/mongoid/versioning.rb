require 'mongoid/core_ext/errors/versioning_not_on_root.rb'
require 'mongoid/core_ext/fields/standard.rb'
require 'mongoid/core_ext/fields/validators/macro.rb'
require 'mongoid/core_ext/hierarchy.rb'
require 'mongoid/core_ext/association/embedded/embeds_many/binding.rb'
require 'mongoid/core_ext/association/cascading.rb'
require 'mongoid/core_ext/association/embedded/batchable.rb'
require 'mongoid/core_ext/association/embedded/many.rb'
require 'mongoid/core_ext/association/macros.rb'
require 'mongoid/core_ext/association/options.rb'
require 'mongoid/core_ext/association/relatable.rb'
require 'mongoid/core_ext/threaded/lifecycle.rb'
require 'mongoid/core_ext/versioning.rb'

I18n.load_path << File.join(File.dirname(__FILE__), 'config', 'locales', 'en.yml')

module Mongoid
  module Versioning
  end
end
