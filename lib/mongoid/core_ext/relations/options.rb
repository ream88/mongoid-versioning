module Mongoid
  module Relations
    module Options
      common = COMMON
      send :remove_const, :COMMON
      send :const_set, :COMMON, common + [:versioned]
    end
  end
end
