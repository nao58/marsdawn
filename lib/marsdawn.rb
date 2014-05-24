# encoding: utf-8

load "marsdawn/tasks.rake"
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

  # compile document source
  # @param [String] key of config file entry
  def self.compile key=nil
    config = key.nil? ? {} : Marsdawn::Config.instance.to_hash(key)
    yield config if block_given?
    require "marsdawn/compiler"
    Marsdawn::Compiler.compile config
  end

end
