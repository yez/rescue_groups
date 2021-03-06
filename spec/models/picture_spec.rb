require_relative '../spec_helper'
require_relative '../../models/picture'

module RescueGroups
  describe Picture do
    describe '#initialize' do
      context 'given a list of rescue groups attributes' do
        let(:attributes) do
          {}.tap do |attrs|
            PictureField::FIELDS.keys.sample(5).each do |key|
              attrs[key] = anything
            end
          end
        end

        it 'maps the attributes' do
          picture = described_class.new(attributes)

          attributes.keys.each do |attr_name|
            mapped_key = PictureField::FIELDS[attr_name]
            expect(picture.send(mapped_key)).to_not be_nil
          end
        end

        context 'unknown attributes are present' do
          it 'does not map them' do
            picture = described_class.new(attributes.merge(foo: :bar))

            attributes.keys.each do |attr_name|
              mapped_key = PictureField::FIELDS[attr_name]
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

    describe '#url' do
      context 'secure' do
        it 'calls the secure attribute' do
          expect(subject).to receive(:url_full)
          subject.url(secure: true)
        end
      end

      context 'default behaviour' do
        it 'calls the default attribute' do
          expect(subject).to receive(:insecure_url_full)
          subject.url
        end
      end
    end

    describe '#url_thumb' do
      context 'secure' do
        it 'calls the secure attribute' do
          expect(subject).to receive(:url_thumbnail)
          subject.url_thumb(secure: true)
        end
      end

      context 'default behaviour' do
        it 'calls the default attribute' do
          expect(subject).to receive(:insecure_url_thumb)
          subject.url_thumb
        end
      end
    end

    describe '#animal' do
      it { expect(subject).to respond_to(:animal) }
      it { expect(subject).to respond_to(:animal=) }
      it { expect(subject).to respond_to(:animal_id) }
      it { expect(subject).to respond_to(:animal_id=) }
    end
  end
end
