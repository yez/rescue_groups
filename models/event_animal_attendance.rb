require_relative '../lib/remote_model'
require_relative '../lib/queryable'
require_relative '../lib/api_client'
require_relative '../search/event_animal_attendance_search'

module RescueGroups
  class EventAnimalAttendance
    include RemoteModel
    include Queryable
    include ApiClient

    class << self
      def object_type
        :eventanimalattendance
      end

      def object_fields
        EventAnimalAttendance
      end

      def search_engine_class
        EventAnimalAttendanceSearch
      end
    end

    attr_accessor *object_fields::FIELDS.keys
  end
end
