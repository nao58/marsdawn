# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

describe Marsdawn::Site do

  before :all do
    @source_path = File.join($TEST_DOC_DIR, 'docs01')
    @storage_config = {type: 'FileSystem', path: $COMPILED_DOC_DIR}
    Marsdawn.compile do |config|
      config[:source] = @source_path
      config[:storage] = @storage_config
    end
  end

  def site
    @site
  end

  context 'with default options' do
    before :all do
      @site = Marsdawn::Site.new({key: 'test_docs01'}, {storage: @storage_config})
    end
    it 'should return full path.' do
      expect(site.full_path('/about')).to eq('/about')
      expect(site.full_path('/reference/each')).to eq('/reference/each')
    end
  end
  context 'with default options' do
    before :all do
      @site = Marsdawn::Site.new({key: 'test_docs01', base_path: '/test'}, {storage: @storage_config})
    end
    it 'should return full path.' do
      expect(site.full_path('/about')).to eq('/test/about')
      expect(site.full_path('/reference/each')).to eq('/test/reference/each')
    end
  end

end
