require_relative './base_search'
require_relative './animal_field'

class AnimalSearch < BaseSearch
  def self.fields
    AnimalField.all
  end
end
