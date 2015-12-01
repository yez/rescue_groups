require 'faraday'
require_relative './response'

module RescueGroups
  class RemoteClient

    BASE_URL = 'https://api.rescuegroups.org/http/json'.freeze

    def headers
      { 'Content-Type' => 'application/json' }.merge(connection.headers)
    end

    # method: post_and_respond
    # purpose: make a POST request to the RescueGroups API and respond
    # param: post_body - <Hash> - attributes to be included in the post body
    # return: response <Response> object with details of HTTP response
    def post_and_respond(post_body)
      if RescueGroups.config.apikey.nil? || RescueGroups.config.apikey.length == 0
        raise 'No RescueGroups API Key set'
      end

      response = connection.post(BASE_URL) do |request|
        request.headers = headers
        request.body = JSON(post_body.merge(apikey: RescueGroups.config.apikey))
      end

      Response.new(response)
    end

    def connection
      @connection ||= Faraday.new
    end
  end
end
