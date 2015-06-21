require_relative '../spec_helper'
require_relative '../../models/organization'

module RescueGroups
  describe Organization do
    describe 'animals' do
      context 'given an organization' do
        let(:organization) { o = Organization.new; o.id = TEST_ORG_ID; o.animals =  animals; o }

        context 'the animals array does not exist in memory' do
          let(:animals) { [] }

          it 'fetches the animals' do
            expect(organization.animals).to_not be_empty
          end

          it 'is a list of animals' do
            organization.animals.each do |animal|
              expect(animal).to be_a(Animal)
            end
          end
        end
      end
    end
  end
end
