# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

describe Marsdawn::Site do

  before :all do
    @source_path = File.join($TEST_DOC_DIR, 'docs01')
    @storage_config = {type: 'FileSystem', path: $COMPILED_DOC_DIR}
    Marsdawn.build do |config|
      config[:source] = @source_path
      config[:storage] = @storage_config
    end
  end

  def site
    @site
  end

  context 'with default options' do
    before :all do
      @site = Marsdawn::Site.new(key: 'test_docs01') do |config|
        config[:storage] = @storage_config
      end
    end
    it 'should return the page.' do
      expect(site.page('/tutorial/install')).to be_a_kind_of(Marsdawn::Site::Page)
    end
    it 'should return full path.' do
      expect(site.full_path('/about')).to eq('/about')
      expect(site.full_path('/reference/each')).to eq('/reference/each')
    end
    it 'should return the index.' do
      expect(site.index).to be_a_kind_of(Marsdawn::Site::Indexer)
      expect(site.index.to_s).to match(/<ul>.*<\/ul>/)
    end
    it 'should return the page title.' do
      expect(site.page_title('/about')).to eq('About')
      expect(site.page_title('/tutorial/getting_start')).to eq('Getting start using MarsDawn')
    end
    it 'should return the site title.' do
      expect(site.title).to eq('Test Document')
    end
    it 'should return the site title link.' do
      expect(site.title_link.uri).to eq('/')
    end
    it 'should return if the site is searchable.' do
      expect(site.searchable?).to be_falsey
    end
  end

  context 'with base_path options' do
    before :all do
      @site = Marsdawn::Site.new(key: 'test_docs01', base_path: '/test') do |config|
        config[:storage] = @storage_config
      end
    end
    it 'should return full path.' do
      expect(site.full_path('/about')).to eq('/test/about')
      expect(site.full_path('/reference/each')).to eq('/test/reference/each')
    end
    it 'should return the site title link.' do
      expect(site.title_link.uri).to eq('/test/')
    end
  end

end
