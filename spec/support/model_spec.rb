require_relative '../spec_helper'

shared_examples 'a model' do |known_attributes|
  describe '#initialize' do
    subject { described_class.new(attributes) }

    context 'known attributes are set' do
    let(:attributes) { known_attributes }

      it 'sets the attributes' do
        known_attributes.each do |key, value|
          mapped_attribute = described_class.object_fields::FIELDS.key(key)
          expect(subject.send(mapped_attribute)).to eq(value)
        end
      end
    end

    context 'known and unknown attributes are present' do
      let(:attributes) do
        known_attributes.merge({ something_random: true })
      end

      it 'sets the attributes known' do
        known_attributes.each do |key, value|
          mapped_attribute = described_class.object_fields::FIELDS.key(key)
          expect(subject.send(mapped_attribute)).to eq(value)
        end
      end

      it 'does not include the uknown attributes' do
        expect(subject).to_not respond_to(:something_random)
      end
    end

    context 'only uknown attributes are present' do
      let(:attributes) { { something_random: true } }

      it 'does not set them' do
        expect(subject).to_not respond_to(:something_random)
      end

      it 'has empty attributes' do
        expect(subject.attributes.values.compact).to eq([])
      end
    end
  end
end
