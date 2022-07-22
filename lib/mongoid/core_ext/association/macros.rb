module Mongoid
  module Association
    module Macros
      module ClassMethods
        alias_method :embedded_in_without_versioning_validation, :embedded_in

        def embedded_in(name, options = {}, &block)
          if ancestors.include?(Mongoid::Versioning)
            raise Errors::VersioningNotOnRoot, self
          end
          define_association!(__method__, name, options, &block)
        end
      end
    end
  end
end
