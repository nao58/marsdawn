# encoding: utf-8

class Kramdown::Parser::Marsdawn < Kramdown::Parser::Kramdown

  def self.exvars
    @@exvars
  end

  def parse
    @@exvars = {}
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
    when 'marsdawn'
      opts.each do |key, val|
        @@exvars[key.to_sym] = val
        @@exvars[:link_key] = val if key == :title
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
    @@exvars[:title] = title unless @@exvars.key?(:title)
    @@exvars[:link_key] = title unless @@exvars.key?(:link_key)
  end

  def insert_title_anchor title
    anchor_name = title.downcase.gsub(' ', '-')
    @tree.children.last.children.insert 0, Element.new(:raw, %!<a name="#{anchor_name}"></a>!, 'type' => 'html')
    @@exvars[:anchors] ||= {}
    @@exvars[:anchors][title] = anchor_name
  end
end
