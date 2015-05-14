require_relative '../config/initializer'
require 'pry'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

TEST_ORG_ID = 660

RSpec.configure do |config|
  fixtures_dir = "#{ File.dirname(__FILE__) }/fixtures/"

  config.before do
    stub_request(
      :post,
      'https://api.rescuegroups.org/http/json?apikey=')
    .with(
      body: JSON({
        objectAction: :publicView,
        objectType: :orgs,
        fields: OrganizationField.all,
        values: [{ orgID: TEST_ORG_ID }],
        apikey: ''
      }),
      headers: { 'Content-Type' => 'application/json' })
    .to_return(
      status: 200,
      body: File.read("#{ fixtures_dir }/organization/find.json"),
      headers: { 'Content-Type' => 'application/json' })
  end
end
