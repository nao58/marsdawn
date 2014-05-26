# encoding: utf-8

require "marsdawn/version"
require "marsdawn/util"
require "marsdawn/config"
require "marsdawn/storage"
require "marsdawn/site"
require "marsdawn/search"

module Marsdawn

  # load lib file from lib/marsdawn directory
  # @param [String] require file under lib/marsdawn directory
  def self.require_lib path
    @@base_path ||= File.expand_path(File.join(File.dirname(__FILE__), 'marsdawn'))
    require File.join(@@base_path, path)
  end

  # build document source
  # @param [String] key of config file entry
  def self.build *keys
    require "marsdawn/builder"
    if block_given?
      conf = {}
      yield conf
      configs = [conf]
    else
      configs = configs_from_file(keys)
    end
    configs.each do |conf|
      Marsdawn::Builder.build conf
    end
  rescue => e
    puts "[MarsDawn] ERROR: #{e.message}"
  end

  private
  def self.configs_from_file keys
    [].tap do |ret|
      config = Marsdawn::Config.new
      if keys.size > 0
        keys.each do |key|
          ret << config.to_hash(key)
        end
      else
        config.each do |key, conf|
          ret << conf
        end
      end
    end
  end

end
