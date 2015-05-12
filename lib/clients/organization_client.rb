require_relative './base_client'
require_relative '../../search/organization_search'

class OrganizationClient < Client

  class << self
    def find(ids)
      ids_array = [*ids].flatten
      results = self.where(id: ids)
      ids_array.length = 1 ? results.first : results
    end

    def where(ids)
      where_body = {}.tap do |body|
        body[:objectAction] = :publicView
        body[:objectType]   = object_type
        body[:values]       = ids.map { |id| { orgID: id } }
        body[:fields]       = OrganizationField.all
      end

      response = post(base_uri, { body: JSON(where_body.merge(default_params)) })

      response['data'].map do |found_org|
        new(found_org)
      end
    end

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
