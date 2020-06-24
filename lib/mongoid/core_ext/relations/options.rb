module Mongoid
  module Relations
    module Options
      alias_method :validate_without_versioned!, :validate!

      def validate!(options)
        options_without_versioned = options.except(:versioned)
        validate_without_versioned!(options_without_versioned)
      end
    end
  end
end
