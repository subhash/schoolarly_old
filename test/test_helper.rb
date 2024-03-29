ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'shoulda'

class ActiveSupport::TestCase
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = false
  
  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false
  
  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all
  
  def assert_breadcrumb(label,url = nil, index = nil)
    assert_select 'div#breadcrumbs ul#crumbs li' , :text => label 
    if url
      assert_select 'div#breadcrumbs ul#crumbs li' do
        assert_select 'a[href=?]', url, :text => label
      end
    else
      assert_select 'div#breadcrumbs ul#crumbs' do
        assert_select 'li:last-of-type', :text => label
      end
    end
    if index
      assert_select "div#breadcrumbs ul#crumbs li:nth-of-type(" + index.to_s + ")" do
        assert_select 'a[href=?]', url, :text => label
      end
    end
  end
  
  
  def assert_breadcrumb_count(count)
    if !count
      assert_select 'div#breadcrumbs ul#crumbs li', :count => count
    end
  end
  
  def assert_action_count(count)
    if !count
      assert_select "ul#right-bar" do
        assert_select "li a", :count => count
      end 
    end
  end  
  
  def assert_action(label, *args)
    options = args.extract_options!
    if !label
      assert false
    else
      if !options.empty?
        url = !(options[:url].nil?) ? options[:url] : '#'
        index = options[:index]
        assert_select "ul#right-bar" do
          if !index
            assert_select "li a[href=?]", url, :text => label
          else
            assert_select "li:nth-of-type(" + index.to_s + ")" do
              assert_select 'a[href=?]' , url, :text => label
            end
          end
        end
      else
        assert_select "li a[href=?]", :text => label
      end
    end
  end
  
  def assert_tabs
    tab_tester = self
    
    class <<tab_tester
      
      def assert_schools_tab(position = nil)
        assert_tab_id 'schools', position
      end
      
      def assert_students_tab(position = nil)
        assert_tab_id 'students', position
      end
      
      def assert_teachers_tab(position = nil)
        assert_tab_id 'teachers', position
      end
      
      def assert_subjects_tab(position = nil)
        assert_tab_id 'subjects', position
      end
      
      def assert_klasses_tab(position = nil)
        assert_tab_id 'klasses', position
      end    
      
      def assert_messages_tab(position = nil)
        puts "in messages tab "
        assert_tab_id 'messages', position
      end
      
      def assert_events_tab(position = nil)
        assert_tab_id 'events', position
      end

      def assert_details_tab(position = nil)
        assert_tab_id 'details', position
      end
      
      private
      def assert_tab_id(id, position)
        if(position)
          assert_select "div.tab##{id}-tab-section:nth-child(#{position})"
        else
          assert_select "div.tab##{id}-tab-section"
        end
      end
    end
    assert_select 'div.col' do
      yield tab_tester
    end
  end
  
end
