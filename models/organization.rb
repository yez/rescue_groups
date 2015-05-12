require_relative '../lib/remote_client'
require_relative '../search/organization_search'

class Organization < RemoteClient
  class << self
    def find(ids)
      ids_array = [*ids].flatten

      find_body = post_body(:publicView).tap do |body|
        body[:fields] = OrganizationField.all
        body[:values] = ids_array.map { |i| { OrganizationField::FIELDS[:id] => i} }
      end

      post_and_respond(find_body)
    end

    def where(conditions)
      organization_search = OrganizationSearch.new

      conditions.each do |key, value|
        mapped_key = OrganizationField::FIELDS[key.to_sym]
        next if mapped_key.nil?

        [*value].flatten.each do |val|
          organization_search.add_filter(mapped_key, :equal, val)
        end
      end

      where_body = post_body(:publicSearch).tap do |body|
        body[:search] = organization_search.as_json
      end

      post_and_respond(where_body)
    end

    private

    def object_type
      'orgs'
    end
  end

  attr_accessor *OrganizationField::FIELDS.keys

  def initialize(attribute_hash)
    attribute_hash.each do |key, value|
      begin
        mapped_method = OrganizationField::FIELDS.key(key.to_sym)
        self.send("#{ mapped_method }=", value)
      rescue Exception => e
        require 'pry'
        binding.pry
      end
    end
  end
end
