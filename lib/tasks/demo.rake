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
  task :populate_papers => :environment do
#    puts "Loading paper for klass (1A) and adding them to students"
#    Subject.find_all_by_id([1, 7, 8, 9, 10]).each{|s| Paper.create(:subject => s, :klass_id => 1)}
#    Student.find_all_by_klass_id(1).each{|s| s.paper_ids = Paper.find_all_by_klass_id(1).collect{|p| p.id};  
#                                              s.save; 
#                                              s.subjects.each {|sub| s.klass.exams.future_for(sub.id).each do |exam|
#                                                        exam.event.event_series.users << s.user
#                                                    end
#                                                    }
#                                                    s.save!
#                                        }
  end
  
  desc "Call all subtasks to set up demo"
  task :setup => [:seed, :populate_papers]
  
end
