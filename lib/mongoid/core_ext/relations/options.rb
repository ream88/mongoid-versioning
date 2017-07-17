module Mongoid
  module Relations
    module Options
      VERSIONED_OPTIONS  = [:versioned].freeze

      def validate!(options)
        valid_options = options[:relation]::VALID_OPTIONS + COMMON + VERSIONED_OPTIONS
        options.keys.each do |key|
          if !valid_options.include?(key)
            raise Errors::InvalidOptions.new(
              options[:name],
              key,
              valid_options
            )
          end
        end
        true
      end
    end
  end
end
