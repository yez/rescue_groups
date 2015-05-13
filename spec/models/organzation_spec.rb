require_relative '../spec_helper'
require_relative '../../models/organization'

describe Organization do
  describe '.find' do
    specify do
      expect(described_class.find(anything)).to eq(true)
    end
  end
end
