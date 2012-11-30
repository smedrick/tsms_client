class TSMS::Client
  include TSMS::Util::HalLinkParser
  include TSMS::CoreExt

  attr_accessor :connection, :href

  def initialize(username, password, api_root = 'http://localhost:3000', logger=nil)
    @api_root = api_root
    connect!(username, password, logger)
    discover!
  end

  def connect!(username, password, logger)
    self.connection = TSMS::Connection.new(:username => username, :password => password, :api_root => @api_root, :logger => logger)
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
      req.url @api_root + obj.href
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