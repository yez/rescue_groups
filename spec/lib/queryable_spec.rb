require_relative '../spec_helper'
require_relative '../../lib/queryable'

class TestClass
  FIELDS = { some_test_field: 'SomeTestField' }
  include RescueGroups::Queryable

  def initialize(anything)
  end

  def self.search_engine_class
    TestSearch
  end

  def self.object_type;end

  def self.object_fields
    TestClass
  end

  def self.fields
    FIELDS
  end
end

class TestSearch < RescueGroups::BaseSearch
  def self.fields
    {}
  end
end

module RescueGroups
  describe Queryable do
    subject { TestClass.new }

    before do
      allow(TestClass).to receive(:object_fields) { TestClass }
      allow(TestClass).to receive_message_chain(:object_fields, :all)
    end

    describe '.find' do
      before do
        allow(TestClass)
          .to receive_message_chain(:api_client, :post_and_respond) { response }
      end

      context 'response is successful' do
        let(:response) do
          TestResponse.new(200,
            { 'status' => 'ok', 'data' => data })
        end

        before do
          allow(response).to receive(:success?) { true }
        end

        context 'data is returned' do
          let(:data) { [{ foo: :bar }] }

          it 'calls new with the data' do
            expect(TestClass).to receive(:new).with(data.first)
            response = TestClass.find(anything)
            expect(response).to_not be_a(Array)
          end

          context 'multiple ids are returned' do
            let(:data) { [{ foo: :bar }, { baz: :qux }] }

            it 'returns an array of objects' do
              expect(TestClass).to receive(:new).twice
              response = TestClass.find([anything, anything])
              expect(response).to be_a(Array)
              expect(response.length).to eq(2)
            end
          end
        end

        context 'no data is returned' do
          let(:data) { nil }
          it 'raises an exception' do
            expect do
              TestClass.find(anything)
            end.to raise_error(/Unable to find/)
          end
        end
      end

      context 'response is not successful' do
        let(:response) do
          TestResponse.new(200,
            { 'status' => 'error', 'data' => [{ foo: :bar }] })
        end

        it 'raises an exception' do
          expect do
            TestClass.find(anything)
          end.to raise_error(/Unable to find/)
        end
      end
    end

    describe '.where' do
      context 'automatic offsets' do
        context 'returned data row count is larger than the limit' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'ok', 'found_rows' => 3000, 'data' => { anything => [anything]}})
          end

          before do
            api_client = Object.new
            allow(api_client).to receive(:post_and_respond) { response}
            allow(TestClass).to receive(:api_client) { api_client }
            allow(response).to receive(:success?) { true }
          end

          it 'makes additonal requests with an offset until the row count is met' do
            expect(TestClass.api_client).to receive(:post_and_respond)
                                        .exactly(31).times
            TestClass.where(anything: anything)
          end
        end
      end

      context 'basic behaviour' do
        before do
          allow(TestClass)
            .to receive_message_chain(:api_client, :post_and_respond) { response }
        end

        context 'response is successful' do
          context 'data is returned' do
            let(:response) do
              TestResponse.new(200,
                { 'status' => 'ok', 'data' => { id: anything, another_id: anything } })
            end

            it 'returns the data as an array' do
              expect(TestClass).to receive(:new).twice
              response = TestClass.where(anything: anything)
              expect(response).to be_a(Array)
            end
          end

          context 'no data is returned' do
            let(:response) do
              TestResponse.new(200,
                { 'status' => 'ok', 'data' => { } })
            end

            it 'returns an empty array' do
              response = TestClass.where(anything: anything)
              expect(response).to eq([])
            end
          end
        end

        context 'response is not successful' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'error', 'data' => nil })
          end

          it 'raises error' do
            expect do
              TestClass.where(anything: anything)
            end.to raise_error(/Problem with request/)
          end
        end
      end

      context 'querying with something besides equals to' do
        let(:response) do
          TestResponse.new(200,
            { 'status' => 'ok', 'data' => { id: anything, another_id: anything } })
        end
        let(:equality_filter) { { less_than: 1 } }

        before do
          allow(TestClass)
            .to receive_message_chain(:api_client, :post_and_respond) { response }
          allow(TestClass)
            .to receive(:where_body) { {} }
        end

        it 'makes a filter with the mapped equality method' do
          expect(Filter).to receive(:new).with("SomeTestField", :less_than, 1)
          TestClass.where(some_test_field: equality_filter)
        end
      end

      describe 'result set modifiers' do
        context 'limit' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'ok', 'data' => { id: anything, another_id: anything } })
          end

          before do
            allow(TestClass)
              .to receive_message_chain(:api_client, :post_and_respond) { response }
          end

          it 'passes the limit to the search engine' do
            expect(TestSearch).to receive(:new).with(limit: 10).and_call_original
            TestClass.where(anything: anything, limit: 10)
          end
        end

        context 'start' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'ok', 'data' => { id: anything, another_id: anything } })
          end

          before do
            allow(TestClass)
              .to receive_message_chain(:api_client, :post_and_respond) { response }
          end

          it 'passes the limit to the search engine' do
            expect(TestSearch).to receive(:new).with(start: 10).and_call_original
            TestClass.where(anything: anything, start: 10)
          end
        end

        context 'sort' do
          let(:response) do
            TestResponse.new(200,
              { 'status' => 'ok', 'data' => { id: anything, another_id: anything } })
          end

          before do
            allow(TestClass)
              .to receive_message_chain(:api_client, :post_and_respond) { response }
          end

          it 'passes the limit to the search engine' do
            expect(TestSearch).to receive(:new).with(sort: :breed).and_call_original
            TestClass.where(anything: anything, sort: :breed)
          end
        end
      end
    end

    describe '!.key_to_rescue_groups_key' do
      context 'all filters have mappings' do
        let(:conditions) { { some_test_field: value } }
        let(:value)      { 'foo' }

        it 'yields to the block for all filters' do
          expect do |b|
            TestClass.send(:key_to_rescue_groups_key, conditions, &b)
          end.to yield_with_args('SomeTestField', value)
        end
      end

      context 'some filters have mappings, others do not' do
        let(:conditions) { { some_test_field: value, another_test_field: anything } }
        let(:value)      { 'foo' }

        it 'yields to the block only for mapped filters' do
          expect do |b|
            TestClass.send(:key_to_rescue_groups_key, conditions, &b)
          end.to yield_with_args('SomeTestField', value)
        end
      end

      context 'no filters have mappings' do
        let(:conditions) { { foo: :bar } }
        it 'does not yield to the block' do
          expect do |b|
            TestClass.send(:key_to_rescue_groups_key, conditions, &b)
          end.to_not yield_control
        end
      end

      context 'no block is given' do
        it 'raises an error' do
          expect do
            TestClass.send(:key_to_rescue_groups_key, anything)
          end.to raise_error(/Block not given/)
        end
      end
    end
  end
end
