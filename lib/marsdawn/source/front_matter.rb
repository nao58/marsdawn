# encoding: utf-8

require 'yaml'

module Marsdawn
  class Source
    class FrontMatter

      attr_reader :attr, :content

      def initialize text
        m = text.match(/\A---*\n(?<attr>.*?)\n---*\n(?<content>.*)$/m)
        if m.nil?
          @attr = {}
          @content = text
        else
          @attr = Marsdawn::Util.hash_symbolize_keys_deep(YAML.load(m[:attr]))
          raise 'Invalid front-matter format.' unless @attr.kind_of?(Hash)
          @content = m[:content]
        end
      end

    end
  end
end
