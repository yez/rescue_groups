require_relative '../lib/remote_model'
require_relative '../lib/queryable'
require_relative '../lib/api_client'
require_relative '../lib/relationable'
require_relative '../search/organization_search'

module RescueGroups
  class Organization
    include RemoteModel
    include Queryable
    include ApiClient
    include Relationable

    has_many :animals

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

    attr_accessor *object_fields::FIELDS.keys
  end
end
