module RescueGroups
  module Requests
    class InvalidClient < StandardError; end

    class Find
      def initialize(ids, model, client)
        @ids = [*ids].flatten.uniq.map(&:to_i)
        @model = model
        @client = client
      rescue NoMethodError
        raise 'Only initialize a Requests::Find with integers or models responding to .to_i'
      end

      def request
        raise InvalidClient, 'Invalid client given to Requests::Find' unless @client.respond_to?(:post_and_respond)
        @client.post_and_respond(as_json)
      end

      def as_json(*)
        {
          objectAction: :publicView,
          objectType:   @model.object_type,
          fields:       @model.object_fields.all,
          values:       @ids.map { |i| { @model.object_fields::FIELDS[:id] => i } }
        }
      end
    end
  end
end
