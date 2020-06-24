module Mongoid
  module Relations
    module Options
      # The COMMON const is frozen since mongoid v6,
      # and there is no easy way to override the common
      # list of options for the relations being used inside
      # the +validate!+ method. This hack solves it.
      COMMON = self::COMMON + [:versioned]
      COMMON.freeze
    end
  end
end
