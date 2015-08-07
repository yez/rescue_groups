require_relative '../spec_helper'
require_relative '../../lib/relationable'

module RescueGroups
  class OtherClass;end

  class YetAnotherClass
    def self.where(anything); [] end
  end

  class IncludedClass
    include Relationable
    belongs_to :other_class
    has_many :yet_another_classes

    def initialize(other_class:, yet_another_classes:)
      self.other_class         = other_class
      self.yet_another_classes = yet_another_classes
    end
  end

  describe 'Relationable' do
    subject { IncludedClass.new(other_class: other_class, yet_another_classes: yet_another_classes) }
    let(:other_class)         { nil }
    let(:yet_another_classes) { nil }

    describe '#belongs_to' do
      it 'makes a setter method' do
        expect(subject).to respond_to(:other_class=)
      end

      it 'makes a getter method' do
        expect(subject).to respond_to(:other_class)
      end

      it 'makes a setter relationship_id method' do
        expect(subject).to respond_to(:other_class_id=)
      end

      it 'makes a getter relationship_id method' do
        expect(subject).to respond_to(:other_class_id)
      end

      context 'relationship model exists' do
        let(:other_class) { OtherClass.new }
        it 'returns a model of the specified class' do
          expect(subject.other_class).to be_a(OtherClass)
        end
      end

      context 'relationship model is nil' do
        it 'returns nil' do
          expect(subject.other_class).to be_nil
        end
      end

      context 'relationship_id is set model is not present' do
        let(:other_class_id) { 1 }
        it 'fetches the model' do
          subject.other_class_id = other_class_id
          expect(OtherClass).to receive(:find).with(other_class_id)
          subject.other_class
        end
      end
    end

    describe '#has_many' do
      it 'makes a setter method' do
        expect(subject).to respond_to(:yet_another_classes=)
      end

      it 'makes a getter method' do
        expect(subject).to respond_to(:yet_another_classes)
      end

      context 'relationship models exist' do
        let(:yet_another_class)   { YetAnotherClass.new }
        let(:yet_another_classes) { [yet_another_class] }

        context 'one model exists' do
          it 'returns an array of size 1' do
            expect(subject.yet_another_classes.length).to eq(1)
          end

          it 'the model in the relationship is of the specified class' do
            subject.yet_another_classes.each do |yac|
              expect(yac).to be_a(YetAnotherClass)
            end
          end
        end

        context 'more than one model exists' do
          let(:yet_another_classes) { [YetAnotherClass.new, YetAnotherClass.new] }
          it 'returns an array the size of the relationship' do
            expect(subject.yet_another_classes.length).to eq(2)
          end

          it 'all models in the relationship are of the specified class' do
            subject.yet_another_classes.each do |yac|
              expect(yac).to be_a(YetAnotherClass)
            end
          end
        end
      end

      context 'relationship model does not exist' do
        it 'returns an empty array' do
          expect(subject.yet_another_classes).to eq([])
        end
      end
    end
  end
end
