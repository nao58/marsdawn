# encoding: utf-8

require 'yaml'
require 'marsdawn/source/document'

class Marsdawn::Source

  attr_reader :doc_info

  def initialize path
    @path = File.expand_path(path)
    raise "No source directory '#{@path}'." unless File.exists?(@path)
    @doc_info = {
      key: nil,
      lang: 'en',
      title: '',
      version: '0.0.0',
      markdown_extname: '.md',
      directory_index: '.index.md',
      encoding: 'utf-8',
      link_defs: {},
      kramdown_options: {}
    }
    load_doc_info
    investigate
  end

  def each_contents options
    @local2uri.each do |file, uri|
      yield uri, markdown(file, uri, options), @front_matter[uri], @sysinfo[uri]
    end
  end

  protected
  def load_doc_info
    doc_info_file = File.join(@path, '.marsdawn.yml')
    raise "There is no doc_info file '.marsdawn.yml' in '#{@path}'" unless File.exists?(doc_info_file)
    conf = Marsdawn::Util.hash_symbolize_keys(YAML.load_file(doc_info_file))
    @doc_info.merge! conf
    @doc_key = @doc_info[:key]
    raise "The document key should be specified in .marsdawn.yml." if @doc_key.nil? || @doc_key.empty?
  end

  def investigate
    @local2uri = {}
    @front_matter = {}
    @sysinfo = {}
    digg @path
    update_sysinfo
    update_docinfo
  end

  def link_defs base_uri
    ret = relative_link_defs_from_front_matter base_uri
    base_path = Pathname(File.dirname(base_uri))
    @doc_info[:link_defs].each do |key, link|
      uri, title = link
      if uri.start_with?('/')
        rel_path = Pathname(uri).relative_path_from(base_path).to_s
      else
        rel_path = uri
      end
      ret[key] = [rel_path, title]
    end
    ret
  end

  def relative_link_defs_from_front_matter base_uri
    base_path = Pathname(File.dirname(base_uri))
    @front_matter.each_with_object({}) do |(uri, vars), defs|
      if vars.key?(:link_key)
        rel_path = Pathname(uri).relative_path_from(base_path).to_s
        defs[vars[:link_key]] = [rel_path, vars[:title]]
        if vars.key?(:anchors)
          vars[:anchors].each do |title, anchor_name|
            defs["#{vars[:link_key]} - #{title}"] = ["#{rel_path}\##{anchor_name}", title]
            defs[title] = ["\##{anchor_name}", title] if base_uri == uri
          end
        end
      end
    end
  end

  def markdown file, uri, opts
    f = open(file)
    opts[:input] = 'Marsdawn'
    opts[:link_defs] = link_defs(uri)
    Kramdown::Document.new(f.read, opts).to_html
  end

  def digg path, uri=''
    Dir.chdir path
    items = Dir.glob('*').sort
    read_directory_index path, uri
    items.each do |item|
      fullpath = File.join(path, item)
      uri_item = (item =~ /^\d+_(.*)/ ? $1 : item)
      if File.directory?(fullpath)
        digg fullpath, "#{uri}/#{uri_item}"
      elsif uri_item != @doc_info[:directory_index]
        set_page_info fullpath, uri, uri_item
      end
    end
  end

  def set_page_info fullpath, uri, uri_item
    extname = File.extname(uri_item)
    if extname == @doc_info[:markdown_extname]
      uri_item = File.basename(uri_item, extname)
      fulluri = "#{uri}/#{uri_item}"
      @local2uri[fullpath] = fulluri
      @front_matter[fulluri] = read_front_matter(fullpath, uri_item)
      @sysinfo[fulluri] = {:type => 'folder'}
    end
  end

  def read_directory_index path, uri
    indexfile = File.join(path, @doc_info[:directory_index])
    if File.exists?(indexfile)
      uri = (uri == '' ? '/' : uri)
      @local2uri[indexfile] = uri
      @front_matter[uri] = read_front_matter(indexfile, File.basename(uri))
      @sysinfo[uri] = {:type => 'page'}
    end
  end

  def read_front_matter file, name
    f = open(file)
    opts = @doc_info[:kramdown_options]
    opts[:input] = 'Marsdawn'
    doc = Kramdown::Document.new(f.read, opts)
    front_matter = Kramdown::Parser::Marsdawn.front_matter
    front_matter[:title] ||= name.gsub('_', ' ').gsub('-', ' ').capitalize
    front_matter
  end

  def update_sysinfo
    prev_page = nil
    @sysinfo.each do |uri, info|
      @sysinfo[uri][:uri] = uri
      @sysinfo[uri][:level] = uri.count('/')
      @sysinfo[uri][:breadcrumb] = create_breadcrumb(uri)
      @sysinfo[uri][:parent] = @sysinfo[uri][:breadcrumb].last
      @sysinfo[uri][:prev_page] = nil
      @sysinfo[uri][:next_page] = nil
      unless prev_page.nil?
        @sysinfo[uri][:prev_page] = prev_page
        @sysinfo[prev_page][:next_page] = uri
      end
      prev_page = uri
    end
  end

  def update_docinfo
    @doc_info[:site_index] = create_site_index
  end

  def create_breadcrumb uri
    uri.split('/').each_with_object([]) do |dir, ret|
      parent = (ret.last == '/' ? '' : ret.last)
      path = "#{parent}/#{dir}"
      ret << path unless uri == path
    end
  end

  def create_site_index
    @front_matter.each_with_object({}) do |(uri, vars), ret|
      ret[uri] = vars[:title]
    end
  end

end
