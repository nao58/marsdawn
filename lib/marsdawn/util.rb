# encoding: utf-8

class Marsdawn::Util

  def self.hash_symbolize_keys hash, deep=false
    hash.each_with_object({}) do |(key, val), ret|
      val = hash_symbolize_keys(val, deep) if deep && val.kind_of?(Hash)
      ret[key.to_sym] = val
    end
  end

  def self.hash_symbolize_keys_deep hash
    hash_symbolize_keys hash, true
  end

  def self.class_to_underscore class_name
      class_name.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').gsub(/([a-z\d])([A-Z])/,'\1_\2').tr('-','_').downcase
  end

  def self.strip_tags text
    text.gsub(/<[^>]*>/ui, '')
  end

  def self.html_escape str
    CGI.escapeHTML str
  end

  def self.attr_escape str
    str.gsub(/"/, '\"')
  end

  def self.adapter namespace, class_name, base_path
    unless namespace.const_defined?(class_name, false)
      require File.join(base_path, class_to_underscore(class_name))
    end
    namespace.const_get(class_name)
  end

end
