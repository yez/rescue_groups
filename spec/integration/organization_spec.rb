require_relative '../spec_helper'
require_relative '../../models/organization'

module RescueGroups
  describe Organization do
    describe 'animals' do
      context 'given an organization' do
        let(:organization) { Organization.new(id: TEST_ORG_ID, animals: animals) }

        context 'the animals array does not exist in memory' do
          let(:animals) { [] }

          it 'fetches the animals' do
            expect(organization.animals).to_not be_empty
          end

          it 'is a list of animals with the correct organzation_id' do
            organization.animals.each do |animal|
              expect(animal).to be_a(Animal)
              expect(animal.organization_id).to eq(organization.id)
            end
          end
        end
      end
    end
  end
end
