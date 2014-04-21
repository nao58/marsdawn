# encoding: utf-8

require 'marsdawn/site/page'
require 'marsdawn/site/link'
require 'marsdawn/site/indexer'
require 'cgi'

class Marsdawn::Site

  def initialize opts, settings=nil
    @key = opts[:key]
    settings = Marsdawn::Config.instance.to_hash(@key) if settings.nil?
    @settings = settings
    @storage = Marsdawn::Storage.get(@settings[:storage], opts)
    @config = @storage.get_document_config
    @opts = opts
    @base_path = (opts.key?(:base_path) ? opts[:base_path] : '')
  end

  def page uri
    Marsdawn::Site::Page.new @config, @storage.get(uri), self
  end

  def full_path uri
    @base_path + uri
  end

  def index
    @index ||= Marsdawn::Site::Indexer.new(self, @config[:site_index])
  end

  def page_title uri
    @config[:site_index][uri] if @config[:site_index].key?(uri)
  end

  def title
    @config[:title]
  end

  def title_link
    @title_link ||= Marsdawn::Site::Link.new(self, '/', title)
  end

  def search keyword, opts
    raise "No search settings for this document." unless @settings.key?(:search)
    se = Marsdawn::Search.get(@settings[:search], @storage)
    se.search keyword, opts
  end

end
