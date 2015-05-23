require_relative '../support/searchable_spec'
require_relative '../../search/organization_search'

module RescueGroups
  describe OrganizationSearch do
    it_behaves_like 'a searchable'
  end
end
