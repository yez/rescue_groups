require_relative '../../search/filter'

module RescueGroups
  describe Filter do
    subject { described_class.new(name, operation, criteria) }
    let(:name)      { 'some attribute' }
    let(:operation) { described_class::OPERATIONS.keys.sample }
    let(:criteria)  { 'the correct thing' }

    describe '#initialize' do
      it 'sets instance variables' do
        expect(subject.instance_variables).to include(:@name)
        expect(subject.name).to_not be_nil
        expect(subject.instance_variables).to include(:@operation)
        expect(subject.operation).to_not be_nil
        expect(subject.instance_variables).to include(:@criteria)
        expect(subject.criteria).to_not be_nil
      end

      context 'with an uknown operation' do
        let(:operation) { :banana }
        it 'raises an exception about an unknown operator' do
          expect do
            subject
          end.to raise_error
        end
      end
    end

    describe '#as_json' do
      context 'with valid attributes' do
        it 'returns a hash with all pertinent keys' do
          result = subject.as_json
          expect(result).to have_key(:fieldName)
          expect(result).to have_key(:operation)
          expect(result).to have_key(:criteria)
        end
      end

      context 'with a nil operation' do
        let(:operation) { nil }
        it 'raises an error' do
          expect do
            subject.as_json
          end.to raise_error(/Invalid operation given/)
        end
      end
    end
  end
end
