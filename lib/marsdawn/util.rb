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

  def self.class_exists? class_name, base=Module
    if base.const_defined?(class_name)
      base.const_get(class_name).is_a?(Class)
    else
      false
    end
  rescue NameError
    false
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

end
