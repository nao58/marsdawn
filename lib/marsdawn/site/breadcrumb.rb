# encoding: utf-8

class Marsdawn::Site
  class Breadcrumb < Hash

    def initialize site, crumb
      @site = site
      crumb.each do |path|
        self[path] = Marsdawn::Site::Link.new(@site, path)
      end
    end

    def to_s
      to_html
    end

    def to_html
      words = []
      if self.size > 0
        words << '<ul>'
        self.each do |uri, link|
          words << "<li>#{link.to_html}</li>"
        end
        words << '</ul>'
      end
      words.join('')
    end

  end
end
