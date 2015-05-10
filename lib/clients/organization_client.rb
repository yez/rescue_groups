require_relative './base_client'
require_relative '../search/organization_search'

class OrganizationClient < Client

  def search
  end

  private

  def object_type
    'orgs'
  end
end
