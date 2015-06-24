require_relative '../spec_helper'
require_relative '../../models/event'

module RescueGroups
  describe Event do
    describe 'organization' do
      context 'given an event' do
        let(:event) { e = Event.new; e.organization_id = TEST_ORG_ID; e.organization = organization; e }

        context 'organization is not present' do
          let(:organization) { nil }

          it 'fetches the organization' do
            expect(event.organization).to_not be_nil
          end

          it 'is an organization' do
            expect(event.organization).to be_a(Organization)
          end
        end
      end
    end
  end
end
