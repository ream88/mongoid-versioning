module Mongoid
  module Association
    module Cascading
      # Perform all cascading deletes, destroys, or nullifies. Will delegate to
      # the appropriate strategy to perform the operation.
      #
      # @example Execute cascades.
      #   document.cascade!
      #
      # @since 2.0.0.rc.1
      def cascade!
        cascades.each do |name|
          next unless !relation_metadata || !relation_metadata.versioned?
          if meta = relations[name]
            strategy = meta.cascade_strategy
            strategy.new(self, meta).cascade if strategy
          end
        end
      end
    end
  end
end
