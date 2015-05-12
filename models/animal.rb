require_relative '../lib/remote_client'
require_relative '../search/animal_search'

class Animal < RemoteClient
  def object_type
    'animals'
  end
end
