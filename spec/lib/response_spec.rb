require_relative '../spec_helper'
require_relative '../../lib/response'

module RescueGroups
  describe Response do
    subject { described_class.new(raw_response) }

    describe 'instance variables' do
      let(:raw_response) do
        Class.new(Object) do
          attr_reader :code
          def parsed_response; {}; end
        end.new
      end

      it 'has a parsed body' do
        expect(subject.instance_variables).to include(:@parsed_body)
      end

      it 'has an http status code' do
        expect(subject.instance_variables).to include(:@http_status_code)
      end
    end

    context 'a successful response' do
      let(:raw_response) do
        Class.new(Object) do
          attr_reader :code
          def parsed_response
            {
              'status' => "ok",
              'data' => []
            }
          end
        end.new
      end

      specify do
        expect(subject).to be_success
      end
    end

    context 'an errorful response' do
      let(:raw_response) do
        Class.new(Object) do
          attr_reader :code
          def parsed_response
            {
              'status' => "error",
              'data' => []
            }
          end
        end.new
      end

      specify do
        expect(subject).to_not be_success
      end
    end
  end
end
