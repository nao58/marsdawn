# encoding: utf-8

require "marsdawn/storage/base"

class Marsdawn::Storage::Test < Marsdawn::Storage::Base

  def initialize config, opts
    super
    @storage = {}
  end

  def set path, page, exvars, sysinfo
    @storage[path] = {:page => page, :exvars => exvars, :sysinfo => sysinfo}
  end

  def get path
    @storage[path]
  end

end
