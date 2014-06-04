# encoding: utf-8

require 'marsdawn/storage/base'
require 'json'
require 'zlib'

class Marsdawn::Storage::ActiveRecord < Marsdawn::Storage::Base

  def initialize config, opts={}
    unless Module.const_defined?('ActiveRecord')
      raise "Gem 'active_record' should be installed to use ActiveRecord storage for MarsDawn." unless require 'active_record'
    end
    #require 'marsdawn/storage/active_record/marsdawn'
    @opts = {
      key: '-',
      lang: 'en',
      version: '0.0.1'
    }.merge(opts)
  end

  def prepare
    #Marsdawn.create_unless_exists
    @stack = {}
  end

  def finalize
    MarsdawnDocs.transaction do
      MarsdawnDocs.where(selector).each do |page|
        MarsdawnDocs.delete_all(selector(uri: page.uri)) unless @stack.key?(page.uri)
      end
      @stack.each do |uri, data|
        rec = MarsdawnDocs.where(selector(uri: uri))
        if rec.size > 0
          rec.first.update_attributes! data: compress(data)
        else
          MarsdawnDocs.create selector(uri: uri, data: compress(data))
        end
      end
    end
  rescue => e
    raise e
  end

  def clean_up
    @stack = {}
  end

  def set_document_info doc_info
    @stack['doc_info'] = doc_info
  end

  def set uri, content, front_matter, sysinfo
    @stack[uri] = {content: content, front_matter: front_matter, sysinfo: sysinfo}
  end

  def get_document_info
    Marsdawn::Util.hash_symbolize_keys(get_data('doc_info'))
  end

  def get uri
    data = get_data(uri)
    Marsdawn::Util.hash_symbolize_keys_deep(data) unless data.nil?
  end

  private
  def compress data
    Zlib::Deflate.deflate(JSON.generate(data))
  end

  def decompress data
    JSON.parse(Zlib::Inflate.inflate(data))
  end

  def get_data uri
    page = MarsdawnDocs.where(selector(uri: uri)).first
    decompress(page.data) unless page.nil?
  end

  def selector additional={}
    {key: @opts[:key], lang: @opts[:lang], version: @opts[:version]}.merge(additional)
  end

end
