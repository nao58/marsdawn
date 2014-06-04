# encoding: utf-8

require File.expand_path(File.join('../../', 'spec_helper'), File.dirname(__FILE__))
Marsdawn.require_lib 'command'

describe Marsdawn::Command do

  def command argv
    Marsdawn::Command.exec(argv)
  end

  def cmd
    @cmd ||= Marsdawn::Command.new
  end

  def chdir path
    Dir.chdir File.expand_path(path)
  end

  def file_exists? path
    File.exists?(File.expand_path(path))
  end

  before :each do
    Dir.chdir($TMP_DIR)
    Dir.glob("*").each do |entry|
      path = File.expand_path(entry)
      FileUtils.remove_entry(entry, true) if File.exists?(path)
    end
    @cmd = nil
  end

  context '#exec' do
    it 'should parse rightly.' do
      expect(command(%w(debug options --num 100 -e))).to eq(num:'100', edit:true)
      expect(command(%w(debug options num 100 -e))).to eq(num:'100', edit:true)
      expect(command(%w(debug options -n 100 -e))).to eq(num:'100', edit:true)
      expect(command(%w(debug options --num 200 -n 100 -e))).to eq(num:'100', edit:true)
      expect(command(%w(debug options))).to eq({})
      expect(command(%w(debug))).to be_nil
    end
    it 'should raise error when option is invalid.' do
      expect{command(%w(debug options --foo bar))}.to raise_error(Marsdawn::Command::ParamError)
    end
    it 'should raise error when command is invalid.' do
      expect{command(%w(foo))}.to raise_error(Marsdawn::Command::ParamError)
    end
    it 'should raise error when command is not given.' do
      expect{command(%w())}.to raise_error(Marsdawn::Command::ParamError)
    end
  end

  context 'with command .create' do
    it 'should create new directory, .marsdawn.yml and .index.md' do
      cmd.create 'Test Document'
      expect(file_exists?('test-document')).to be_truthy
      expect(file_exists?('test-document/.marsdawn.yml')).to be_truthy
      expect(file_exists?('test-document/.index.md')).to be_truthy
    end
  end

  context 'with command .page' do
    before :each do
      cmd.create 'Test Document'
      chdir './test-document'
    end
    it 'should create new page.' do
      cmd.page 'About this test document'
      cmd.page 'Getting Start'
      expect(file_exists?('about-this-test-document.md')).to be_truthy
      expect(file_exists?('getting-start.md')).to be_truthy
    end
    it 'should create new page.' do
      cmd.page 'About this test document', num: true
      cmd.page 'Getting Start', num: true
      cmd.page 'Appendix 1', num: "100", file: 'omake'
      cmd.page 'Appendix 2', num: true, file: 'furoku'
      expect(file_exists?('010_about-this-test-document.md')).to be_truthy
      expect(file_exists?('020_getting-start.md')).to be_truthy
      expect(file_exists?('100_omake.md')).to be_truthy
      expect(file_exists?('110_furoku.md')).to be_truthy
    end
  end

  context 'with command .dir' do
    before :each do
      cmd.create 'Test Document'
      chdir './test-document'
    end
    it 'should create new directory.' do
      cmd.page 'About this test document'
      cmd.dir  'Getting Start'
      expect(file_exists?('about-this-test-document.md')).to be_truthy
      expect(file_exists?('getting-start')).to be_truthy
      expect(file_exists?('getting-start/.index.md')).to be_truthy
    end
    it 'should create new page.' do
      cmd.page 'About this test document', num: true
      cmd.dir  'Getting Start', num: true
      cmd.dir  'Appendix 1', num: "100", file: 'omake'
      cmd.page 'Appendix 2', num: true, step: 5, file: 'furoku'
      expect(file_exists?('010_about-this-test-document.md')).to be_truthy
      expect(file_exists?('020_getting-start')).to be_truthy
      expect(file_exists?('020_getting-start/.index.md')).to be_truthy
      expect(file_exists?('100_omake')).to be_truthy
      expect(file_exists?('100_omake/.index.md')).to be_truthy
      expect(file_exists?('105_furoku.md')).to be_truthy
    end
  end

  context 'with command .renum' do
    before :each do
      cmd.create 'Test Document'
      chdir './test-document'
    end
    it 'should do re-numbering.' do
      cmd.page 'About this test document', num: "15"
      cmd.dir  'Getting Start', num: "20"
      cmd.dir  'Appendix 1', num: "100"
      cmd.page 'Appendix 2', num: true, step: 5
      cmd.renum nil
      expect(file_exists?('010_about-this-test-document.md')).to be_truthy
      expect(file_exists?('020_getting-start')).to be_truthy
      expect(file_exists?('020_getting-start/.index.md')).to be_truthy
      expect(file_exists?('030_appendix-1')).to be_truthy
      expect(file_exists?('030_appendix-1/.index.md')).to be_truthy
      expect(file_exists?('040_appendix-2.md')).to be_truthy
    end
    it 'should do re-numbering with step.' do
      cmd.page 'About this test document', num: "15"
      cmd.dir  'Getting Start', num: "20"
      cmd.dir  'Appendix 1', num: "100"
      cmd.page 'Appendix 2', num: true, step: 5
      cmd.renum "15"
      expect(file_exists?('015_about-this-test-document.md')).to be_truthy
      expect(file_exists?('030_getting-start')).to be_truthy
      expect(file_exists?('030_getting-start/.index.md')).to be_truthy
      expect(file_exists?('045_appendix-1')).to be_truthy
      expect(file_exists?('045_appendix-1/.index.md')).to be_truthy
      expect(file_exists?('060_appendix-2.md')).to be_truthy
    end
  end

end
