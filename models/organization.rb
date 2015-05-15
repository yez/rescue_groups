require_relative '../lib/remote_client'
require_relative '../search/organization_search'

module RescueGroups
  class Organization < RemoteClient
    class << self
      def find(ids)
        ids_array = [*ids].flatten

        find_body = post_body(:publicView).tap do |body|
          body[:fields] = OrganizationField.all
          body[:values] = ids_array.map { |i| { OrganizationField::FIELDS[:id] => i } }
        end

        response = post_and_respond(find_body)

        fail "Unable to find org with id: #{ ids }" unless response.success?

        orgs = response['data'].map {|o| new(o) }

        ids_array.length == 1 ? orgs.first : orgs
      end

      def where(conditions)
        return find(conditions[:id]) if conditions.keys == [:id]

        organization_search = OrganizationSearch.new

        conditions_to_filters(conditions) do |mapped_key, val|
          organization_search.add_filter(mapped_key, :equal, val)
        end

        where_body = post_body(:publicSearch).tap do |body|
          body[:search] = organization_search.as_json
        end

        response = post_and_respond(where_body)

        return [] unless response.success?

        response['data'].map do |_org_id, org_data|
          new(org_data)
        end
      end

      private

      def conditions_to_filters(conditions, &block)
        conditions.each do |key, value|
          mapped_key = OrganizationField::FIELDS[key.to_sym]
          next if mapped_key.nil?

          [*value].flatten.each do |val|
            yield mapped_key, val
          end
        end
      end

      def object_type
        'orgs'
      end
    end

    attr_accessor *OrganizationField::FIELDS.keys

    def initialize(attribute_hash)
      attribute_hash.each do |key, value|
        mapped_method = OrganizationField::FIELDS.key(key.to_sym)
        self.send("#{ mapped_method }=", value)
      end
    end
  end
end
