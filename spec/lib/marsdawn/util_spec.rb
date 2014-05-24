# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))

describe Marsdawn::Util, '#hash_symbolize_keys_deep' do
  it 'should symbolize hash keys.' do
    h = {'foo'=>'bar', 'val'=>123}
   expect(Marsdawn::Util.hash_symbolize_keys_deep(h)).to eq({foo:'bar', val:123})
  end
  it 'should symbolize symbolized hash keys.' do
    h = {'foo'=>'bar', :val=>123}
   expect(Marsdawn::Util.hash_symbolize_keys_deep(h)).to eq({foo:'bar', val:123})
  end
  it 'should symbolize hash keys recursively.' do
    h = {'foo'=>'bar', 'val'=>{'xyz'=>123}}
   expect(Marsdawn::Util.hash_symbolize_keys_deep(h)).to eq({foo:'bar', val:{xyz:123}})
  end
end

describe Marsdawn::Util, '#hash_symbolize_keys' do
  it 'should symbolize hash keys.' do
    h = {'foo'=>'bar', 'val'=>123}
   expect(Marsdawn::Util.hash_symbolize_keys(h)).to eq({foo:'bar', val:123})
  end
  it 'should symbolize hash keys recursively.' do
    h = {'foo'=>'bar', 'val'=>{'xyz'=>123}}
   expect(Marsdawn::Util.hash_symbolize_keys(h)).to eq({foo:'bar', val:{'xyz'=>123}})
  end
end

describe Marsdawn::Util, '#class_to_underscore' do
  it 'should convert class name to underscored file name.' do
    expect(Marsdawn::Util.class_to_underscore('Foo')).to eq('foo')
    expect(Marsdawn::Util.class_to_underscore('FooBar')).to eq('foo_bar')
    expect(Marsdawn::Util.class_to_underscore('Foo1Bar2')).to eq('foo1_bar2')
    expect(Marsdawn::Util.class_to_underscore('FOOBar')).to eq('foo_bar')
  end
end

describe Marsdawn::Util, '#strip_tags' do
  it 'should remove tags.' do
    expect(Marsdawn::Util.strip_tags('<html><div>abc</div></html>')).to eq('abc')
    expect(Marsdawn::Util.strip_tags('<html><div>abc<b>d</b>efg<p><span>hij</span>klm</p></div></html>')).to eq('abcdefghijklm')
  end
end

describe Marsdawn::Util, '#html_escape' do
  it 'should escape html entities.' do
    expect(Marsdawn::Util.html_escape('10<20')).to eq('10&lt;20')
  end
end

describe Marsdawn::Util, '#attr_escape' do
  it 'should escape attributes.' do
    expect(Marsdawn::Util.attr_escape('abc"d"efg')).to eq('abc\"d\"efg')
  end
end
