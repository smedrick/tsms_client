module TSMS::CollectionResource
  def self.included(base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    include TSMS::Base
    attr_accessor :collection

    def initialize(client, href, items=nil)
      super(client, href)
      if items
        initialize_collection_from_items(items)
      else
        self.collection = []
      end

    end

    def get
      response = client.get(href)
      initialize_collection_from_items(response.body)
      #setup page links from header
      links = LinkHeader.parse(response.headers['link']).to_a.collect do |a|
        {a[1][0].last => a[0]}
      end
      parse_links(links)
      self
    end

    def build(attributes=nil)
      message = instance_class(self.class).new(client, self.href, attributes || {})
      self.collection << message
      message
    end

    def to_json
      @collection.map(&:to_json)
    end

    def to_s
      "<#{self.class.inspect} href=#{self.href} collection=#{self.collection.inspect}>"
    end

    private

    def initialize_collection_from_items(items)
      self.collection = items.map do |attrs|
        instance_class(self.class).new(client, nil, attrs)
      end
    end
  end
end