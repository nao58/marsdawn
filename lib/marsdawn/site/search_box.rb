# encoding: utf-8

class Marsdawn::Site
  class SearchBox

    def initialize site, word
      @site = site
      @word = word
    end

    def to_s
      to_html
    end

    def to_html
      if @site.searchable?
        %|<div id="search-box">
          <form action="#{@site.search_path}" method="get">
            <input type="search" name="search" value="#{Marsdawn::Util.html_escape(@word)}" />
          </form>
        </div>|
      end
    end

  end
end

