module TSMS
  module Base
    mattr_accessor :client

    def self.included(base)
      def base.client
        TSMS::Base.client ||= Client.new(Rails.configuration.api_connection_info)
      end

      base.send(:attr_accessor, :source_uri)
      base.send(:include, InstanceMethods)
    end

    module InstanceMethods
      def initialize(attrs)
        self.source_uri = source_uri
        set_up_properties_from(attrs)
      end

      def set_up_properties_from(hash)
        metaclass = class << self;
          self;
        end
        setup_associations(hash.delete('link'), metaclass)
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

      def setup_associations(links, metaclass)
        return unless links
        links = [links] if links.is_a?(Hash)
        links.each do |link|
          metaclass.send :define_method, link['rel'].to_sym, &lambda {
            instance_variable_get(:"@#{link['rel']}") ||
              instance_variable_set(:"@#{link['rel']}", link['rel'].classify.constantize.new(client.get(link['href']).merge(self.class.to_s.underscore => self), link['href']))
          }
        end
      end

      def to_s
        "<#{self.class.inspect} source_uri=#{self.source_uri}>"
      end
    end
  end

end