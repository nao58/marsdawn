# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

describe Marsdawn::Config do

  before do
    @conf_data = {
      'test_docs01' => {
        source: '/path/to/source01',
        storage: {type: 'FileSystem', path: '/path/to/storage01'}
      },
      'test_docs02' => {
        source: '/path/to/source02',
        storage: {type: 'FileSystem', path: '/path/to/storage02'}
      }
    }
  end

  def config
    @config ||= Marsdawn::Config.new(File.join($TEST_DOC_DIR, 'config.yml'))
  end

  it 'should raise error when the config file does not exist.' do
    expect{Marsdawn::Config.new}.to raise_error(/^Cannot find a config file for marsdawn./)
  end

  it 'should raise errro when the config key does not exist in the yaml.' do
    expect{config.to_hash('no_exists')}.to raise_error(/^Cannot find the configuration/)
  end

  it 'should raise errro when the config entry does not exist at the config.' do
    expect{config.get('test_docs01', :no_exists)}.to raise_error(/^No entry 'no_exists' in the setting file/)
  end

  it 'should return the config data from key.' do
    expect(config.get('test_docs01', :source)).to eq(@conf_data['test_docs01'][:source])
    expect(config.get('test_docs02', :storage)).to eq(@conf_data['test_docs02'][:storage])
  end

end
