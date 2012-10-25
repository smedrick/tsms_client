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
    metaclass = class << self;
      self;
    end
    services = get('/')
    parse_links(services.body['_links'], metaclass)
  end

  def get(href)
    raw_connection.get(href)
  end

  def raw_connection
    connection.connection
  end

end