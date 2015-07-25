require_relative '../../spec_helper'
require_relative '../../../lib/requests/where'

module RescueGroups
  module Requests
    describe Where do
      class TestFields
        FIELDS = {}
        def self.all; end
      end

      test_model = Struct.new('TestModel')
      test_client = Struct.new('TestClient')
      test_search_engine = Struct.new('TestSearchEngine')

      let(:conditions) { search_conditions }
      let(:search_conditions) { {} }

      describe '#initalize' do

        subject { described_class.new(conditions, anything, anything, anything) }

        it 'sets the conditions' do
          expect(subject.instance_variable_get(:@conditions)).to eq(search_conditions)
        end

        context 'with search modifiers present' do
          let(:limit) { 10 }
          let(:start) { 30 }
          let(:sort) { :breed }
          let(:order) { :asc }
          let(:conditions) { search_conditions.merge(limit: limit, start: start, sort: sort, order: order) }

          it 'does not include the modifiers in the search conditions' do
            expect(subject.instance_variable_get(:@conditions)).to eq(search_conditions)
          end

          context 'limit' do
            it 'sets an instance variable for the modifier' do
              expect(subject.instance_variable_get(:@limit)).to eq(limit)
            end
          end

          context 'start' do
            it 'sets an instance variable for the modifier' do
              expect(subject.instance_variable_get(:@start)).to eq(start)
            end
          end

          context 'sort' do
            it 'sets an instance variable for the modifier' do
              expect(subject.instance_variable_get(:@sort)).to eq(sort)
            end
          end

          context 'order' do
            it 'sets an instance variable for the modifier' do
              expect(subject.instance_variable_get(:@order)).to eq(order)
            end
          end
        end
      end

      describe '#request' do
        before do
          allow(test_model).to receive(:object_type)
          allow(test_model).to receive(:object_fields) { TestFields }
        end

        subject { described_class.new(conditions, test_model, test_client, anything) }

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
          allow(test_search_engine).to receive(:as_json)
        end

        subject { described_class.new(conditions, test_model, test_client, test_search_engine) }

        it 'has the correct keys' do
          json_result = subject.as_json

          expect(json_result).to have_key(:objectAction)
          expect(json_result).to have_key(:objectType)
          expect(json_result).to have_key(:search)
        end
      end
    end
  end
end
