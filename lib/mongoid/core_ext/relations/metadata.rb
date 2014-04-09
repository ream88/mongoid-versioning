module Mongoid
  module Relations
    class Metadata < Hash
      # Since a lot of the information from the metadata is inferred and not
      # explicitly stored in the hash, the inspection needs to be much more
      # detailed.
      #
      # @example Inspect the metadata.
      #   metadata.inspect
      #
      # @return [ String ] Oodles of information in a nice format.
      #
      # @since 2.0.0.rc.1
      def inspect
%Q{#<Mongoid::Relations::Metadata
  autobuild:    #{autobuilding?}
  class_name:   #{class_name}
  cyclic:       #{cyclic.inspect}
  counter_cache:#{counter_cached?}
  dependent:    #{dependent.inspect}
  inverse_of:   #{inverse_of.inspect}
  key:          #{key}
  macro:        #{macro}
  name:         #{name}
  order:        #{order.inspect}
  polymorphic:  #{polymorphic?}
  relation:     #{relation}
  setter:       #{setter}
  versioned:    #{versioned?}>
}
      end

      # Is this relation using Mongoid's internal versioning system?
      #
      # @example Is this relation versioned?
      #   metadata.versioned?
      #
      # @return [ true, false ] If the relation uses Mongoid versioning.
      #
      # @since 2.1.0
      def versioned?
        !!self[:versioned]
      end

      # Get the inverse relation candidates.
      #
      # @api private
      #
      # @example Get the inverse relation candidates.
      #   metadata.inverse_relation_candidates
      #
      # @return [ Array<Metdata> ] The candidates.
      #
      # @since 3.0.0
      def inverse_relation_candidates
        relations_metadata.select do |meta|
          next if meta.versioned? || meta.name == name
          meta.class_name == inverse_class_name
        end
      end
    end
  end
end
