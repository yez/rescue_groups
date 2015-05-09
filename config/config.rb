module RescueGroups
  class Config
    attr_accessor :apikey
  end

  def self.config
    @config ||= Config.new
  end

  def self.configuration
    yield config
  end
end
