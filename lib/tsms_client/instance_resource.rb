module TSMS::InstanceResource
  def self.included(base)
    base.send(:include, TSMS::Base)
    base.send(:include, InstanceMethods)
  end

  module InstanceMethods
    def get
      setup_properties_from(self.client.get(href))
      self
    end

    def post
      response = client.post(self)
      setup_properties_from(response.body)
    end
  end
end