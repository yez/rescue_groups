require_relative '../lib/remote_model'
require_relative '../lib/queryable'
require_relative '../lib/relationable'
require_relative '../search/organization_search'

module RescueGroups
  class Organization
    include RemoteModel
    include Queryable
    include Relationable

    has_many :animals

    class << self
      # method :object_type
      # purpose: Define this class's object_type used by the
      #            the Queryable module when composing remote queries
      # param: none
      # return: <Symbol> - the value of the object_type
      def object_type
        :orgs
      end

      # method :object_fields
      # purpose: Define this class's object fields class used by the
      #            the Queryable module when composing remote queries
      # param: none
      # return: <Constant> - the class containing the list of fields
      #                        pertinent to this class
      def object_fields
        OrganizationField
      end

      # method :search_engine_class
      # purpose: Define which search engine is used by the class. The Queryable
      #           module uses the search engine when constructing remote queries to make
      #
      # param: none
      # return: <Constant> - the class that contains search data pertinent to this class
      def search_engine_class
        OrganizationSearch
      end
    end

    attr_accessor *object_fields::FIELDS.keys
  end
end
