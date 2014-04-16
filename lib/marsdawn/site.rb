# encoding: utf-8

require 'marsdawn/site/page'
require 'marsdawn/site/link'
require 'marsdawn/site/indexer'
require 'cgi'

class Marsdawn::Site

  def initialize opts, storage_settings=nil
    @storage = Marsdawn::Storage.get(storage_settings, opts)
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

end
