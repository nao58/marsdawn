[![Build Status](https://travis-ci.org/nao58/marsdawn.svg?branch=master)](https://travis-ci.org/nao58/marsdawn)
[![Coverage Status](https://coveralls.io/repos/nao58/marsdawn/badge.png?branch=master)](https://coveralls.io/r/nao58/marsdawn?branch=master)
[![Code Climate](https://codeclimate.com/github/nao58/marsdawn.png)](https://codeclimate.com/github/nao58/marsdawn)

# Marsdawn

MarsDawn is simple static document builder and traverser. You can create your own document site easily using this gem.

## Installation

Add this line to your application's Gemfile:

    gem 'marsdawn'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install marsdawn

## Usage

### Create your document source

Use marsdawn command.

~~~
marsdawn create "My Document"
~~~

Then the document and files will be created like below.

~~~
└── my_document
    ├── .marsdawn.yml
    └── .index.md
~~~

The file `.marsdawn.yml` includes the information of whole document set. `.index.md` is the top page. You can edit the file to add your content.

To create new page.

~~~
marsdawn page "About the document"
~~~

~~~
└── my_document
    ├── .marsdawn.yml
    ├── .index.md
    └── 010_about-the-document.md
~~~

To create new directory.

~~~
marsdawn dir "Tutorial"
~~~

~~~
└── my_document
    ├── .marsdawn.yml
    ├── .index.md
    ├── 010_about-the-document.md
    └── 020_tutorial
        └── .index.md
~~~

### Build the documents

Setting config file is the easiest way to build the document.

Create config file names "marsdawn.yml" under "config" directory of your framework.

~~~config/marsdawn.yml
your_document_key:
  source: path/to/your/source/documents
  storage:
    path: path/to/build/directory
~~~

This time we will build the document onto the file system. You can choose RDBMS storage instead.

Then simply hit the rake command.

~~~
rake marsdawn:build
~~~

### Traverse the documents

Once you have built the document, you can traverse the document easily from your own site.

This is a sample controller for Padrino.

~~~ruby
YourWeb::App.controllers :docs do

  get :index, :map => '/docs/*path' do
    docset = Marsdawn::Site.new(key: 'your_document_key', lang: 'en', version: '1.0.0', base_path: '/docs')
    @page = docset.page("/#{params[:path].join('/')}")
    @title = @page.title
    render 'docs'
  end

end
~~~

Now you can create your templete for the document page.

## Contributing

1. Fork it ( http://github.com/nao58/marsdawn/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
