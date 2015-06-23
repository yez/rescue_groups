require_relative '../spec_helper'
require_relative '../../models/animal'

module RescueGroups
  describe Animal do
    describe 'organization' do
      context 'given an animal' do
        let(:animal) { a = Animal.new; a.organization_id = TEST_ORG_ID; a.organization = organization; a }

        context 'organization is not present' do
          let(:organization) { nil }

          it 'fetches the organization' do
            expect(animal.organization).to_not be_nil
          end

          it 'is an organization' do
            expect(animal.organization).to be_a(Organization)
          end
        end
      end
    end
  end
end
