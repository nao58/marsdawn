# encoding: utf-8

require File.expand_path(File.join('../../../', 'spec_helper'), File.dirname(__FILE__))
Marsdawn.require_lib 'source/document'

describe Marsdawn::Source::Document, '#read' do
    it 'should generate title attribute.' do
      doc = Marsdawn::Source::Document.read(File.join($TEST_DOC_DIR, 'samples/test_document.md'))
      expect(doc.front_matter).to eq({
        title: 'Test document',
        link_key: 'Test document'
      })
    end
    it 'should generate title attribute for number prefix.' do
      doc = Marsdawn::Source::Document.read(File.join($TEST_DOC_DIR, 'samples/010_sample-document.md'))
      expect(doc.front_matter).to eq({
        title: 'Sample document',
        link_key: 'Test Document'
      })
    end
end

describe Marsdawn::Source::Document, '#new' do
  context 'with front-matter' do
    it 'should generate attributes.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
---
foo: bar
---
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Header',
        link_key: 'Header',
        anchors: {'Header' => 'header'},
        foo: 'bar'
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
    it 'should use front-matter title attribute.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
---
title: Test Document
tags: [Ruby, Develop, String]
---
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Test Document',
        link_key: 'Header',
        anchors: {'Header' => 'header'},
        tags:['Ruby', 'Develop', 'String']
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
    it 'should use front-matter link_key attribute.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
---
link_key: Test Document Header
---
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Header',
        link_key: 'Test Document Header',
        anchors: {'Header' => 'header'}
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
  end
  context 'without front-matter' do
    it 'should generate attributes.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
Sample Document
===============
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Sample Document',
        link_key: 'Sample Document',
        anchors: {'Sample Document' => 'sample-document'}
      })
      expect(doc.to_html).to eq("<h1 id=\"sample-document\"><a name=\"sample-document\"></a>Sample Document</h1>\n<p>lorem ipsum</p>\n")
    end
  end
end

describe Marsdawn::Source::Document, '#new' do
  context 'with front-matter' do
    it 'should generate attributes.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
---
foo: bar
---
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Header',
        link_key: 'Header',
        anchors: {'Header' => 'header'},
        foo: 'bar'
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
    it 'should use front-matter title attribute.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
---
title: Test Document
tags: [Ruby, Develop, String]
---
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Test Document',
        link_key: 'Header',
        anchors: {'Header' => 'header'},
        tags:['Ruby', 'Develop', 'String']
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
    it 'should use front-matter link_key attribute.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
---
link_key: Test Document Header
---
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Header',
        link_key: 'Test Document Header',
        anchors: {'Header' => 'header'}
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
  end
  context 'without front-matter' do
    it 'should generate attributes.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
Sample Document
===============
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Sample Document',
        link_key: 'Sample Document',
        anchors: {'Sample Document' => 'sample-document'}
      })
      expect(doc.to_html).to eq("<h1 id=\"sample-document\"><a name=\"sample-document\"></a>Sample Document</h1>\n<p>lorem ipsum</p>\n")
    end
    it 'should use front-matter and ex-tags.' do
      doc = Marsdawn::Source::Document.new <<-'EOS'
{::front_matter title="Test Doc" /}
Header
======
lorem ipsum
      EOS
      expect(doc.front_matter).to eq({
        title:'Test Doc',
        link_key: 'Test Doc',
        anchors: {'Header' => 'header'}
      })
      expect(doc.to_html).to eq("<h1 id=\"header\"><a name=\"header\"></a>Header</h1>\n<p>lorem ipsum</p>\n")
    end
  end
end

