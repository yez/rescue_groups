require_relative './base_search'
require_relative './event_field'

class EventSearch < BaseSearch
  def self.fields
    EventField.all
  end
end
