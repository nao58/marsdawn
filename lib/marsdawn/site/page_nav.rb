# encoding: utf-8

class Marsdawn::Site
  class PageNav < Hash

    def initialize site, prev_page, next_page
      @site = site
      self[:prev_page] = @site.index[prev_page] unless prev_page.nil?
      self[:next_page] = @site.index[next_page] unless next_page.nil?
    end

    def to_s
      to_html
    end

    def to_html
      %!<ul>
      <li id="nav-prev-page">#{self[:prev_page]}</li>
      <li id="nav-next-page">#{self[:next_page]}</li>
      </ul>!
    end

  end
end
