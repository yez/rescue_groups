require_relative '../spec_helper'
require_relative '../../lib/queryable'

class TestClass
  FIELDS = {}
  include RescueGroups::Queryable
end

module RescueGroups
  describe Queryable do
    subject { TestClass.new }

    before do
      allow(TestClass).to receive(:object_type)
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
            TestClass.find(anything)
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
  end
end
