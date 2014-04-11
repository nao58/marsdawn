# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))
require File.expand_path('source_agent', File.dirname(__FILE__))

describe Marsdawn::Source, 'when initialized' do
  it 'should be specified exists source path.' do
    proc {Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'dummy'))}.should raise_error(RuntimeError, /^No source directory/)
  end
  it 'should find config file at the source path.' do
    proc {Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'no_config'))}.should raise_error(RuntimeError, /^There is no config file/)
  end
  it 'should be specified document key.' do
    proc {Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'no_key'))}.should raise_error(RuntimeError, /^The document key should be specified/)
  end
  it 'should load config file.' do
    mdx = Marsdawn::SourceAgent.new(File.join($TEST_DOC_DIR, 'docs01'))
    mdx.config[:lang].should eq('en')
    mdx.config[:title].should eq('Test Document')
  end
end

describe Marsdawn::Source, 'when compile using FileSystem storage' do
  it 'should create right documents.' do
    #mdx = Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'docs01'))
    #mdx.compile :type => 'FileSystem', :path => $COMPILED_DOC_DIR
    #mdx = Marsdawn::Source.new('/Users/nao58/Development/kramdown-docs')
    #mdx.compile :type => 'FileSystem', :path => $COMPILED_DOC_DIR
  end
end
