require_relative './remote_client'

module RescueGroups
  module ApiClient
    def self.included(base)
      base.class_eval do
        def self.api_client
          @api_client ||= RemoteClient.new
        end

        def api_client
          self.class.api_client
        end
      end
    end
  end
end
