class TSMS::Connection
  attr_accessor :username, :password, :api_root, :connection, :logger

  def get(href)
    resp = connection.get("#{href}.json")
    if resp.status != 200
      raise RecordNotFound.new("Could not find resource at #{href} (status #{resp.status})")
    else
      resp.body
    end
  end

  def initialize(opts={})
    self.username = opts[:username]
    self.password = opts[:password]
    self.api_root = opts[:api_root]
    self.logger   = opts[:logger]
    setup_connection
  end

  def setup_connection
    self.connection = Faraday.new(:url => self.api_root) do |faraday|
      faraday.use TSMS::Logger, self.logger if self.logger
      faraday.request :json
      faraday.basic_auth(self.username, self.password)
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter :net_http
    end
  end
end
