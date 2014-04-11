require 'rubygems'
require 'rake'

namespace "marsdawn" do
  desc "compile marsdawn document."
  task "compile", :key do |t, args|
    key = args[:key]
    Marsdawn.compile key
  end
end
