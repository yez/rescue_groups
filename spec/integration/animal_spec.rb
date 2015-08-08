require_relative '../spec_helper'
require_relative '../../models/animal'

module RescueGroups
  describe Animal do
    describe 'organization' do
      context 'given an animal' do
        subject { a = Animal.new; a.organization_id = TEST_ORG_ID; a.organization = organization; a }

        context 'organization is not present' do
          let(:organization) { nil }

          it 'fetches the organization' do
            expect(subject.organization).to_not be_nil
          end

          it 'is an organization' do
            expect(subject.organization).to be_a(Organization)
          end
        end

        context 'organization is present' do
          let(:organization) { Organization.new }

          it 'does not call out to RescueGroups' do
            expect(described_class).to_not receive(:find)
            subject.organization
          end
        end
      end
    end

    describe 'pictures' do
      subject { described_class.find(TEST_ANIMAL_ID) }

      it 'has pictures with thumbnails' do
        subject.pictures.each do |picture|
          expect(picture.thumb).to_not be_nil
        end
      end

      it 'has pictures will full size images' do
        subject.pictures.each do |picture|
          expect(picture.full).to_not be_nil
        end
      end

      it 'all pictures have the right animal id' do
        subject.pictures.each do |picture|
          expect(picture.animal_id).to eq(TEST_ANIMAL_ID)
        end
      end
    end
  end
end
