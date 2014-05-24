# encoding: utf-8

class Marsdawn::Storage::Base

  def initialize config, opts
    @config = config
    @opts = opts
  end

  def key
    @opts[:key]
  end

  def lang
    @opts[:lang]
  end

  def version
    @opts[:version]
  end

  def finalize
  end

  def clean_up
  end

  def set_document_info doc_info
    raise NotImplementedError.new("#{self.class.name}#set_document_info() is not implemented.")
  end

  def set uri, content, exvars, sysinfo
    raise NotImplementedError.new("#{self.class.name}#set() is not implemented.")
  end

  def get_document_info
    raise NotImplementedError.new("#{self.class.name}#get_document_info() is not implemented.")
  end

  def get uri
    raise NotImplementedError.new("#{self.class.name}#get() is not implemented.")
  end

end
