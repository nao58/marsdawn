# encoding: utf-8

require 'yaml'

module Marsdawn
  class Command
    attr_accessor :editor, :auto_editor

    class ParamError < Exception; end
    class RuntimeError < Exception; end

    def self.exec argv
      raise ParamError.new("No command is specified.") if argv.empty?
      cmd = new
      command = argv.shift.to_sym
      raise ParamError.new("Unknown command '#{command}'.") unless cmd.respond_to?(command)
      value = (argv.size > 0 ? argv.shift : nil)
      opts = parse_options(argv)
      cmd.__send__ command, value, opts
    end

    def initialize
      @editor = 'vim'
      @auto_editor = true
      read_dot_marsdawn
    end

    def create title, opts={}
      key = (opts.key?(:file) ? opts[:file] : file_namize(title))
      path = File.expand_path(key)
      raise "The directory '#{doc_name}' already exists." if File.exists?(path)
      Dir.mkdir path
      data = {key: key, title: title, lang: 'en', version: '0.0.1'}
      dot_file = File.join(path, '.marsdawn.yml')
      index_file = File.join(path, '.index.md')
      File.write dot_file, YAML.dump(data)
      create_page index_file, title, 'title' => title
      edit_cmd dot_file, index_file if @auto_editor || opts[:edit]
    end

    def dir title, opts={}
      dir = (opts.key?(:file) ? opts[:file] : file_namize(title))
      dir = add_num(dir, opts)
      path = File.expand_path(dir)
      Dir.mkdir path
      index_file = File.join(path, '.index.md')
      create_page index_file, title, 'title' => title
      edit_cmd index_file if @auto_editor || opts[:edit]
    end

    def page title, opts={}
      file = (opts.key?(:file) ? "#{opts[:file]}.md" : file_namize(title, '.md'))
      file = File.expand_path(add_num(file, opts))
      create_page file, title, 'title' => title
      edit_cmd file if @auto_editor || opts[:edit]
    end

    def renum step, opts={}
      step = (step.nil? ? 10 : step.to_i)
      num = 0
      list = Dir.glob('*').each_with_object({}) do |item, ret|
        num += step
        ret[item] = add_num(item, num: num, step: step)
      end
      list.each do |src, dest|
        src = File.expand_path(src)
        dest = File.expand_path(dest)
        FileUtils.mv src, dest unless src == dest
      end
      'ls -1'
    end

    def debug type, opts={} 
      case type
      when 'options'
        opts
      end
    end

    private
    def self.parse_options argv
      opts = {}
      while argv.size > 0 do
        key = opt_key(argv.shift)
        val = true
        val = argv.shift if argv.size > 0 && !argv.first.start_with?('-')
        opts[key] = val
      end
      opts
    end

    def self.opt_key switch
      opt_keys = {
        'e' => 'edit',
        'f' => 'file',
        'n' => 'num',
        'o' => 'no-num',
        's' => 'step'
      }
      key = switch
      if key =~ /^--(.+)$/
        key = $1
      elsif key =~ /^-(.+)$/
        key = opt_keys[$1]
      end
      raise ParamError.new("Unknown option '#{switch}'.") unless opt_keys.values.include?(key)
      key.to_sym
    end

    def read_dot_marsdawn
      dotfile = File.expand_path("#{ENV['HOME']}/.marsdawn")
      instance_eval(open(dotfile).read) if File.exists?(dotfile)
    end

    def file_namize title, ext=''
      "#{title.downcase.gsub(' ', '-')}#{ext}"
    end

    def create_page path, title, front_matter={}
      File.write(path, "#{YAML.dump(front_matter)}---\n\n# #{title}\n\n")
    end

    def file_num file
      file =~ /^(\d+)_(.+)$/ ? $1.to_i : 0
    end

    def file_name file
      file =~ /^(\d+)_(.+)$/ ? $2 : file
    end


    def step opts
      opts.key?(:step) ? opts[:step] : 10
    end

    def add_num file, opts
      if opts.key?(:num)
        num = opts[:num]
        num = max_num + step(opts) if num.is_a?(TrueClass)
        num = "000#{num}".slice(-3, 3)
        file = "#{num}_#{file_name(file)}"
      end
      file
    end

    def max_num
      list = Dir.glob('*')
      list.size > 0 ? list.map{|item| file_num(item)}.max : 0
    end

    def edit_cmd *args
      "#{@editor} #{args.join(" ")}"
    end

  end
end
