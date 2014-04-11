# encoding: utf-8

require 'marsdawn/storage/base'
require 'yaml'

class Marsdawn::Storage::FileSystem < Marsdawn::Storage::Base

  def initialize config, opts
    @config = {
      tmp_dir: '/tmp',
      mode_dir: 0755,
      mode_file: 0644
    }.merge(config)
    raise "Not specify the local storage path name." unless @config.key?(:path)
    @path = File.expand_path(@config[:path])
    raise "There is no directory to compile to '#{@path}'." unless File.exists?(@path)
    @opts = opts
    set_target_path
  end

  def prepare
    setup_tmp_dir
  end

  def finalize
    target_dir = File.dirname(@target_path)
    FileUtils.mkdir_p target_dir, :mode => @config[:mode_dir] unless File.exists?(target_dir)
    FileUtils.remove_entry_secure @target_path if File.exists?(@target_path)
    FileUtils.mv @tmproot, @target_path
  end

  def clean_up
    FileUtils.remove_entry_secure @tmproot
  end

  def set_document_config config
    File.write @tmp_config_file, YAML.dump(config)
  end

  def set uri, content, exvars, sysinfo
    fullpath = tmp_page_file(uri)
    dir = File.dirname(fullpath)
    FileUtils.mkdir_p dir, :mode => @config[:mode_dir] unless File.exists?(dir)
    data = {content: content, exvars: exvars, sysinfo: sysinfo}
    File.write fullpath, YAML.dump(data)
  end

  def get_document_config
    YAML.load_file @config_file
  end

  def get uri
    fullpath = page_file(uri)
    YAML.load_file fullpath
  end

  private
  def set_target_path
    key = @opts[:key] || '-'
    lang = @opts[:lang] || 'en'
    version = @opts[:version] || '0.0.1'
    @target_path = File.join(@path, key, lang, version)
    @config_file = File.join(@target_path, '.config.yml')
  end

  def setup_tmp_dir
    tmp_dir = @config[:tmp_dir]
    "The work directory '#{tmp_dir}' does not exist." unless File.exists?(tmp_dir)
    @tmproot = File.join(tmp_dir, "__tmp_#{$$}_#{Time.now.to_i}")
    Dir.mkdir @tmproot, @config[:mode_dir]
    @tmp_config_file = File.join(@tmproot, '.config.yml')
  end

  def tmp_page_file uri
    File.join(@tmproot, "#{uri}_.mdd")
  end

  def page_file uri
    File.join(@target_path, "#{uri}_.mdd")
  end

end
