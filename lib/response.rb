module RescueGroups
  class Response
    ATTRIBUTES = %i[http_status_code parsed_body]

    attr_accessor *ATTRIBUTES

    def initialize(raw_response)
      @http_status_code = raw_response.code
      @parsed_body      = raw_response.parsed_response
    end

    def [](attribute)
      @parsed_body[attribute]
    end

    def success?
      [1, 2].include?(@http_status_code / 100)
    end
  end
end
