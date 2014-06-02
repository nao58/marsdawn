# encoding: utf-8

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))

describe Marsdawn::Site::Page do

  before :all do
    @source_path = File.join($TEST_DOC_DIR, 'docs01')
    @storage_config = {type: 'FileSystem', path: $COMPILED_DOC_DIR}
    Marsdawn.build do |config|
      config[:source] = @source_path
      config[:storage] = @storage_config
    end
    @site = Marsdawn::Site.new(key: 'test_docs01') do |config|
      config[:storage] = @storage_config
    end
  end

  def site
    @site
  end

  def page
    @page
  end

  context 'with top page' do
    before :all do
      @page = site.page('/')
    end
    it 'should return the page title.' do
      expect(page.title).to eq('Test Document 01')
    end
    it 'should return the breadcrumb.' do
      expect(page.breadcrumb).to eq({})
      expect(page.breadcrumb.to_s).to eq('')
    end
    it 'should return the neighbor pages.' do
      expect(page.neighbor.keys).to eq(%w(/about /tutorial /appendix))
    end
    it 'should return the top page.' do
      expect(page.top.uri).to eq('/')
    end
    it 'should return the parent page.' do
      expect(page.parent).to be_nil
    end
    it 'should return the under pages.' do
      expect(page.under.keys).to eq(%w(/about /tutorial /tutorial/install /tutorial/getting_start /reference/1up /reference/each /reference/z-index /appendix))
    end
    it 'should return the page navigation.' do
      expect(page.page_nav[:prev_page]).to be_nil
      expect(page.page_nav[:next_page].uri).to eq('/about')
      expect(page.page_nav.to_s).to match(/^<ul>.*<\/ul>$/m)
    end
    it 'should return the link object to this page.' do
      expect(page.link.uri).to eq('/')
      expect(page.link.to_s).to eq('<a href="/" title="Test Document 01">Test Document 01</a>')
    end
  end

  context 'with middle page' do
    before :all do
      @page = site.page('/tutorial')
    end
    it 'should return the breadcrumb.' do
      expect(page.breadcrumb.keys).to eq(%w(/))
    end
    it 'should return the neighbor pages.' do
      expect(page.neighbor.keys).to eq(%w(/about /tutorial /appendix))
    end
    it 'should return the top page.' do
      expect(page.top.uri).to eq('/')
    end
    it 'should return the parent page.' do
      expect(page.parent.uri).to eq('/')
    end
    it 'should return the under pages.' do
      expect(page.under.keys).to eq(%w(/tutorial/install /tutorial/getting_start))
    end
    it 'should return the page navigation.' do
      expect(page.page_nav[:prev_page].uri).to eq('/about')
      expect(page.page_nav[:next_page].uri).to eq('/tutorial/install')
    end
    it 'should return the link object to this page.' do
      expect(page.link.uri).to eq('/tutorial')
      expect(page.link.to_s).to eq('<a href="/tutorial" title="Tutorial">Tutorial</a>')
    end
  end

  context 'with bottom page' do
    before :all do
      @page = site.page('/tutorial/install')
    end
    it 'should return the breadcrumb.' do
      expect(page.breadcrumb.keys).to eq(%w(/ /tutorial))
    end
    it 'should return the neighbor pages.' do
      expect(page.neighbor.keys).to eq(%w(/tutorial/install /tutorial/getting_start))
    end
    it 'should return the top page.' do
      expect(page.top.uri).to eq('/')
    end
    it 'should return the parent page.' do
      expect(page.parent.uri).to eq('/tutorial')
    end
    it 'should return the paretn pages.' do
      expect(page.parent.uri).to eq('/tutorial')
    end
    it 'should return the under pages.' do
      expect(page.under.keys).to eq(%w())
    end
    it 'should return the page navigation.' do
      expect(page.page_nav[:prev_page].uri).to eq('/tutorial')
      expect(page.page_nav[:next_page].uri).to eq('/tutorial/getting_start')
    end
    it 'should return the link object to this page.' do
      expect(page.link.uri).to eq('/tutorial/install')
      expect(page.link.to_s).to eq('<a href="/tutorial/install" title="Install">Install</a>')
    end
  end

end
