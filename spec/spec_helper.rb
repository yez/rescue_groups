require_relative '../config/initializer'
require 'pry'
require 'webmock/rspec'

WebMock.disable_net_connect!(allow_localhost: true)

TEST_ORG_ID        = 660
TEST_ORG_NAME      = 'All Texas Dachshund Rescue'
NOT_FOUND_ORG_NAME = 'Bad Dogs Only'
NOT_FOUND_ORG_ID   = -1

class TestResponse
  attr_reader :http_status_code, :parsed_body

  def success?
    false
  end
end

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

    stub_request(
      :post,
      'https://api.rescuegroups.org/http/json?apikey=')
      .with(
        body: JSON({
          objectAction: :publicView,
          objectType: :orgs,
          fields: OrganizationField.all,
          values: [{ orgID: NOT_FOUND_ORG_ID }],
          apikey: ''
        }),
        headers: { 'Content-Type' => 'application/json' })
      .to_return(
        status: 404,
        body: '{}',
        headers: { 'Content-Type' => 'application/json' })

    stub_request(
      :post,
      'https://api.rescuegroups.org/http/json?apikey=')
      .with(
        body: JSON({
          objectAction: :publicSearch,
          objectType: :orgs,
          search: {
            resultStart: 0,
            resultLimit: 10,
            resultSort: nil,
            resultOrder: :asc,
            calcFoundRows: 'Yes',
            filters: [{
              fieldName: :orgName,
              operation: :equal,
              criteria: TEST_ORG_NAME
            }],
            fields: OrganizationField.all,
          },
          apikey: ''
        }),
        headers: { 'Content-Type' => 'application/json' })
      .to_return(
        status: 200,
        body: File.read("#{ fixtures_dir }/organization/where.json"),
        headers: { 'Content-Type' => 'application/json' })

    stub_request(
      :post,
      'https://api.rescuegroups.org/http/json?apikey=')
      .with(
        body: JSON({
          objectAction: :publicSearch,
          objectType: :orgs,
          search: {
            resultStart: 0,
            resultLimit: 10,
            resultSort: nil,
            resultOrder: :asc,
            calcFoundRows: 'Yes',
            filters: [{
              fieldName: :orgName,
              operation: :equal,
              criteria: NOT_FOUND_ORG_NAME
            }],
            fields: OrganizationField.all,
          },
          apikey: ''
        }),
        headers: { 'Content-Type' => 'application/json' })
      .to_return(
        status: 200,
        body: '{ "data": [] }',
        headers: { 'Content-Type' => 'application/json' })
  end
end
