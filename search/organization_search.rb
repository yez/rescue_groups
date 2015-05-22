require_relative './base_search'
require_relative './organization_field'

class OrganizationSearch < BaseSearch
  def self.fields
    OrganizationField.all
  end
end
