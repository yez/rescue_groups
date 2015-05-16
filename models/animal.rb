require_relative '../lib/queryable'
require_relative '../lib/api_client'
require_relative '../search/animal_search'

module RescueGroups
  class Animal
    include Queryable
    include ApiClient

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

    attr_accessor *AnimalField::FIELDS.keys

    def initialize(attribute_hash)
      attribute_hash.each do |key, value|
        mapped_method = "#{ AnimalField::FIELDS.key(key.to_sym) }="
        next unless self.respond_to?(mapped_method)
        self.send(mapped_method, value)
      end
    end

    def attributes
      {}.tap do |hash|
        AnimalField::FIELDS.keys.each do |attribute|
          hash[attribute] = instance_variable_get(:"@#{ attribute }")
        end
      end
    end
  end
end
