# encoding: utf-8

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))
Marsdawn.require_lib 'storage/file_system'

describe Marsdawn::Storage::FileSystem do

  before do
    conf = {path: $COMPILED_DOC_DIR}
    opts = {key: 'unit_test'}
    @storage = Marsdawn::Storage::FileSystem.new(conf, opts)
  end

  it 'should write and read the document info.' do
    doc_info = {foo: 'bar', xyz: 999, arr: %w(a b c)}
    @storage.prepare
    @storage.set_document_info doc_info
    @storage.finalize
    expect(@storage.get_document_info).to eq(doc_info)
  end

  it 'should write and read the documents.' do
    data = {}
    data['/'] = {
      content: "This is a test document.\nIt can include <tag>markup tag</tag>.",
      front_matter: {title: 'Test Document'},
      sysinfo: {type: :develop}}
    data['/about'] = {
      content: "",
      front_matter: {title: 'About Page'},
      sysinfo: {type: :permanent}}
    @storage.prepare
    data.each do |uri, d|
      @storage.set uri, d[:content], d[:front_matter], d[:sysinfo]
    end
    @storage.finalize
    data.each do |uri, d|
      expect(@storage.get(uri)).to eq(d)
    end
  end

  it 'should return nil when the document does not exist.' do
    expect(@storage.get('/not_exists')).to eq(nil)
  end

end
