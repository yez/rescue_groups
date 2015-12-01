require_relative '../spec_helper'
require_relative '../../models/organization'

module RescueGroups
  describe Organization do
    known_attributes = { orgCountry: 'USA', orgName: 'That one dog house'}
    it_behaves_like 'a model', known_attributes

    describe '.find' do
      context 'org is found' do
        it 'does not raise error' do
          expect do
            described_class.find(TEST_ORG_ID)
          end.to_not raise_error
        end

        it 'finds and fills the organization' do
          org = described_class.find(TEST_ORG_ID)
          expect(org.id.to_i).to eq(TEST_ORG_ID)
        end
      end

      context 'org is not found' do
        it 'raises an error' do
          expect do
            described_class.find(NOT_FOUND_ORG_ID)
          end.to raise_error("Unable to find #{ described_class } with id: #{ NOT_FOUND_ORG_ID }")
        end
      end
    end

    describe '.where' do
      context 'when only id is present' do
        let(:id) { 1 }

        it 'calls find instead' do
          expect(described_class).to receive(:find).with(id)
          described_class.where(id: id)
        end
      end

      context 'with other conditions' do
        let(:conditions) do
          {
            name: 'test name',
            location_city: 'test city',
          }
        end

        it 'adds conditions to search' do
          expect_any_instance_of(OrganizationSearch)
            .to receive(:add_filter)
            .with(:orgName, :equal, 'test name')

          expect_any_instance_of(OrganizationSearch)
            .to receive(:add_filter)
            .with(:orgCity, :equal, 'test city')

          allow_any_instance_of(RemoteClient)
            .to receive_message_chain(:post_and_respond, :success?) { true }

          allow_any_instance_of(RemoteClient)
            .to receive_message_chain(:post_and_respond, :[]) { {} }

          described_class.where(conditions)
        end

        context 'when orgs are found' do
          it 'does not error' do
            expect do
              described_class.where(name: TEST_ORG_NAME)
            end.to_not raise_error
          end

          it 'sets the names correctly' do
            orgs = described_class.where(name: TEST_ORG_NAME)

            expect(orgs).to_not eq([])

            orgs.each do |org|
              expect(org.name).to_not be_nil
            end
          end
        end

        context 'when orgs are not found' do
          it 'does not error' do
            expect do
              described_class.where(name: NOT_FOUND_ORG_NAME)
            end.to_not raise_error
          end

          it 'returns an empty array' do
            orgs = described_class.where(name: NOT_FOUND_ORG_NAME)
            expect(orgs).to eq([])
          end
        end
      end
    end

    describe '#animals' do
      it 'defines #animals' do
        expect(subject).to respond_to(:animals)
      end

      it 'defines #animals=' do
        expect(subject).to respond_to(:animals=)
      end
    end
  end
end
