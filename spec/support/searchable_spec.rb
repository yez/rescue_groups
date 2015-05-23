require_relative '../spec_helper'

shared_examples 'a searchable' do
  describe '#as_json' do
    it 'has expected keys' do
      expect(subject.as_json).to include(:resultStart,
                                         :resultLimit,
                                         :resultSort,
                                         :resultOrder,
                                         :calcFoundRows,
                                         :filters,
                                         :fields)
    end
  end
end
