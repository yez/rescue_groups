require_relative '../spec_helper'
require_relative '../../models/animal'

module RescueGroups
  describe Animal do
    describe '#initialize' do
      subject { described_class.new(attributes) }

      context 'known attributes are set' do
        let(:attributes) do
          {
            animalID: 12,
            animalDeclawed: true,
            animalName: :snuffles
          }
        end

        it 'sets the attributes' do
          expect(subject.id).to_not be_nil
          expect(subject.declawed).to_not be_nil
          expect(subject.name).to_not be_nil
        end
      end

      context 'known and unknown attributes are present' do
        let(:attributes) do
          {
            animalID: 12,
            animalDeclawed: true,
            animalName: :snuffles,
            animalFluffy: true,
            animalSmelly: false,
          }
        end

        it 'sets the attributes known' do
          expect(subject.id).to_not be_nil
          expect(subject.declawed).to_not be_nil
          expect(subject.name).to_not be_nil
        end

        it 'does not include the uknown attributes' do
          expect(subject.attributes).to_not include(:animalFluffy)
          expect(subject.attributes).to_not include(:animalSmelly)
        end
      end

      context 'only uknown attributes are present' do
        let(:attributes) do
          {
            animalFluffy: true,
            animalSmelly: false,
          }
        end

        it 'does not set them' do
          expect(subject.attributes).to_not include(:animalFluffy)
          expect(subject.attributes).to_not include(:animalSmelly)
        end
      end
    end
  end
end
