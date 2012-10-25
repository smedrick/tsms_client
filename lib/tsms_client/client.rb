class Client
  attr_accessor :username, :password, :api_url, :connection

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
    self.api_url = opts[:api_url] || "http://localhost:3000/"
    setup_connection
  end


  def setup_connection
    self.connection = Faraday.new(:url => self.api_url) do |faraday|
      #faraday.use Faraday::Response::Logger, Rails.logger
      faraday.request :json
      faraday.basic_auth(self.username, self.password)
      faraday.response :json, :content_type => /\bjson$/
      faraday.adapter :net_http
    end
  end
end
