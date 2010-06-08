#Demo data loading from yml fixtures
namespace :demo do
  desc "Load demo seed fixtures (from db/fixtures/demo) into the current environment's database." 
  require 'active_record/fixtures'
  task :seed => :environment do
    puts "Loading demo fixture files..."
    Fixtures.create_fixtures('db/fixtures/demo', Dir.glob(RAILS_ROOT + "/db/fixtures/demo/*.{yml}").collect{|f| File.basename(f, '.*')})
  end
end