require 'rubygems'
require 'rake'

namespace 'marsdawn' do
  desc 'build MarsDawn document.'
  task :build => :environment do
    Marsdawn.build
  end
end
