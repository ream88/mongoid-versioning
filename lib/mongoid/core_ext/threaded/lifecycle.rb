module Mongoid
  module Threaded
    module Lifecycle
      private

      # Execute a block in loading revision mode.
      #
      # @example Execute in loading revision mode.
      #   _loading_revision do
      #     load_revision
      #   end
      #
      # @return [ Object ] The return value of the block.
      #
      # @since 2.3.4
      def _loading_revision
        Threaded.begin_execution('load_revision')
        yield
      ensure
        Threaded.exit_execution('load_revision')
      end

      module ClassMethods
        # Is the current thread in loading revision mode?
        #
        # @example Is the current thread in loading revision mode?
        #   proxy._loading_revision?
        #
        # @return [ true, false ] If the thread is loading a revision.
        #
        # @since 2.3.4
        def _loading_revision?
          Threaded.executing?('load_revision')
        end
      end
    end
  end
end
