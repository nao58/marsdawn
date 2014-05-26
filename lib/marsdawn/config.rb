# encoding: utf-8

class Marsdawn::Config

  def initialize file='./config/marsdawn.yml'
    file = File.absolute_path(file)
    raise "Cannot find a config file for marsdawn." unless File.exists?(file)
    @config = YAML.load_file(file)
  end

  def get key, entry, default=nil
    conf = to_hash(key)
    conf[entry] = default if !default.nil? && !conf.key?(entry)
    raise "No entry '#{entry}' in the setting file of marsdawn." unless conf.key?(entry)
    ret = conf[entry]
    ret = Marsdawn::Util.hash_symbolize_keys(ret) if ret.kind_of?(Hash)
    ret
  end

  def to_hash key
    raise "Cannot find the configuration for '#{key}' in marsdawn.yml." unless @config.key?(key)
    Marsdawn::Util.hash_symbolize_keys(@config[key])
  end

end
