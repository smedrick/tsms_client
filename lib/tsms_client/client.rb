class TSMS::Client
  include TSMS::Util::HalLinkParser
  attr_accessor :connection
  DEFAULT_ENDPOINT = 'http://localhost:3000'

  def initialize(username, password, api_root = DEFAULT_ENDPOINT)
    connect!(username, password, api_root)
    discover!
  end

  def connect!(username, password, api_root)
    self.connection = TSMS::Connection.new(:username => username, :password => password, :api_root => api_root)
  end

  def discover!
    services = get('/')
    setup_subresources(services['_links'])
    parse_links(services['_links'])
  end

  def get(href)
    raw_connection.get(href).body
  end

  def post(obj)
    raw_connection.post do |post|
      req.url = DEFAULT_ENDPOINT + href
      req.headers['Content-Type'] = 'application/json'
      req.body = self.to_json
    end
  end

  def raw_connection
    connection.connection
  end

end