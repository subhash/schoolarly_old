#Tasks for setting up the demo environment
namespace :demo do
  #desc "Load demo seed fixtures (from db/fixtures/demo) into the current environment's database." 
  require 'active_record/fixtures'
  task :seed => :environment do
    puts "Loading demo fixture files..."
    Fixtures.create_fixtures('db/fixtures/demo', Dir.glob(RAILS_ROOT + "/db/fixtures/demo/*.{yml}").collect{|f| File.basename(f, '.*')})
  end
  
  #TODO Will generalise it
  #desc "Load other data through tasks"
  
  task :create_assessment_groups => :environment do
    puts "Creating assessment groups for all the klasses"
    Klass.all.each{|k| k.create_assessment_groups}
  end
  
  task :create_assessments => :environment do
    puts "Creating assessments for all the papers"
    Paper.all.each{|p| p.create_assessments}
  end
  
  desc "Call all the subtasks to set up the demo"
  task :setup => [:seed, :create_assessment_groups, :create_assessments]
  
end
