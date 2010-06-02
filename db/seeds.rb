unless User.find_by_email('admin@schoolarly.com')
  user = User.new(:email => 'admin@schoolarly.com', :password => 'dummy', :password_confirmation => 'dummy')
  user.crypted_password = '852b3fd79e82c5f32771f0908a842712c5f309ee93b837d2a8e935e486ccc3ba65f534541c13a74c6acf052679286823f346c1c922edeee643872e46a1fa56a8'
  user.password_salt = 'TtED8vt9xfr4izRfpMfz'
  user.person = SchoolarlyAdmin.new()
  user.save!
end

#Master data loading from yml/rb fixtures. rb fixtures take care of validation too...
namespace :db do
  desc "Load seed fixtures (from db/fixtures) into the current environment's database." 
  require 'active_record/fixtures'
  task :seed => :environment do
    Dir.glob(RAILS_ROOT + "/db/fixtures/*.{yml,rb}").each do |file|
      if File.extname(file) == '.yml'
        puts "Running yml data fixture #{file}"
        Fixtures.create_fixtures('db/fixtures', File.basename(file, '.*'))
      else
        puts "Running ruby data fixture #{file}" 
        load file
      end
    end
  end
end