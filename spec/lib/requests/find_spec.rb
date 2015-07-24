require_relative '../../spec_helper'
require_relative '../../../lib/requests/find'

module RescueGroups
  module Requests
    describe Find do
      class TestFields
        FIELDS = {}
        def self.all; end
      end

      test_model = Struct.new("TestModel")
      test_client = Struct.new("TestClient")

      describe '#initalize' do
        subject { described_class.new(ids, anything, anything) }

        let(:ids) { [1] }

        it 'sets @ids to the passed in value' do
          expect(subject.instance_variable_get(:@ids)).to eq(ids)
        end

        context 'a single id is given' do
          let(:ids) { 42 }

          it 'sets them correctly' do
            expect(subject.instance_variable_get(:@ids)).to eq([ids])
          end
        end

        context 'multiple ids are given' do
          let(:ids) { [120, 203, 399] }

          it 'sets them correctly' do
            expect(subject.instance_variable_get(:@ids)).to eq(ids)
          end

          context 'with duplicates' do
            let(:ids) { [101, 101, 120, 399, 120, 203, 399] }

            it 'removes the duplicates' do
              expect(subject.instance_variable_get(:@ids)).to eq(ids.uniq)
            end
          end
        end

        context 'something other than an integer or an array is given' do
          let(:ids) { Object.new }

          it 'raises error' do
            expect { subject }.to raise_error(/Only initialize a Requests::Find/)
          end
        end
      end

      describe '#request' do
        before do
          allow(test_model).to receive(:object_type)
          allow(test_model).to receive(:object_fields) { TestFields }
        end

        subject { described_class.new(1, test_model, test_client) }

        it 'composes the request given the passed in objects' do
          expect(subject.instance_variable_get(:@client)).to receive(:post_and_respond)
          expect(subject).to receive(:as_json)
          subject.request
        end

        context 'client is improper object' do
          it 'raises error' do
            expect { subject.request }.to raise_error(/Improper client/)
          end
        end
      end

      describe '#as_json' do
        before do
          allow(test_model).to receive(:object_type)
          allow(test_model).to receive(:object_fields) { TestFields }
        end

        subject { described_class.new(1, test_model, anything) }

        it 'has the correct keys' do
          json_result = subject.as_json

          expect(json_result).to have_key(:objectAction)
          expect(json_result).to have_key(:objectType)
          expect(json_result).to have_key(:fields)
          expect(json_result).to have_key(:values)
        end
      end
    end
  end
end
