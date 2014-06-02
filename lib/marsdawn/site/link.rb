# encoding: utf-8

class Marsdawn::Site
  class Link
    attr_reader :uri, :title, :site, :full_path

    def initialize site, uri, title=nil
      @uri = uri
      @title = (title.nil? ? site.page_title(uri) : title)
      @site = site
      @full_path = @site.full_path(@uri)
    end

    def page
      @site.page @uri
    end

    def to_s
      to_html
    end

    def to_html
      t = CGI.escapeHTML(@title)
      %!<a href="#{@full_path}" title="#{t}">#{t}</a>!
    end

  end
end
