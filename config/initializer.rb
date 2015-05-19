require 'json'
require 'httparty'
require_relative './config'

RescueGroups.configuration do |config|
  config.apikey = ENV['API_KEY'] || ''
end

require_relative '../lib/remote_client'
require_relative '../models/animal'
require_relative '../models/organization'
