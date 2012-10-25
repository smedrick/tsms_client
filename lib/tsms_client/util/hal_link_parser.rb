module TSMS::Util
  module HalLinkParser

    def parse_links(_links, metaclass)
      parse_links(_links, metaclass) and return if _links.is_a?(Hash)
      _links.each do |link|
        parse_link(link, metaclass)
      end
    end

    def parse_link(link, metaclass)
      link.each do |rel, href|
        begin
          klass = ::TSMS.const_get(rel.capitalize)
          metaclass.send :define_method, rel.to_sym, &lambda { klass.new(href, self) }
        rescue NameError => e
          #puts "Don't know what to do with link rel '#{rel}' for class #{self.class.to_s}!"
        end
      end
    end

  end
end