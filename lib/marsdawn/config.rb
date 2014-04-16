# encoding: utf-8

require 'singleton'

class Marsdawn::Config
  include Singleton

  def initialize
    file = File.absolute_path('./config/marsdawn.yml')
    raise "Cannot find a storage setting file for marsdawn." unless File.exists?(file)
    @config = YAML.load_file(file)
  end

  def get key, entry, default=nil
    raise "Cannot find a storage setting for '#{key}'." unless @config.key?(key)
    conf = Marsdawn::Util.hash_symbolize_keys(@config[key])
    conf[entry] = default if !default.nil? && !conf.key?(entry)
    raise "No entry '#{entry}' in the setting file of marsdawn." unless conf.key?(entry)
    ret = conf[entry]
    ret = Marsdawn::Util.hash_symbolize_keys(ret) if ret.kind_of?(Hash)
    ret
  end

end
