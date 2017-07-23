require 'json'
require 'faraday'
# This must be required before configuration can happen
require_relative '../lib/rescue_groups'
require_relative './config'

RescueGroups.configuration do |config|
  # Your API key should be set in an ENV variable called RESCUE_GROUPS_API_KEY
  config.apikey = ENV['RESCUE_GROUPS_API_KEY'] || ''
  config.load_all_results = false
end

require_relative '../models/animal'
require_relative '../models/organization'
require_relative '../models/event'
