require_relative '../spec_helper'
require_relative '../../lib/response'

module RescueGroups
  describe Response do
    subject { described_class.new(raw_response) }

    let(:status) { 200 }
    let(:body) { '{}' }
    let(:raw_response) { instance_double(Faraday::Response, status: status, body: body) }

    describe 'instance variables' do
      it 'has a parsed body' do
        expect(subject.instance_variables).to include(:@parsed_body)
      end

      it 'has an http status code' do
        expect(subject.instance_variables).to include(:@http_status_code)
      end
    end

    describe '#success?' do
      context 'a successful response' do
        let(:body) { { 'status' => "ok", 'data' => [] }.to_json }

        specify do
          expect(subject).to be_success
        end
      end

      context 'an errorful response' do
        let(:body) { File.read("#{ File.dirname(__FILE__) }/../fixtures/error.json") }

        specify do
          expect(subject).to_not be_success
        end
      end
    end

    describe '#error' do
      context 'errorful response' do
        let(:body) { File.read("#{ File.dirname(__FILE__) }/../fixtures/error.json") }

        it 'returns the error message' do
          expect(subject.error).to_not be_nil
        end

        it 'does not return warning messages' do
          expect(subject.error).to_not match(/You provided an invalid result sort field/)
        end
      end

      context 'successful response' do
        let(:body) { { 'status' => "ok", 'data' => [] }.to_json }

        it 'returns nil ' do
          expect(subject.error).to be_nil
        end
      end
    end
  end
end
