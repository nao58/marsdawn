# encoding: utf-8

class Marsdawn::Search

  def self.create_index opts, storage
    self.get(opts, storage).create_index
  end

  def self.get opts, storage
    opts = Marsdawn::Util.hash_symbolize_keys(opts)
    key = opts[:type]
    unless self.const_defined?(key)
      require_file = Marsdawn::Util.class_to_underscore(key)
      fullpath = File.join(File.dirname(__FILE__), 'search', "#{key}.rb")
      raise "Undefined search driver type '#{key}'." unless File.exists?(fullpath)
      require fullpath
    end
    self.const_get(key).new opts, storage
  end

end
