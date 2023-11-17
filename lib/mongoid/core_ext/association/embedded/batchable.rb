module Mongoid
  module Association
    module Embedded
      module Batchable
        # Pre process the batch removal.
        #
        # @api private
        #
        # @example Pre process the documents.
        #   batchable.pre_process_batch_remove(docs, :delete)
        #
        # @param [ Array<Document> ] docs The documents.
        # @param [ Symbol ] method Delete or destroy.
        #
        # @return [ Array<Hash> ] The documents as hashes.
        #
        # @since 3.0.0
        def pre_process_batch_remove(docs, method)
          docs.map do |doc|
            self.path = doc.atomic_path unless path
            execute_callback :before_remove, doc
            if !_assigning? && !association.versioned?
              doc.apply_destroy_dependencies!
              doc.run_before_callbacks(:destroy) if method == :destroy
            end
            _target.delete_one(doc)
            _unscoped.delete_one(doc)
            unbind_one(doc)
            execute_callback :after_remove, doc
            doc.send(:as_attributes)
          end
        end
      end
    end
  end
end
