# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

describe Marsdawn::Storage, 'when call get method' do
  before do
    @opts = {key:'test', lang:'en', version:'0.0.1'}
  end
  it 'should return appropriate instance.' do
    Marsdawn::Storage.get({:type=>'Test'},@opts).should be_an_instance_of(Marsdawn::Storage::Test)
  end
  it 'can be specified existing file.' do
    proc {Marsdawn::Storage.get({'type'=>'NotExistingStorage'},@opts)}.should raise_error(LoadError)
  end
  it 'can be specified existing class.' do
    class Marsdawn::Storage::AddingStorage < Marsdawn::Storage::Base
    end
    Marsdawn::Storage.get({'type'=>'AddingStorage'},@opts).should be_an_instance_of(Marsdawn::Storage::AddingStorage)
  end
  it 'should be specified type name.' do
    proc {Marsdawn::Storage.get({},@opts)}.should raise_error(RuntimeError, /^No storage type is specified/)
  end
end

describe Marsdawn::Storage, 'when storage class does not implemented essential methods' do
  it 'should raise error.' do
    proc {Marsdawn::Storage.get({'type'=>'TestNotImplementedError'}).set('/path', 'page', {}, {})}.should raise_error(NotImplementedError)
    proc {Marsdawn::Storage.get({'type'=>'TestNotImplementedError'}).get('/path')}.should raise_error(NotImplementedError)
  end
end
