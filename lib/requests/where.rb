module RescueGroups
  module Requests
    class Where
      def initialize(conditions, model, client)
        modifiers = %i[limit start sort order]

        conditions.each do |key, value|
          if modifiers.include?(key.to_sym)
            instance_variable_set(:"@#{ key }", conditions.delete(key))
          end
        end

        @conditions = conditions
        @model = model
        @client = client
      end
    end
  end
end
