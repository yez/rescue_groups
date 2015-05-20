class EventField
  FIELDS = {
    id:                   :eventID,
    org_id:               :eventOrgID,
    name:                 :eventName,
    event_start:          :eventStart,
    event_end:            :eventEnd,
    url:                  :eventUrl,
    description:          :eventDescription,
    location_id:          :eventLocationID,
    location_distance:    :eventLocationDistance,
    species:              :eventSpecies,
    location_name:        :locationName,
    location_url:         :locationUrl,
    location_address:     :locationAddress,
    location_city:        :locationCity,
    location_state:       :locationState,
    location_postal_code: :locationPostalcode,
    location_country:     :locationCountry,
    location_phone:       :locationPhone,
    location_phone_ext:   :locationPhoneExt,
    location_events:      :locationEvents,
  }

  def self.all
    FIELDS.values
  end
end
