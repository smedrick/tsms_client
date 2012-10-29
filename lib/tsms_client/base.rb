module TSMS
  module Base
    def self.included(base)
      base.send(:include, TSMS::Util::HalLinkParser)
      base.extend(ClassMethods)
      base.send(:include, InstanceMethods)
    end

    attr_accessor :client, :href

    module ClassMethods
      def readonly_attributes(*attrs)
        @readonly_attributes ||= [:created_at, :updated_at]
        @readonly_attributes.concat(attrs) if attrs.any?
        @readonly_attributes
      end

      def methods_generated? # :nodoc:
        @methods_generated ||= false
      end
    end

    module InstanceMethods
      def initialize(client, href)
        self.client = client
        self.href = href
        @attributes = {}
        setup_properties_from(self.client.get(href)) if href
      end

      def setup_properties_from(hash)
        setup_accessors(hash) unless self.class.methods_generated?
        parse_links(hash.delete('_links'))
        hash.each do |property, value|
          @attributes[property.to_sym] = value
        end

      end

      def setup_accessors(hash)
        #still kind of janky
        @attribute_methods_mutex = Mutex.new
        @attribute_methods_mutex.synchronize do
          hash.reject { |k, v| k=~/^_/ }.each do |property, value|
            unless self.respond_to?(:"#{property}=")
              self.class.send :define_method, :"#{property}=", &lambda { |v| @attributes[property.to_sym] = v }
              self.class.send :define_method, property.to_sym, &lambda { @attributes[property.to_sym] }
              self.class.send :define_method, :"#{property}?", &lambda { @attributes[property.to_sym] } if [true, false].include?(value)
            end
          end
          setup_subresources(hash['_links'])
          self.class.instance_variable_set('@methods_generated', true)
        end
      end

      def to_json
        hash = @attributes.clone
        self.class.readonly_attributes.each { |r| hash.delete(r) }
        hash
      end

      def to_s
        "<#{self.class.inspect} href=#{self.href} attributes=#{@attributes.inspect}>"
      end
    end
  end

end