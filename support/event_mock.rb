require_relative '../models/event'
require_relative './base_mock'

module RescueGroups
  class EventMock < BaseMock
    class << self
      # method: mocked_class
      # purpose: Used by BaseMock, defines which object
      #            within the RescueGroups namespace to
      #            initialize with test_hash
      # param: none
      # return: <Constant> Name of the class to initialize with
      def mocked_class
        Event
      end

      # method: test_hash
      # purpose: Define attributes relevant to a test version
      #            of this object.
      # param: none
      # return: <Hash> hash of values that would constitute
      #           a decent set of attributes for this class
      def test_hash
        {
          "eventID"=>"36385",
          "eventOrgID"=>"4516",
          "eventName"=>"Weekly Mobile Adoption Event!!!",
          "eventStart"=>"1/22/2011 10:00 AM",
          "eventEnd"=>"1/22/2011 3:00 PM",
          "eventUrl"=>"",
          "eventDescription"=>"Come meet some of our fabulous dogs.  Find yourself a new best friend or help us save a life by fostering!  If you're interested in a particular dog, please email us and let us know so we can be sure she or he is there!",
          "eventLocationID"=>"10422",
          "eventSpecies"=>["Dog"],
          "locationName"=>"Pet Food Express",
          "locationUrl"=>"",
          "locationAddress"=>"Dolores and Market St.",
          "locationCity"=>"San Francisco ",
          "locationState"=>"CA",
          "locationPostalcode"=>"94114",
          "locationCountry"=>"United States",
          "locationPhone"=>"",
          "locationPhoneExt"=>"",
          "locationEvents"=>"0"
        }
      end
    end
  end
end
