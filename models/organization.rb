require_relative '../lib/queryable'
require_relative '../lib/api_client'
require_relative '../search/organization_search'

module RescueGroups
  class Organization
    include ApiClient
    include Queryable

    class << self
      def object_type
        :orgs
      end

      def object_fields
        OrganizationField
      end

      def search_engine_class
        OrganizationSearch
      end
    end

    attr_accessor *OrganizationField::FIELDS.keys

    def initialize(attribute_hash)
      attribute_hash.each do |key, value|
        mapped_method = "#{ OrganizationField::FIELDS.key(key.to_sym) }="
        next unless self.respond_to?(mapped_method)
        self.send(mapped_method, value)
      end
    end

    def attributes
      {}.tap do |hash|
        OrganizationField::FIELDS.keys.each do |attribute|
          hash[attribute] = instance_variable_get(:"@#{ attribute }")
        end
      end
    end
  end
end
