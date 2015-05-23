require_relative '../lib/remote_model'
require_relative '../lib/queryable'
require_relative '../lib/api_client'
require_relative '../search/event_search'

module RescueGroups
  class Event
    include RemoteModel
    include Queryable
    include ApiClient

    class << self
      def object_type
        :events
      end

      def object_fields
        EventField
      end

      def search_engine_class
        EventSearch
      end
    end

    attr_accessor *object_fields::FIELDS.keys
  end
end
