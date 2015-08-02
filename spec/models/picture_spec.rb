require_relative '../spec_helper'
require_relative '../../models/picture'

module RescueGroups
  describe Picture do
    describe '#initialize' do
      context 'given a list of rescue groups attributes' do
        let(:attributes) do
          {}.tap do |attrs|
            described_class::FIELDS.keys.sample(5).each do |key|
              attrs[key] = anything
            end
          end
        end

        it 'maps the attributes' do
          picture = described_class.new(attributes)

          attributes.keys.each do |attr_name|
            mapped_key = described_class::FIELDS[attr_name]
            expect(picture.send(mapped_key)).to_not be_nil
          end
        end

        context 'unknown attributes are present' do
          it 'does not map them' do
            picture = described_class.new(attributes.merge(foo: :bar))

            attributes.keys.each do |attr_name|
              mapped_key = described_class::FIELDS[attr_name]
              expect(picture.send(mapped_key)).to_not be_nil
            end

            expect(picture.instance_variable_get(:@foo)).to be_nil
          end
        end
      end

      context 'given a list of random attributes' do
        let(:attributes) {{ foo: :bar, baz: :qux }}

        it 'does not make any instance variables' do
          expect(described_class.new(attributes).instance_variables).to be_empty
        end
      end
    end
  end
end
