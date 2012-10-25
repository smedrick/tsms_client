module TSMS
  module Base
    def self.included(base)
      base.send(:include, TSMS::Util::HalLinkParser)
      base.send(:include, InstanceMethods)
    end

    attr_accessor :client, :href

    module InstanceMethods
      def initialize(client, href)
        self.client = client
        self.href = href
        set_up_properties_from(href)
      end

      def set_up_properties_from(href)
        attrs = self.client.get(href)
        metaclass = class << self;
          self;
        end
        setup_associations(hash.delete('_links'), metaclass)
        hash.each do |property, v|
          if self.respond_to?(:"#{property}=")
            self.send(:"#{property}=", v)
          else
            metaclass.send :define_method, property.to_sym, &lambda { v }
            if [true, false].include?(v)
              metaclass.send :define_method, :"#{property}?", &lambda { v }
            end
          end
        end
      end

      def to_s
        "<#{self.class.inspect} href=#{self.href}>"
      end
    end
  end

end