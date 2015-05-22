require_relative '../../search/organization_search'

module RescueGroups
  describe OrganizationSearch do
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
