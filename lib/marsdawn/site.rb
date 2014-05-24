# encoding: utf-8

require 'marsdawn/site/page'
require 'marsdawn/site/search_page'
require 'marsdawn/site/link'
require 'marsdawn/site/indexer'
require 'cgi'

class Marsdawn::Site

  def initialize opts, config=nil
    @key = opts[:key]
    yield config if block_given?
    config = Marsdawn::Config.instance.to_hash(@key) if config.nil?
    @config = config
    @storage = Marsdawn::Storage.get(@config[:storage], opts)
    @doc_info = @storage.get_document_info
    @opts = opts
    @base_path = (opts.key?(:base_path) ? opts[:base_path] : '')
  end

  def page uri
    Marsdawn::Site::Page.new @doc_info, @storage.get(uri), self
  end

  def full_path uri
    File.join @base_path, uri
  end

  def index
    @index ||= Marsdawn::Site::Indexer.new(self, @doc_info[:site_index])
  end

  def page_title uri
    @doc_info[:site_index][uri] if @doc_info[:site_index].key?(uri)
  end

  def title
    @doc_info[:title]
  end

  def title_link
    @title_link ||= Marsdawn::Site::Link.new(self, '/', title)
  end

  def searchable?
    @config.key?(:search)
  end

  def search_path
    uri = @opts[:search_uri] || '/'
    full_path uri
  end

  def search keyword, opts={}
    raise "No search settings for this document." unless searchable?
    se = Marsdawn::Search.get(@storage, @config[:search])
    results = se.search(keyword, opts)
    Marsdawn::Site::SearchPage.new @doc_info, self, keyword, results
  end

end
