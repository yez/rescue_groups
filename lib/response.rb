module RescueGroups
  class Response
    attr_accessor :http_status_code, :parsed_body

    # method: initialize
    # purpose: When a Response is created, this method
    #            extracts the code and parsed_response from
    #            the raw HTTParty response
    # param: raw_response - <HTTParty Response> - raw HTTParty response
    # return: nil
    def initialize(raw_response)
      @http_status_code = raw_response.code
      @parsed_body      = raw_response.parsed_response
    end

    # method: []
    # purpose: Convenience method to access an attribute from
    #            the parsed body
    # param: attribute - <String> - key of desired value from response
    # return: value at the specified key of the response
    def [](attribute)
      @parsed_body[attribute]
    end

    # method: success
    # purpose: return true/false for if the response had an error (Non-HTTP error)
    # param: none
    # return: <Boolean> state of the response['status']
    def success?
      self['status'] != 'error'
    end

    # method: error
    # purpose: traverse down response tree and extract the error
    #            text on errorful responses
    # param: none
    # return: <Nil> if there is no error
    #         <String> if an error exists and messageCriticality is expected
    #                  value
    def error
      unless success?
        self['messages']['generalMessages'].map do |m|
          m['messageText'] if m['messageCriticality'] == 'error'
        end.compact.join("\n")
      end
    end
  end
end
