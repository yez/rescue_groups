class Client
  include HTTParty

  def get
  end

  def post
  end

  def patch
  end

  def delete
  end

  private

  def body
    {
      token:        config.token,
      tokenHash:    config.token_hash,
      objectType:   object_type,
      objectAction: object_action
    }
  end

  def object_type
    raise 'Must override object_type in child clients'
  end

  def object_action
    raise 'Must override object_action in child clients'
  end

  def headers
    self.headers['Content-Type'] = 'application/json'
  end

  def base_url
    config.production? ? 'https://api.rescuegroups.org/http/json' : 'http://localhost:1234'
  end
end
