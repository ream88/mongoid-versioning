module Mongoid
  module Relations
    module Macros
      module ClassMethods
        # Adds the relation back to the parent document. This macro is
        # necessary to set the references from the child back to the parent
        # document. If a child does not define this relation calling
        # persistence methods on the child object will cause a save to fail.
        #
        # @example Define the relation.
        #
        #   class Person
        #     include Mongoid::Document
        #     embeds_many :addresses
        #   end
        #
        #   class Address
        #     include Mongoid::Document
        #     embedded_in :person
        #   end
        #
        # @param [ Symbol ] name The name of the relation.
        # @param [ Hash ] options The relation options.
        # @param [ Proc ] block Optional block for defining extensions.
        def embedded_in(name, options = {}, &block)
          if ancestors.include?(Mongoid::Versioning)
            raise Errors::VersioningNotOnRoot.new(self)
          end
          meta = characterize(name, Embedded::In, options, &block)
          self.embedded = true
          relate(name, meta)
          builder(name, meta).creator(name, meta)
          add_counter_cache_callbacks(meta) if meta.counter_cached?
          meta
        end
      end
    end
  end
end
