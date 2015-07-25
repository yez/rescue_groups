module RescueGroups
  module Requests
    class Where
      def initialize(conditions, model, client, search_engine)
        modifiers = %i[limit start sort order]

        conditions.each do |key, value|
          if modifiers.include?(key.to_sym)
            instance_variable_set(:"@#{ key }", conditions.delete(key))
          end
        end

        @conditions = conditions
        @model = model
        @client = client
        @search_engine = search_engine
      end

      def request
        raise 'Improper client given to Requests::Find' unless @client.respond_to?(:post_and_respond)
        @client.post_and_respond(as_json)
      end

      def as_json(*)
        {
          objectAction: :publicSearch,
          objectType:   @model.object_type,
          search:       @search_engine.as_json,
        }
      end
    end
  end
end
