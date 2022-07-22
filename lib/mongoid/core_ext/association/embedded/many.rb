module Mongoid
  module Association
    module Embedded
      class Many < Association::Many
        class << self
          # Get the valid options allowed with this relation.
          #
          # @example Get the valid options.
          #   Relation.valid_options
          #
          # @return [ Array<Symbol> ] The valid options.
          #
          # @since 2.1.0
          def valid_options
            [
              :as, :cascade_callbacks, :cyclic, :order, :versioned, :store_as,
              :before_add, :after_add, :before_remove, :after_remove
            ]
          end
        end
      end
    end
  end
end
