# encoding: utf-8

class Marsdawn::Site
  class SearchPage < Page

    def initialize doc_info, site, search_word, search_results
      @word = search_word
      @results = search_results
      exvars = {title: 'Search Results'}
      sysinfo = {
        uri: site.search_path,
        breadcrumb: [],
        prev_page: nil,
        next_page: nil
      }
      page = {
        content: content,
        exvars: exvars,
        sysinfo: sysinfo
      }
      super doc_info, page, site
      @search_word = search_word
    end

    def content
      ret = %!<h1>Search Results for '#{Marsdawn::Util.html_escape(@word)}'</h1>!
      @content ||= @results.each_with_object ret do |res, ret|
        ret << %!<h4><a href=".#{res[:uri]}">#{res[:title]}</a></h4>!
        blocks = res[:results].join(' ... ')
        ret << %!<div class="search-result">#{blocks}</div>!
      end
    end

  end
end
