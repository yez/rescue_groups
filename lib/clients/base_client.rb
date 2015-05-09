class Client
  include HTTParty

  debug_output $stdout

  base_uri 'https://api.rescuegroups.org/http/json'
  headers 'Content-Type' => 'application/json'
  default_params apikey: RescueGroups.config.apikey

  def body
    { objectType: object_type }
  end

  private

  def object_type
    raise 'Must override object_type in child clients'
  end
end
