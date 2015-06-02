require_relative '../spec_helper'
require_relative '../../models/animal'
require_relative '../support/model_spec'

module RescueGroups
  describe Animal do
    known_attributes = { animalID: 12, animalDeclawed: true, animalName: :snuffles }
    it_behaves_like 'a model', known_attributes

    describe '.find' do
      context 'animal is found' do
        it 'does not raise error' do
          expect do
            described_class.find(TEST_ANIMAL_ID)
          end.to_not raise_error
        end

        it 'finds and fills the animal' do
          animal = described_class.find(TEST_ANIMAL_ID)
          expect(animal.id.to_i).to eq(TEST_ANIMAL_ID)
        end
      end

      context 'animal is not found' do
        it 'raises an error' do
          expect do
            described_class.find(NOT_FOUND_ANIMAL_ID)
          end.to raise_error("Unable to find #{ described_class } with id: #{ NOT_FOUND_ANIMAL_ID }")
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
        let(:conditions) { { breed: TEST_ANIMAL_BREED } }

        it 'adds conditions to search' do
          expect_any_instance_of(AnimalSearch)
            .to receive(:add_filter)
            .with(:animalBreed, :equal, TEST_ANIMAL_BREED)

          allow_any_instance_of(RemoteClient)
            .to receive_message_chain(:post_and_respond, :success?) {true }

          allow_any_instance_of(RemoteClient)
            .to receive_message_chain(:post_and_respond, :[]) { [] }

          described_class.where(conditions)
        end

        context 'when animals are found' do
          it 'does not error' do
            expect do
              described_class.where(breed: TEST_ANIMAL_BREED)
            end.to_not raise_error
          end

          it 'sets the breed correctly' do
            animals = described_class.where(breed: TEST_ANIMAL_BREED)

            expect(animals).to_not eq([])

            animals.each do |animal|
              expect(animal.breed).to_not be_nil
            end
          end
        end

        context 'when animals are not found' do
          it 'does not error' do
            expect do
              described_class.where(breed: NOT_FOUND_ANIMAL_BREED)
            end.to_not raise_error
          end

          it 'returns an empty array' do
            animals = described_class.where(breed: NOT_FOUND_ANIMAL_BREED)
            expect(animals).to eq([])
          end
        end
      end
    end

    describe 'organization' do
      it 'defines #organization' do
        expect(subject).to respond_to(:organization)
      end

      it 'defines #organization=' do
        expect(subject).to respond_to(:organization=)
      end
    end
  end
end
