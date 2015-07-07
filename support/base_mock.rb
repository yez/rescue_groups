class BaseMock
  class << self
    def single_success
      mocked_class.new(test_hash)
    end

    def multiple_success
      [single_success]
    end

    def single_error
      fail "Unable to find #{ self.class.name }"
    end

    def multiple_error
      []
    end
  end
end
