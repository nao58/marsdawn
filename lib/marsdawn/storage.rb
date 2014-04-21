# encoding: utf-8

class Marsdawn::Storage

  def self.get config, opts={}
    opts = {key: 'default', lang: 'en', version: '0.0.1'}.merge(opts)
    config = handle_config(config, opts)
    raise "No storage type is specified." unless config.key?(:type)
    class_name = config[:type]
    unless self.const_defined?(class_name)
      require_file = Marsdawn::Util.class_to_underscore(class_name)
      fullpath = File.join(File.dirname(__FILE__), 'storage', "#{require_file}.rb")
      raise "Undefined storage type '#{class_name}'." unless File.exists?(fullpath)
      require fullpath
    end
    self.const_get(class_name).new config, opts
  end

  def self.handle_config config, opts
    if config.nil?
      Marsdawn::Config.instance.get(opts[:key], :storage)
    else
      Marsdawn::Util.hash_symbolize_keys(config)
    end
  end

end
