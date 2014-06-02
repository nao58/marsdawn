# encoding: utf-8

require 'marsdawn/site/breadcrumb'
require 'marsdawn/site/page_nav'
require 'marsdawn/site/search_box'

class Marsdawn::Site
  class Page
    attr_reader :site, :uri, :title, :content, :type, :level, :sysinfo

    def initialize doc_info, page, site
      @doc_info = doc_info
      @site = site
      front_matter = page[:front_matter]
      @sysinfo = page[:sysinfo]
      @uri = @sysinfo[:uri]
      @title = front_matter[:title]
      @content = page[:content]
      @type = @sysinfo[:type]
      @level = @sysinfo[:level]
      @search_word = ''
    end

    def breadcrumb
      @breadcrumb ||= Marsdawn::Site::Breadcrumb.new(@site, @sysinfo[:breadcrumb])
    end

    def neighbor
      @neighbor ||= @site.index.neighbor(@uri)
    end

    def top
      @site.top
    end

    def parent
      @parent ||= Marsdawn::Site::Link.new(@site, @sysinfo[:parent]) unless @sysinfo[:parent].nil?
    end

    def under
      @under ||= @site.index.under(@uri)
    end

    def page_nav
      @page_nav ||= Marsdawn::Site::PageNav.new(@site, @sysinfo[:prev_page], @sysinfo[:next_page])
    end

    def link
      @link ||= Marsdawn::Site::Link.new(@site, @uri, @title)
    end

    def search_box
      @search_box ||= Marsdawn::Site::SearchBox.new(@site, @search_word)
    end

    def to_s
      to_html
    end

    def to_html options={}
      <<-"EOS"
      <div class="main-container">
      <div class="container">
        <div class="row">
          <div class="col-lg-3 sidebar">
            <nav>#{neighbor}</nav>
          </div>
          <div class="col-lg-9 content">
            <p>contents</p>
          </div>
        </div>
      </div>
      </div>
      EOS
    end

    def to_page_html options={}
      opts = {
        css: ['http://dev.screw-axis.com/marsdawn/style.css'],
        js: [],
        title: CGI.escapeHTML(@title),
        title_suffix: " | #{CGI.escapeHTML(@site.title)}",
        lang: @doc_info[:lang],
        charset: @doc_info[:encoding]
      }.merge(options)
      css_html = opts[:css].map{|file| %!<link rel="stylesheet" href="#{file}" type="text/css" />!}.join("\n")
      js_html = opts[:js].map{|file| %!<script src="#{file}"></script>!}.join("\n")
      %|<!DOCTYPE html>
      <html lang="#{opts[:lang]}">
      <head>
        <meta charset="#{opts[:encoding]}" />
        <title>#{opts[:title]}#{opts[:title_suffix]}</title>
        #{css_html}
        #{js_html}
      </head>
      <body>
        <div id="container">
          <div id="site-header"><h1 id="site-title">#{@site.title_link}</h1></div>
          <div id="side-menu">
            #{search_box}
            <nav>#{neighbor}</nav>
          </div>
          <div id="site-body">
            <div id="main-content">
              <div id="breadcrumb"><nav>#{breadcrumb}</nav></div>
              <div id="page-content">#{@content}</div>
              <div id="under-index">#{under}</div>
              <div id="page-nav">#{page_nav}</div>
            </div>
            <div class="clear"></div>
          </div>
        </div>
      </body>
      </html>|
    end

  end
end
