# encoding: utf-8

require "marsdawn/source"

class Marsdawn::Compiler

  def self.compile config
    raise "No specification for source path." unless config.key?(:source)
    raise "No specification for storage config." unless config.key?(:storage)
    source = Marsdawn::Source.new(config[:source])
    storage = Marsdawn::Storage.get(config[:storage], source.doc_info)
    compile_source source, storage, config[:compile_options]
    create_search_index storage, config[:search]
  end

  def self.compile_source source, storage, options
    options ||= {}
    kramdown_options = options[:kramdown] || {}
    storage.prepare
    storage.set_document_info source.doc_info
    source.each_contents(kramdown_options) do |uri, content, exvars, sysinfo|
      storage.set uri, content, exvars, sysinfo
    end
    storage.finalize
  rescue => ex
    storage.clean_up
    raise ex
  end

  def self.create_search_index storage, options
    options ||= {}
    Marsdawn::Search.create_index storage, options
  end

end
