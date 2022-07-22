module Mongoid
  module Association
    module Relatable
      alias_method :validate_without_versioned!, :validate!

      # Monkey patching the validate method to removes the :versioned option
      # from the options hash.
      #
      # @param [ Hash ] options The options to validate.
      def validate!
        @orginal_options = @options.dup
        @options = @options.except(:versioned)
        validate_without_versioned!
        @options = @orginal_options
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
        !!@options[:versioned]
      end
    end
  end
end
