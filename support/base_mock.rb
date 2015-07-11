module RescueGroups
  class BaseMock
    class << self
      # method: find
      # purpose: Instantiate and return a new
      #            mocked version of the desired model
      # param: none
      # return: <Object> initialized object with values from
      #           the test_hash
      def find
        mocked_class.new(test_hash)
      end

      # method: where
      # purpose: Instantiate and return an array of new
      #            mocked versions of the desired model
      # param: none
      # return: <Array> of objects
      #         initialized object with values from
      #           the test_hash
      def where
        [find]
      end

      # method: find_not_found
      # purpose: Raise exception equivalent to the one
      #            raised when an object is not found
      # param: none
      # return: none
      def find_not_found
        fail "Unable to find #{ self.class.name }"
      end

      # method: where_not_found
      # purpose: Return an empty <Array> to emulate
      #            when a where call returns 0 results
      # param: none
      # return: <Array> empty array
      def where_not_found
        []
      end
    end
  end
end
