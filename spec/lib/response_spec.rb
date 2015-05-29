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

    describe '#success?' do
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
              JSON.parse(File.read("#{ File.dirname(__FILE__) }/../fixtures/error.json"))
            end
          end.new
        end

        specify do
          expect(subject).to_not be_success
        end
      end
    end

    describe '#error' do
      context 'errorful response' do
        let(:raw_response) do
          Class.new(Object) do
            attr_reader :code
            def parsed_response
              JSON.parse(File.read("#{ File.dirname(__FILE__) }/../fixtures/error.json"))
            end
          end.new
        end

        it 'returns the error message' do
          expect(subject.error).to_not be_nil
        end

        it 'does not return warning messages' do
          expect(subject.error).to_not match(/You provided an invalid result sort field/)
        end
      end

      context 'successful response' do
        let(:raw_response) do
          Class.new(Object) do
            attr_reader :code
            def parsed_response
              {
                'status' => 'ok',
                'data' => {}
              }
            end
          end.new
        end

        it 'returns nil ' do
          expect(subject.error).to be_nil
        end
      end
    end
  end
end
