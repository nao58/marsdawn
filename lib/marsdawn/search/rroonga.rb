# encoding: utf-8

class Marsdawn::Search::Rroonga

  def initialize opts, storage
    unless Module.const_defined?('Groonga')
      raise "Gem 'rroonga' should be installed." unless require 'groonga'
    end
    raise "The groonga database path should be specified" unless opts.key?(:path)
    @opts = {
      index_table: {}
    }.merge(opts)
    @storage = storage
    Groonga::Database.open(opts[:path])
    @table_prefix = "#{@storage.key}-#{@storage.lang}-#{@storage.version.tr('.','_')}"
  end

  def create_tables
    index_table = {
      :type => :patricia_trie,
      :normalizer => :NormalizerAuto,
      :default_tokenizer => 'TokenBigram'
    }.merge(@opts[:index_table])
    Groonga::Schema.create_table(table_name('documents'), :type => :hash) do |tbl|
      tbl.text('title')
      tbl.text('content')
    end
    Groonga::Schema.create_table(table_name('terms'), index_table) do |tbl|
      tbl.index(col_name('documents', 'title'))
      tbl.index(col_name('documents', 'content'))
    end
  end

  def drop_tables
    Groonga::Schema.remove_table(table_name('documents'))
    Groonga::Schema.remove_table(table_name('terms'))
  rescue Groonga::Schema::TableNotExists
  end

  def create_index
    drop_tables
    create_tables
    docs = table('documents')
    index = @storage.get_document_info[:site_index]
    index.each do |uri, title|
      page = @storage.get(uri)
      docs.add(uri, :title => title, :content => Marsdawn::Util.strip_tags(page[:content]))
    end
  end

  def search keyword, opts={}
    snippet = Groonga::Snippet.new(html_escape: true, default_open_tag: '<strong>', default_close_tag: '</strong>', normalize: true)
    words = keyword.scan(/(?:\w|"[^"]*")+/).map{|w| w.delete('"')}
    words.each{|word| snippet.add_keyword(word, opts)}
    docs = table('documents')
    docs.select do |rec|
      expression = nil
      words.each do |word|
        sub_exp = (rec.content =~ word)
        if expression.nil?
          expression = sub_exp
        else
          expression &= sub_exp
        end
      end
      expression
    end.map{|rec| {uri: rec.key.key, title: rec.title, results: snippet.execute(rec.content)}}
  end

  private
  def table_name name
    "#{@table_prefix}-#{name}"
  end

  def table name
    Groonga[table_name(name)]
  end

  def col_name table, column
    "#{table_name(table)}.#{column}"
  end

end
