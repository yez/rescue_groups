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
    }.each do |model, test_values|
      find_body = model.find_body([*test_values[0]].flatten)
      where_body = model.where_body(model.conditions_to_search_engine(test_values[1]))

      find_response = model.api_client.post_and_respond(find_body).parsed_body
      where_response = model.api_client.post_and_respond(where_body).parsed_body

      model_name = model.to_s.split('::').last.downcase

      find_json_file = "#{ File.expand_path('..', __FILE__) }/spec/fixtures/#{ model_name }/find.json"
      where_json_file =  "#{ File.expand_path('..', __FILE__) }/spec/fixtures/#{ model_name }/where.json"

      File.open(find_json_file, 'w') { |f| f.write(JSON(find_response)) }
      File.open(where_json_file, 'w') { |f| f.write(JSON(where_response)) }
    end
  end
end

