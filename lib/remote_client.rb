require 'httparty'
require_relative './response'

module RescueGroups
  class RemoteClient
    include HTTParty

    debug_output $stdout

    base_uri 'https://api.rescuegroups.org/http/json'
    headers 'Content-Type' => 'application/json'
    default_params apikey: RescueGroups.config.apikey

    def post_and_respond(post_body)
      response = self.class.post(
        self.class.base_uri,
        { body: JSON(post_body.merge(self.class.default_params)) })

      Response.new(response)
    end
  end
end
