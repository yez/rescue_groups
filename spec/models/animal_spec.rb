require_relative '../spec_helper'
require_relative '../../models/animal'

module RescueGroups
  describe Animal do
    known_attributes = { animalID: 12, animalDeclawed: true, animalName: :snuffles }
    it_behaves_like 'a model', known_attributes

    describe '#initialize' do
      context 'picture are present' do

        it 'extracts them' do
          expect_any_instance_of(described_class).to receive(:extract_pictures)
          described_class.find(TEST_ANIMAL_ID)
        end

        it 'is actual pictures' do
          animal = described_class.find(TEST_ANIMAL_ID)
          expect(animal.pictures).to_not be_empty
          expect(animal.pictures.all? { |p| p.is_a?(Picture) }).to eq(true)
        end
      end
    end

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
            .with(:animalBreed, :equal, TEST_ANIMAL_BREED).and_call_original

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

    describe '!#extract_pictures' do
      let(:picture_attribute) { described_class.object_fields::FIELDS[:pictures] }
      let(:pictures) { [{ test: :picture }, { foo: :bar }, { baz: :qux }] }

      it 'intializes a new picture class per picture' do
        pictures.each do |picture|
          expect(RescueGroups::Picture).to receive(:new).with(picture).and_call_original
        end

        described_class.new(picture_attribute => pictures)
      end

      it 'turns the @pictures for the model into pictures' do
        model = described_class.new(picture_attribute => pictures)
        expect(model.pictures.all? { |p| p.is_a?(RescueGroups::Picture) }).to eq(true)
      end
    end
  end
end
