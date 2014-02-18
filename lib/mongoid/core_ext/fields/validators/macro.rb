module Mongoid
  module Fields
    module Validators
      module Macro
        options = OPTIONS
        send :remove_const, :OPTIONS
        send :const_set, :OPTIONS, options + [:versioned]
      end
    end
  end
end
