# encoding: utf-8

class Marsdawn::Storage::ActiveRecord::Marsdawn < ActiveRecord::Base
  self.table_name = 'marsdawn'
  attr_accessor :doc, :lang, :version, :uri, :data

  def self.create_unless_exists
    unless ActiveRecord::Base.connection.table_exists? self.table_name
      ActiveRecord::Migration.create_table :marsdawn do |t|
        t.string :doc, :null => false
        t.string :lang, :null => false
        t.string :version, :null => false
        t.string :uri, :null => false
        t.text   :data
      end
      ActiveRecord::Migration.add_index :marsdawn, [:doc, :lang, :version, :uri], :unique => true
    end
  end

end
