require './config/initializer'
require './spec/fixtures/test_constants'

namespace :fixtures do
  desc 'reload fixtures from remote API'
  task :reload do
    fail 'No API key given' if RescueGroups.config.apikey == ""

    {
      RescueGroups::Animal       => [TEST_ANIMAL_ID, breed: TEST_ANIMAL_BREED],
      RescueGroups::Organization => [TEST_ORG_ID, name: TEST_ORG_NAME],
      RescueGroups::Event        => [TEST_EVENT_ID, name: TEST_EVENT_NAME],
    }.each do |klass, test_values|
      find_request = RescueGroups::Requests::Find.new([*test_values[0]].flatten, klass, klass.api_client)
      where_request = RescueGroups::Requests::Where.new(test_values[1], klass, klass.api_client, klass.search_engine_class)

      find_results = klass.api_client.post_and_respond(find_request.as_json).parsed_body
      where_results = klass.api_client.post_and_respond(where_request.as_json).parsed_body

      model_name = klass.to_s.split('::').last.downcase

      find_json_file = "#{ File.expand_path('..', __FILE__) }/spec/fixtures/#{ model_name }/find.json"
      where_json_file =  "#{ File.expand_path('..', __FILE__) }/spec/fixtures/#{ model_name }/where.json"

      File.open(find_json_file, 'w') { |f| f.write(JSON(find_results)) }
      File.open(where_json_file, 'w') { |f| f.write(JSON(where_results)) }
    end
  end
end

