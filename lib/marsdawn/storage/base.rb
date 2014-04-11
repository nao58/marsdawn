# encoding: utf-8

class Marsdawn::Storage::Base

  def initialize settings, config
    @settings = settings
    @config = config
  end

  def finalize
  end

  def clean_up
  end

  def set_document_config config
    raise NotImplementedError.new("#{self.class.name}#set_document_config() is not implemented.")
  end

  def set uri, content, exvars, sysinfo
    raise NotImplementedError.new("#{self.class.name}#set() is not implemented.")
  end

  def get_document_config
    raise NotImplementedError.new("#{self.class.name}#get_document_config() is not implemented.")
  end

  def get uri
    raise NotImplementedError.new("#{self.class.name}#get() is not implemented.")
  end

end
