require_relative './base_client'
require_relative '../search/animal_search'

class AnimalClient < Client

  def search
  end

  private

  def object_type
    'animals'
  end
end
