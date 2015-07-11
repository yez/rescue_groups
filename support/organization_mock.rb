require_relative '../models/organization'
require_relative './base_mock'

module RescueGroups
  class OrganizationMock < BaseMock
    class << self
      # method: mocked_class
      # purpose: Used by BaseMock, defines which object
      #            within the RescueGroups namespace to
      #            initialize with test_hash
      # param: none
      # return: <Constant> Name of the class to initialize with
      def mocked_class
        Organization
      end

      # method: test_hash
      # purpose: Define attributes relevant to a test version
      #            of this object.
      # param: none
      # return: <Hash> hash of values that would constitute
      #           a decent set of attributes for this class
      def test_hash
        {
          "orgID"=>"660",
          "orgAbout"=>"",
          "orgAdoptionProcess"=>"Adoption Fees are:$250 - Adults & $300 - Puppies.   All are vetted, spay/neutered, microchipped and other known medical conditions addressed",
          "orgAdoptionUrl"=>"",
          "orgCommonapplicationAccept"=>"No",
          "orgDonationUrl"=>"",
          "orgEmail"=>"info@atdr.org",
          "orgFacebookUrl"=>"http://www.facebook.com/pages/All-Texas-Dachshund-Rescue-ATDR/55375608508",
          "orgFax"=>"",
          "orgLocation"=>"77584",
          "orgAddress"=>"P.O. Box 841336",
          "orgCity"=>"Pearland",
          "orgCountry"=>"United States",
          "orgPostalcode"=>"77584",
          "orgState"=>"TX",
          "orgPlus4"=>"",
          "orgMeetPets"=>"Visit us online at our website and Facebook page or at one of our events",
          "orgName"=>"All Texas Dachshund Rescue",
          "orgPhone"=>"",
          "orgServeAreas"=>"State of Texas including the Houston, DFW, Austin & San Antonio metroplexes",
          "orgServices"=>"Adoptions",
          "orgSponsorshipUrl"=>"",
          "orgType"=>"Rescue",
          "orgWebsiteUrl"=>"http://www.atdr.org"
        }
      end
    end
  end
end
