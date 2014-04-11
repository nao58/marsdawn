# encoding: utf-8

class Marsdawn::Site
  class Indexer < Hash

    def initialize site, index={}
      @site = site
      @current_page = nil
      index.each do |uri, title|
        self[uri] = Marsdawn::Site::Link.new(@site, uri, title)
      end
    end

    def current_page path
      @current_page = path
      self
    end

    def under path
      base = path + (path == '/' ? '' : '/')
      self.each_with_object(Marsdawn::Site::Indexer.new(@site).current_page(path)) do |(uri, link), ret|
        ret[uri] = link if uri.start_with?(base) && uri != base
      end
    end

    def neighbor path
      level = path.count('/')
      base = File.dirname(path)
      base = base + '/' if base != '/'
      self.each_with_object(Marsdawn::Site::Indexer.new(@site).current_page(path)) do |(uri, link), ret|
        ret[uri] = link if uri.start_with?(base) && uri.count('/') == level && uri != base
      end
    end

    def to_s
      to_html
    end

    def to_html
      if self.size > 0
        create_link_html File.dirname(self.keys.first)
      else
        ""
      end
    end

    private
    def create_link_html path
      base_level = path.count('/')
      words = []
      words << '<ul>'
      self.each do |uri, link|
        next unless uri.start_with?(path)
        level = uri.count('/')
        if base_level < level
          words.insert -2, create_link_html(uri)
        elsif base_level == level
          attr = (uri == @current_page ? ' class="current-page"' : '')
          words << "<li#{attr}>"
          words << link.to_html
          words << '</li>'
        end
      end
      words << '</ul>'
      words.size > 2 ? words.join('') : ""
    end

  end
end
