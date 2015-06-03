module RescueGroups
  module Relationable
    CAPITAL_OFFSET = 32

    def self.included(base)
      base.extend(ClassMethods)
    end

    module ClassMethods
      def belongs_to(relationship)
        define_method relationship do
          instance_variable_get(:"@#{ relationship }")
        end

        define_method :"#{ relationship }=" do |value|
          instance_variable_set(:"@#{ relationship }", value)
        end
      end

      def has_many(relationship)
        define_method relationship do
          instance_variable_get(:"@#{ relationship }") || []
        end

        define_method :"#{ relationship }=" do |value|
          instance_variable_set(:"@#{ relationship }", value)
        end
      end
    end
  end
end
