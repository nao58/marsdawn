# encoding: utf-8

load "marsdawn/tasks.rake"
require "marsdawn/version"
require "marsdawn/util"
require "marsdawn/config"
require "marsdawn/source"
require "marsdawn/storage"
require "marsdawn/site"

module Marsdawn

  def self.compile key, source_path=nil, storage_settings=nil
    source_path = Marsdawn::Config.instance.get(key, :source) if source_path.nil?
    storage_settings = Marsdawn::Config.instance.get(key, :compile) if storage_settings.nil?
    source = Marsdawn::Source.new(source_path)
    raise "The source directory '#{source_path}' is not a document of '#{key}'." unless key == source.key
    source.compile storage_settings
  end

end
