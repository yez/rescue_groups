module RescueGroups
  class Config
    attr_accessor :apikey
  end

  # method: config
  # purpose: class method to instantiate or return an already
  #           instantiated Config class
  # param: none
  # return: <Config> - instance of the config class
  def self.config
    @config ||= Config.new
  end

  # method: configuration
  # purpose: yield to a block of configuration parameters
  #          example:
  #            RescueGroups.configuration do |config|
  #              config.api_key = 'anything'
  #            end
  # param: none
  # return: none
  def self.configuration
    yield config
  end
end
