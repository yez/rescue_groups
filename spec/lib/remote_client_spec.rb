require_relative '../spec_helper'
require_relative '../../lib/remote_client'

module RescueGroups
  describe RemoteClient do
    describe '#post_and_respond' do
      let(:connection) { instance_double(Faraday::Connection) }

      before do
        allow(Response).to receive(:new)
        allow(subject).to receive(:connection) { connection }
      end

      it 'calls the class post on the connection' do
        expect(connection).to receive(:post)
        subject.post_and_respond({})
      end

      context 'with no api key' do
        before do
          allow(RescueGroups.config).to receive(:apikey) { nil }
        end

        it 'raises an error' do
          expect { subject.post_and_respond({}) }.to raise_error('No RescueGroups API Key set')
        end
      end
    end
  end
end
