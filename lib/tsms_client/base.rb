module TSMS
  module Base
    def self.included(base)
      base.send(:include, TSMS::Util::HalLinkParser)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
      base.send(:include, TSMS::CoreExt)
      base.send(:extend, TSMS::CoreExt)
    end

    attr_accessor :client, :href, :errors

    module ClassMethods
      def to_param
        tsmsify(self)
      end
    end

    module InstanceMethods
      def initialize(client, href)
        self.client = client
        self.href = href
      end
    end

  end

end