module Mongoid
  module Association
    module Options
      # Is this relation using Mongoid's internal versioning system?
      #
      # @example Is this relation versioned?
      #   association.versioned?
      #
      # @return [ true, false ] If the relation uses Mongoid versioning.
      #
      # @since 2.1.0
      def versioned?
        !!self[:versioned]
      end
    end
  end
end
