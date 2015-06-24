require_relative './remote_client'

module RescueGroups
  module ApiClient
    # This method is called when the ApiClient Module is included
    #   in a class.
    def self.included(base)
      base.class_eval do
        # method: api_client
        # purpose: Return or instantiate a new RemoteClient class to
        #          handle all details of talking to the third party
        #          RescueGroups API
        # param: none
        # return: RemoteClient
        def self.api_client
          @api_client ||= RemoteClient.new
        end

        # method: api_client
        # purpose: delegate to class method to retrieve remote client
        # param: none
        # return: result of self.api_client
        def api_client
          self.class.api_client
        end
      end
    end
  end
end
