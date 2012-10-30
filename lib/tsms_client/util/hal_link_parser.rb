module TSMS::Util
  module HalLinkParser

    def parse_links(_links)
      @resources = {}
      return if _links.nil?
      parse_link(_links) and return if _links.is_a?(Hash)
      _links.each { |link| parse_link(link) }
    end

    def parse_link(link)
      link.each do |rel, href|
        begin
          if rel == 'self'
            self.href = href
          else
            klass = ::TSMS.const_get(rel.capitalize)
            subresources[rel] = klass.new(self.client, href)
          end
        rescue NameError => e
          puts "Don't know wh`at to do with link rel '#{rel}' for class #{self.class.to_s}!: #{e.message}"
        end
      end
    end

    def setup_subresources(_links)
      return if _links.nil?
      setup_subresource(_links) and return if _links.is_a?(Hash)
      _links.each { |link| setup_subresource(link) }
    end

    def setup_subresource(link)
      return unless link
      link.each { |rel, href| self.class.send(:define_method, rel.to_sym, &lambda { subresources[rel] }) unless rel == 'self' }
    end

    def subresources
      @resources
    end

  end
end