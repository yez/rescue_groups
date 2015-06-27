require_relative '../spec_helper'
require_relative '../../models/organization'

module RescueGroups
  describe Organization do
    describe 'animals' do
      context 'given an organization' do
        subject { o = Organization.new; o.id = TEST_ORG_ID; o.animals =  animals; o }

        context 'the animals array does not exist in memory' do
          let(:animals) { [] }

          it 'fetches the animals' do
            expect(subject.animals).to_not be_empty
          end

          it 'is a list of animals' do
            subject.animals.each do |animal|
              expect(animal).to be_a(Animal)
            end
          end
        end

        context 'animals are present' do
          let(:animals) { [Animal.new] }

          it 'does not call out to RescueGroups' do
            expect(Animal).to_not receive(:where)
            subject.animals
          end
        end
      end
    end
  end
end
