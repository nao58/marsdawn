# encoding: utf-8

class Marsdawn::Search

  def self.create_index storage, opts
    self.get(storage, opts).create_index
  end

  def self.get storage, opts
    opts = Marsdawn::Util.hash_symbolize_keys(opts)
    key = opts[:type]
    @@base_path ||= File.join(File.dirname(__FILE__), 'search')
    Marsdawn::Util.adapter(self, class_name, @@base_path).new config, opts
  end

end
