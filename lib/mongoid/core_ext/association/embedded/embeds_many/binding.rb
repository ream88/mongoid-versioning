module Mongoid
  module Association
    module Embedded
      class EmbedMany
        class Binding
          include Bindable

          # Binds a single document with the inverse relation. Used
          # specifically when appending to the proxy.
          #
          # @example Bind one document.
          #   person.addresses.bind_one(address)
          #
          # @param [ Document ] doc The single document to bind.
          # @param [ Hash ] options The binding options.
          #
          # @option options [ true, false ] :continue Continue binding the inverse.
          # @option options [ true, false ] :binding Are we in build mode?
          #
          # @since 2.0.0.rc.1
          def bind_one(doc)
            doc.parentize(_base)
            binding do
              unless metadata.versioned?
                doc.do_or_do_not(_association.inverse_setter(_target), base)
              end
            end
          end
        end
      end
    end
  end
end
