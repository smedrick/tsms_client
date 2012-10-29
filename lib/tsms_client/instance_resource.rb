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
      if response.status == 201
        setup_properties_from(response.body)
      else
        #raise ""
      end

    end

  end
end