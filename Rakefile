# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require(File.join(File.dirname(__FILE__), 'config', 'boot'))

require 'rake'
require 'rake/testtask'
require 'rake/rdoctask'

require 'tasks/rails'


#
# Copied from the internet. Hacked it to run a whole unit or functional test case
# rake schools will run schools_controller_test
# rake school will run school_test
# Change the last line with your paths and make it work for yourself
# If you are feeling adventurous, make it without paths :)
#
##
# Run a single test in Rails.
#
#   rake blogs_list
#   => Runs test_list for BlogsController (functional test)
#
#   rake blog_create
#   => Runs test_create for BlogTest (unit test)

rule "" do |t|
  #  if /(.*)_([^.]+)$/.match(t.name)
  if /(.*)$/.match(t.name)
    file_name = $1
#    test_name = $2
    if File.exist?("test/unit/#{file_name}_test.rb")
      file_name = "unit/#{file_name}_test.rb" 
    elsif File.exist?("test/functional/#{file_name}_controller_test.rb")
      file_name = "functional/#{file_name}_controller_test.rb" 
    else
      raise "No file found for #{file_name}" 
    end
    # sh "ruby -Ilib:test test/#{file_name} -n /^test_#{test_name}/"
    sh "c:/instantrails/ruby/bin/ruby.exe -I\"lib;test\" \"c:/instantrails/ruby/lib/ruby/gems/1.8/gems/rake-0.8.7/lib/rake/rake_test_loader.rb\" test/#{file_name}"
  end
end
