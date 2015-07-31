require_relative '../spec_helper'
require_relative '../support/model_spec'
require_relative '../../models/event'

module RescueGroups
  describe Event do
    known_attributes = begin
      { eventID: 12, eventName: 'Great Event!', eventDescription: 'This is the great event.' }
    end
    it_behaves_like 'a model', known_attributes

    describe '.find' do
      context 'event is found' do
        it 'does not raise error' do
          expect do
            described_class.find(TEST_EVENT_ID)
          end.to_not raise_error
        end

        it 'finds and fills the event' do
          event = described_class.find(TEST_EVENT_ID)
          expect(event.id.to_i).to eq(TEST_EVENT_ID)
        end
      end

      context 'event is not found' do
        it 'raises an error' do
          expect do
            described_class.find(NOT_FOUND_EVENT_ID)
          end.to raise_error("Unable to find #{ described_class } with id: #{ NOT_FOUND_EVENT_ID }")
        end
      end
    end

    describe '.where' do
      context 'when only id is present' do
        let(:id) { 1 }

        it 'calls find instead' do
          expect(described_class).to receive(:find).with(id)
          described_class.where(id: id)
        end
      end

      context 'with other conditions' do
        let(:conditions) { { name: TEST_EVENT_NAME } }

        it 'adds conditions to search' do
          expect_any_instance_of(EventSearch)
            .to receive(:add_filter)
            .with(:eventName, :equal, TEST_EVENT_NAME)

          allow_any_instance_of(RemoteClient)
            .to receive_message_chain(:post_and_respond, :success?) { true }

          allow_any_instance_of(RemoteClient)
            .to receive_message_chain(:post_and_respond, :[]) { {} }

          described_class.where(conditions)
        end

        context 'when events are found' do
          it 'does not error' do
            expect do
              described_class.where(name: TEST_EVENT_NAME)
            end.to_not raise_error
          end

          it 'sets the name correctly' do
            events = described_class.where(name: TEST_EVENT_NAME)

            expect(events).to_not eq([])

            events.each do |event|
              expect(event.name).to_not be_nil
            end
          end
        end

        context 'when events are not found' do
          it 'does not error' do
            expect do
              described_class.where(name: NOT_FOUND_EVENT_NAME)
            end.to_not raise_error
          end

          it 'returns an empty array' do
            events = described_class.where(name: NOT_FOUND_EVENT_NAME)
            expect(events).to eq([])
          end
        end
      end
    end

    describe 'organization' do
      it 'should define #organization' do
        expect(subject).to respond_to(:organization)
      end

      it 'should define #organization=' do
        expect(subject).to respond_to(:organization=)
      end
    end
  end
end
