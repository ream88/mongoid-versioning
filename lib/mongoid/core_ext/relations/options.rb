module Mongoid
  module Relations
    module Options  
      after = ([:versioned].concat(COMMON)).freeze
      remove_const(:COMMON)
      COMMON = after
    end
  end
end
