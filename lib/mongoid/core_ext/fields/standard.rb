module Mongoid
  module Fields
    class Standard
      # Is this field included in versioned attributes?
      #
      # @example Is the field versioned?
      #   field.versioned?
      #
      # @return [ true, false ] If the field is included in versioning.
      #
      # @since 2.1.0
      def versioned?
        @versioned ||= (options[:versioned].nil? ? true : options[:versioned])
      end
    end
  end
end
