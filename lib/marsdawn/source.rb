# encoding: utf-8

require 'yaml'
require 'kramdown'
require 'marsdawn/kramdown/parser'

class Marsdawn::Source

  def initialize path
    @path = File.expand_path(path)
    raise "No source directory '#{@path}'." unless File.exists?(@path)
    @config = {
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
    load_config
    @comile_options = {}
  end

  def key
    @config[:key]
  end

  def compile_options opts
    @compile_opts = opts
  end

  def config
    @config
  end

  def compile storage
    investigate_source
    output_documents storage
  end

  protected
  def load_config
    config_file = File.join(@path, '.marsdawn.yml')
    raise "There is no config file '.marsdawn.yml' in '#{@path}'" unless File.exists?(config_file)
    conf = Marsdawn::Util.hash_symbolize_keys(YAML.load_file(config_file))
    @config.merge! conf
    @doc_key = @config[:key]
    raise "The document key should be specified in .marsdawn.yml." if @doc_key.nil? || @doc_key.empty?
  end

  def investigate_source
    @local2uri = {}
    @exvars = {}
    @sysinfo = {}
    digg @path
    update_sysinfo
  end

  def output_documents storage
    storage.prepare
    storage.set_document_config create_config
    @local2uri.each do |file, uri|
      storage.set uri, markdown(file, uri), @exvars[uri], @sysinfo[uri]
    end
    storage.finalize
  rescue => ex
    storage.clean_up unless storage.nil?
    raise ex
  end

  def link_defs base_uri
    base_path = Pathname(File.dirname(base_uri))
    ret = @exvars.each_with_object({}) do |(uri, vars), defs|
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
    @config[:link_defs].each do |key, link|
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

  def markdown file, uri
    f = open(file)
    opts = @compile_opts[:kramdown] || {}
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
      uri_item = item
      uri_item = $1 if uri_item =~ /^\d+_(.*)/
      if File.directory?(fullpath)
        digg fullpath, "#{uri}/#{uri_item}"
      elsif item != @config[:directory_index]
        extname = File.extname(item)
        if extname == @config[:markdown_extname]
          uri_item = File.basename(uri_item, extname)
          fulluri = "#{uri}/#{uri_item}"
          @local2uri[fullpath] = fulluri
          @exvars[fulluri] = read_exvars(fullpath, uri_item)
          @sysinfo[fulluri] = {:type => 'folder'}
        end
      end
    end
  end

  def read_directory_index path, uri
    indexfile = File.join(path, @config[:directory_index])
    if File.exists?(indexfile)
      uri = (uri == '' ? '/' : uri)
      @local2uri[indexfile] = uri
      @exvars[uri] = read_exvars(indexfile, File.basename(uri))
      @sysinfo[uri] = {:type => 'page'}
    end
  end

  def read_exvars file, name
    f = open(file)
    opts = @config[:kramdown_options]
    opts[:input] = 'Marsdawn'
    doc = Kramdown::Document.new(f.read, opts)
    exvars = Kramdown::Parser::Marsdawn.exvars
    exvars[:title] = name.gsub('_', ' ').gsub('-', ' ').capitalize unless exvars.key?(:title)
    exvars
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

  def create_breadcrumb uri
    uri.split('/').each_with_object([]) do |dir, ret|
      parent = (ret.last == '/' ? '' : ret.last)
      path = "#{parent}/#{dir}"
      ret << path unless uri == path
    end
  end

  def create_config
    ret = @config.dup
    ret[:site_index] = create_site_index
    ret
  end

  def create_site_index
    @exvars.each_with_object({}) do |(uri, vars), ret|
      ret[uri] = vars[:title]
    end
  end

end
