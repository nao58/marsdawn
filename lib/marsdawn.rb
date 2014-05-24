# encoding: utf-8

load "marsdawn/tasks.rake"
require "marsdawn/version"
require "marsdawn/util"
require "marsdawn/config"
require "marsdawn/storage"
require "marsdawn/site"
require "marsdawn/search"

module Marsdawn

  def self.compile key=nil
    config = key.nil? ? {} : Marsdawn::Config.instance.to_hash(key)
    yield config if block_given?
    require "marsdawn/compiler"
    Marsdawn::Compiler.compile config
  end

  def self.compile_bk key, source_path=nil, storage_settings=nil, compile_options=nil
    config = Marsdawn::Config.instance
    source_path = config.get(key, :source) if source_path.nil?
    storage_settings = config.get(key, :storage) if storage_settings.nil?
    source = Marsdawn::Source.new(source_path)
    storage = Marsdawn::Storage.get(storage_settings, source.config)
    raise "The source directory '#{source_path}' is not a document of '#{key}'." unless key == source.key
    compile_options = config.get(key, :options, {}) if compile_options.nil?
    source.compile_options compile_options
    source.compile storage
    search_options = config.get(key, :search, {})
    Marsdawn::Search.create_index search_options, storage if search_options.key?(:type)
  end

end
