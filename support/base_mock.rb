module RescueGroups
  class BaseMock
    class << self
      def find
        mocked_class.new(test_hash)
      end

      def where
        [single_success]
      end

      def find_not_found
        fail "Unable to find #{ self.class.name }"
      end

      def where_not_found
        []
      end
    end
  end
end
