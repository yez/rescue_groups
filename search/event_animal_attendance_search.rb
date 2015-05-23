require_relative './base_search'
require_relative './event_animal_attendance_field'

class EventAnimalAttendanceSearch
  def self.fields
    EventAnimalAttendanceField.all
  end
end
