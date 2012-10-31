class TSMS::Client
  include TSMS::Util::HalLinkParser
  include TSMS::CoreExt

  attr_accessor :connection, :href
  DEFAULT_ENDPOINT = 'http://localhost:3000'

  def initialize(username, password, api_root = DEFAULT_ENDPOINT)
    connect!(username, password, api_root)
    discover!
  end

  def connect!(username, password, api_root)
    self.connection = TSMS::Connection.new(:username => username, :password => password, :api_root => api_root)
  end

  def discover!
    services = get('/').body
    parse_links(services['_links'])
  end

  def get(href)
    raw_connection.get(href)
  end

  def post(obj)
    raw_connection.post do |req|
      req.url DEFAULT_ENDPOINT + obj.href
      req.headers['Content-Type'] = 'application/json'
      req.body = obj.to_json(true)
    end
  end

  def raw_connection
    connection.connection
  end

  def client
    self
  end

end