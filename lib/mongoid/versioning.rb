require "mongoid/core_ext/errors/versioning_not_on_root.rb"
require "mongoid/core_ext/fields/standard.rb"
require "mongoid/core_ext/fields/validators/macro.rb"
require "mongoid/core_ext/hierarchy.rb"
require "mongoid/core_ext/relations/bindings/embedded/many.rb"
require "mongoid/core_ext/relations/cascading.rb"
require "mongoid/core_ext/relations/embedded/batchable.rb"
require "mongoid/core_ext/relations/embedded/many.rb"
require "mongoid/core_ext/relations/macros.rb"
require "mongoid/core_ext/relations/metadata.rb"
require "mongoid/core_ext/relations/options.rb"
require "mongoid/core_ext/threaded/lifecycle.rb"
require "mongoid/core_ext/versioning.rb"

I18n.load_path << File.join(File.dirname(__FILE__), "config", "locales", "en.yml")

module Mongoid
  module Versioning
  end
end
