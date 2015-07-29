require_relative '../../spec_helper'
require_relative '../../../lib/requests/where'

module RescueGroups
  module Requests
    describe Where do
      class TestFields
        FIELDS = { some_test_field: 'SomeTestField' }
        def self.all; end
      end

      class TestSearchEngine < Struct.new(:limit, :start, :sort, :order)
        def add_filter(*args)
        end
      end

      test_model = Struct.new('TestModel')
      test_client = Struct.new('TestClient')

      let(:conditions) { search_conditions }
      let(:search_conditions) { {} }

      describe '#initialize' do

        subject { described_class.new(conditions, anything, anything, TestSearchEngine) }

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

        it 'calls search_engine' do
          expect_any_instance_of(described_class).to receive(:build_search_engine)
          subject
        end
      end

      describe '#request' do
        before do
          allow(test_model).to receive(:object_type)
          allow(test_model).to receive(:object_fields) { TestFields }
          allow_any_instance_of(TestSearchEngine).to receive(:as_json)
        end

        subject { described_class.new(conditions, test_model, test_client, TestSearchEngine) }

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
          allow_any_instance_of(TestSearchEngine).to receive(:as_json)
        end

        subject { described_class.new(conditions, test_model, test_client, TestSearchEngine) }

        it 'has the correct keys' do
          json_result = subject.as_json

          expect(json_result).to have_key(:objectAction)
          expect(json_result).to have_key(:objectType)
          expect(json_result).to have_key(:search)
        end
      end

      describe '!#conditions_to_rescue_groups_key_value' do
        before do
          allow(test_model).to receive(:object_fields) { TestFields }
          allow_any_instance_of(TestSearchEngine).to receive(:add_filter)
        end

        subject { described_class.new(conditions, test_model, test_client, TestSearchEngine) }

        context 'all filters have mappings' do
          let(:conditions) { { some_test_field: value } }
          let(:value)      { 'foo' }

          it 'yields to the block for all filters' do
            expect do |b|
              subject.send(:conditions_to_rescue_groups_key_value, &b)
            end.to yield_with_args('SomeTestField', value)
          end
        end

        context 'some filters have mappings, others do not' do
          let(:conditions) { { some_test_field: value, another_test_field: anything } }
          let(:value)      { 'foo' }

          it 'yields to the block only for mapped filters' do
            expect do |b|
              subject.send(:conditions_to_rescue_groups_key_value, &b)
            end.to yield_with_args('SomeTestField', value)
          end
        end

        context 'no filters have mappings' do
          let(:conditions) { { foo: :bar } }
          it 'does not yield to the block' do
            expect do |b|
              subject.send(:conditions_to_rescue_groups_key_value, &b)
            end.to_not yield_control
          end
        end

        context 'no block is given' do
          it 'raises an error' do
            expect do
              subject.send(:conditions_to_rescue_groups_key_value)
            end.to raise_error(/Block not given/)
          end
        end
      end

      describe '!#build_search_engine' do
        subject { described_class.new(conditions, anything, anything, TestSearchEngine) }

        let(:instance_vars_to_set) { {} }

        before do
          instance_vars_to_set.each do |key, value|
            subject.instance_variable_set(:"@#{ key }", value)
          end
        end

        context 'modifiers exist in conditions' do
          context 'multiple modifiers' do
            let(:instance_vars_to_set) { { limit: 100, start: 100 } }

            it 'initializes searh engine with all modifiers' do
              expect(TestSearchEngine).to receive(:new).with(limit: 100, start: 100)
              subject.send(:build_search_engine, TestSearchEngine)
            end
          end

          context 'a single modifier' do
            let(:instance_vars_to_set) { { limit: 10 } }

            it 'initializes searh engine with the modifier' do
              expect(TestSearchEngine).to receive(:new).with(limit: 10)
              subject.send(:build_search_engine, TestSearchEngine)
            end
          end
        end

        context 'modifiers do not exist in the conditions' do
          it 'initializes searh engine without any args' do
            subject
            expect(TestSearchEngine).to receive(:new).with({})
            subject.send(:build_search_engine, TestSearchEngine)
          end
        end
      end

      describe '!#add_filters_to_search_engine' do
        subject { described_class.new(conditions, anything, anything, TestSearchEngine) }

        context 'conditions are not empty' do
          let(:conditions) { { foo: :bar } }

          before do
            allow_any_instance_of(described_class)
              .to receive(:conditions_to_rescue_groups_key_value).with(no_args).and_yield(:foo, :bar)
          end

          it 'calls add_filter per condition' do
            subject
            expect_any_instance_of(TestSearchEngine)
              .to receive(:add_filter).with(:foo, :equal, :bar)
            subject.send(:add_filters_to_search_engine, TestSearchEngine.new)
          end
        end

        context 'conditions are empty' do
          it 'does not call add_filter' do
            expect_any_instance_of(TestSearchEngine).to_not receive(:add_filter)
            subject.send(:add_filters_to_search_engine, TestSearchEngine.new)
          end
        end
      end
    end
  end
end
