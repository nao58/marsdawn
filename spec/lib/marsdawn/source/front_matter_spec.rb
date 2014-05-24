# encoding: utf-8

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))
Marsdawn.require_lib 'source/front_matter'


describe Marsdawn::Source::FrontMatter do
  context 'with front-matter' do
    it 'should parse the attributes.' do
      doc = Marsdawn::Source::FrontMatter.new <<-'EOS'
---
title: Test Document
tags: [Ruby, Develop, String]
---
Header
======
lorem ipsum
      EOS
      expect(doc.attr).to eq({title:'Test Document', tags:['Ruby', 'Develop', 'String']})
      expect(doc.content).to eq("Header\n======\nlorem ipsum\n")
    end
    it 'should parse the attributes with "---" content.' do
      doc = Marsdawn::Source::FrontMatter.new <<-'EOS'
---
title: Test Document
tags: [Ruby, Develop, String]
---
Header
---
lorem ipsum
      EOS
      expect(doc.attr).to eq({title:'Test Document', tags:['Ruby', 'Develop', 'String']})
      expect(doc.content).to eq("Header\n---\nlorem ipsum\n")
    end
  end
  context 'without front-matter' do
    it 'should get content with empty attribute.' do
      doc = Marsdawn::Source::FrontMatter.new <<-'EOS'
# Test Title
lorem ipsum
      EOS
      expect(doc.attr).to eq({})
      expect(doc.content).to eq("# Test Title\nlorem ipsum\n")
    end
    it 'should get content with empty attribute even with "---" content.' do
      doc = Marsdawn::Source::FrontMatter.new <<-'EOS'
Test Title
---
lorem ipsum
      EOS
      expect(doc.attr).to eq({})
      expect(doc.content).to eq("Test Title\n---\nlorem ipsum\n")
    end
  end
end
