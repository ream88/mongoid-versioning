module Mongoid
  module Hierarchy
    # Collect all the children of this document.
    #
    # @example Collect all the children.
    #   document.collect_children
    #
    # @return [ Array<Document> ] The children.
    #
    # @since 2.4.0
    def collect_children
      children = []
      embedded_relations.each_pair do |name, metadata|
        without_autobuild do
          child = send(name)
          Array.wrap(child).each do |doc|
            children.push(doc)
            children.concat(doc._children) unless metadata.versioned?
          end if child
        end
      end
      children
    end
  end
end
