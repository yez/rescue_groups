require_relative '../spec_helper'
require_relative '../../models/organization'

describe Organization do
  describe '.find' do
    context 'org is found' do
      it 'does not raise error' do
        expect do
          described_class.find(TEST_ORG_ID)
        end.to_not raise_error
      end

      it 'finds and fills the organization' do
        org = described_class.find(TEST_ORG_ID)
        expect(org.id.to_i).to eq(TEST_ORG_ID)
      end
    end
  end
end
