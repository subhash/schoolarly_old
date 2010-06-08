#Demo data loading from yml fixtures
namespace :demo do
  desc "Load demo seed fixtures (from db/fixtures/demo) into the current environment's database." 
  require 'active_record/fixtures'
  task :seed => :environment do
    Dir.glob(RAILS_ROOT + "/db/fixtures/demo/*.{yml}").each do |file|
      puts "Running demo data fixture #{file}"
      Fixtures.create_fixtures('db/fixtures/demo', File.basename(file, '.*'))
    end
  end
end