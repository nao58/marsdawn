# encoding: utf-8

require 'kramdown'
require 'marsdawn/source/front_matter'
require 'marsdawn/source/kramdown/parser'

class Marsdawn::Source
  class Document < Kramdown::Document

    attr_accessor :front_matter

    def self.read path, options={}
      text = open(path).read
      new(text, options).tap do |doc|
        title = File.basename(path, '.*').gsub(/^\d+_/, '').gsub(/_|-/, ' ').capitalize
        doc.front_matter[:title] ||= title
        doc.front_matter[:link_key] ||= title
      end
    end

    def initialize text, options={}
      doc = FrontMatter.new(text)
      @front_matter = {}
      options[:input] = 'Marsdawn'
      super doc.content, options
      @front_matter.merge! Kramdown::Parser::Marsdawn.front_matter
      @front_matter.merge! doc.attr
    end

    def front_matter
      @front_matter
    end

  end
end
