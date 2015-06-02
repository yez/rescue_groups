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

      private

      def symbol_to_class(symbol)
        return if symbol.nil?
        class_name = symbol.to_s.split('_').map do |part|
          "#{ (part[0].ord - CAPITAL_OFFSET).to_i.chr }#{ part[1..-1] }"
        end.join

        Object.const_get("RescueGroups::#{ class_name }")
      end
    end
  end
end
