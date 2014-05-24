# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))
require File.expand_path(File.join('../../../lib/marsdawn', 'source'), File.dirname(__FILE__))

describe Marsdawn::Source do
  context 'when access to invalid source document' do
    it 'should raise error when the specified path does not exist.' do
      expect {Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'dummy'))}.to raise_error(RuntimeError, /^No source directory/)
    end
    it 'should raise error when the doc_info file does not exist.' do
      expect {Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'no_config'))}.to raise_error(RuntimeError, /^There is no doc_info file/)
    end
    it 'should raise error when the document key is not specified in the config file.' do
      expect {Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'no_key'))}.to raise_error(RuntimeError, /^The document key should be specified/)
    end
  end
  context 'when access to valid source document' do
    it 'should load config file.' do
      mdx = Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'docs01'))
      info = mdx.doc_info
      expect(info[:key]).to eq 'test_docs01'
      expect(info[:lang]).to eq 'en'
      expect(info[:title]).to eq 'Test Document'
      expect(info[:version]).to eq '0.0.1'
    end
    it 'should use default options.' do
      mdx = Marsdawn::Source.new(File.join($TEST_DOC_DIR, 'docs01'))
      info = mdx.doc_info
      expect(info[:markdown_extname]).to eq '.md'
      expect(info[:encoding]).to eq 'utf-8'
      expect(info[:link_defs]).to eq({})
    end
  end
end
