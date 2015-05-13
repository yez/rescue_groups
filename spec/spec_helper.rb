require_relative '../config/initializer'
require 'pry'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)
