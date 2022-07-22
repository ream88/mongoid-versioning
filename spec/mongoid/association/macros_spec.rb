require 'spec_helper'

describe Mongoid::Association::Macros do
  describe '.embedded_in' do
    context 'when the document is versioned' do
      it 'raises an error' do
        expect do
          Class.new do
            include Mongoid::Document
            include Mongoid::Versioning
            embedded_in :parent_class
          end
        end.to raise_error(Mongoid::Errors::VersioningNotOnRoot)
      end
    end
  end
end
