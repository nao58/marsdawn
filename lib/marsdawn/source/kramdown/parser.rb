# encoding: utf-8

class Kramdown::Parser::Marsdawn < Kramdown::Parser::Kramdown

  def self.front_matter
    @@front_matter
  end

  def parse
    @@front_matter = {}
    super
  end

  def parse_setext_header
    ret = super
    handle_header @src[1], @src[3].to_i
    ret
  end

  def parse_atx_header
    ret = super
    handle_header @src[2].to_s.strip, @src[1].length
    ret
  end

  def handle_extension(name, opts, body, type)
    case name
    when 'front_matter'
      opts.each do |key, val|
        @@front_matter[key.to_sym] = val
        @@front_matter[:link_key] = val if key == 'title'
      end
      true
    else
      super name, opts, body, type
    end
  end

  private
  def handle_header title, level
    add_title_vars title
    insert_title_anchor title if level < 4
  end

  def add_title_vars title
    @@front_matter[:title] = title unless @@front_matter.key?(:title)
    @@front_matter[:link_key] = title unless @@front_matter.key?(:link_key)
  end

  def insert_title_anchor title
    anchor_name = title.downcase.gsub(' ', '-')
    @tree.children.last.children.insert 0, Element.new(:raw, %!<a name="#{anchor_name}"></a>!, 'type' => 'html')
    @@front_matter[:anchors] ||= {}
    @@front_matter[:anchors][title] = anchor_name
  end
end
