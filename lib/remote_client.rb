require 'httparty'
require_relative './response'

module RescueGroups
  # HTTParty wrapper with defaulted values
  #  for Content-Type, URL and apikey authentication
  class RemoteClient
    include HTTParty

    base_uri 'https://api.rescuegroups.org/http/json'
    headers 'Content-Type' => 'application/json'

    # method: post_and_respond
    # purpose: make a POST request to the RescueGroups API and respond
    # param: post_body - <Hash> - attributes to be included in the post body
    # return: response <Response> object with details of HTTP response
    def post_and_respond(post_body)
      if RescueGroups.config.apikey.nil? || RescueGroups.config.apikey.length == 0
        raise 'No RescueGroups API Key set'
      end

      response = self.class.post(
        self.class.base_uri,
        { body: JSON(post_body.merge(apikey: RescueGroups.config.apikey)) })

      Response.new(response)
    end
  end
end
