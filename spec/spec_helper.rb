# encoding: utf-8

require 'coveralls'
Coveralls.wear!

require 'rubygems'

require File.join(File.dirname(__FILE__), '../lib/marsdawn')

$TEST_DOC_DIR = File.join(File.dirname(__FILE__), '_test_doc')
$COMPILED_DOC_DIR = File.join(File.dirname(__FILE__), '_compiled_doc')
$TMP_DIR = File.join(File.dirname(__FILE__), '_tmp')
