# encoding: utf-8

class ActiveRecord; end

class MarsdawnDocs
  attr_accessor :key, :lang, :version, :uri, :data

  def self.transaction
    @@trans_data = {}
    yield
    @@data = @@trans_data.dup
  end

  def self.where query
    [].tap do |ret|
      ret << @@data[query[:uri]] if query.key?(:uri)
    end
  end

  def self.delete query
    @@trans_data.delete(query[:uri])
  end

  def self.create rec
    @@trans_data[rec[:uri]] = new(rec)
  end

  def initialize rec
    @key     = rec[:key]
    @lang    = rec[:lang]
    @version = rec[:version]
    @uri     = rec[:uri]
    @data    = rec[:data]
  end

end
