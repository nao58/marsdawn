# encoding: utf-8

require "marsdawn/source"

class Marsdawn::Builder

  def self.build config
    raise "No specification for source path." unless config.key?(:source)
    raise "No specification for storage config." unless config.key?(:storage)
    source = Marsdawn::Source.new(config[:source])
    storage = Marsdawn::Storage.get(config[:storage], source.doc_info)
    build_source source, storage, config[:build_options]
    create_search_index storage, config[:search] if config.key?(:search)
  end

  def self.build_source source, storage, options
    options ||= {}
    kramdown_options = options[:kramdown] || {}
    storage.prepare
    storage.set_document_info source.doc_info
    source.each_contents(kramdown_options) do |uri, content, front_matter, sysinfo|
      storage.set uri, content, front_matter, sysinfo
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
