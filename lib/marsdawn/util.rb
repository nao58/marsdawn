# encoding: utf-8

class Marsdawn::Util

  def self.hash_symbolize_keys hash
    hash.each_with_object({}){|(k,v),h| h[k.to_sym]=v}
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

end
