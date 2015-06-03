require_relative '../lib/remote_model'
require_relative '../lib/queryable'
require_relative '../lib/relationable'
require_relative '../search/animal_search'

module RescueGroups
  class Animal
    include RemoteModel
    include Queryable
    include Relationable

    belongs_to :organization

    class << self
      def object_type
        :animals
      end

      def object_fields
        AnimalField
      end

      def search_engine_class
        AnimalSearch
      end
    end

    attr_accessor *object_fields::FIELDS.keys
  end
end
