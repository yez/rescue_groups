require_relative '../../search/animal_search'

module RescueGroups
  describe AnimalSearch do
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
end
