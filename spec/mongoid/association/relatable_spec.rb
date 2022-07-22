require 'spec_helper'

describe Mongoid::Association::Relatable do
  describe '#versioned?' do
    context 'when versioned is true' do
      let(:association) do
        Mongoid::Association::Embedded::EmbedsMany.new(
          Address,
          :versions,
          versioned: true
        )
      end

      it 'returns true' do
        expect(association).to be_versioned
      end
    end

    context 'when versioned is false' do
      let(:association) do
        Mongoid::Association::Embedded::EmbedsMany.new(
          Address,
          :versions,
          versioned: false
        )
      end

      it 'returns false' do
        expect(association).not_to be_versioned
      end
    end

    context 'when versioned is nil' do
      let(:association) do
        Mongoid::Association::Embedded::EmbedsMany.new(
          Address,
          :versions
        )
      end

      it 'returns false' do
        expect(association).not_to be_versioned
      end
    end
  end
end
