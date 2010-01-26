ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'

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
  self.use_transactional_fixtures = true
  
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
  
  # Add more helper methods to be used by all tests here...
  
  def assert_tab_count(count)
    assert_select '.tabs > ul > li > a',count
  end
  
  def assert_tab(label, id)
    assert_select '.tabs > ul > li > a', label
    assert_select "#"+id, 1
  end
  
  
  def assert_breadcrumb(label,url = nil, index = nil)
    assert_select 'ul#breadcrumbs li' , :text => label 
    if url
      assert_select 'ul#breadcrumbs li' do
        assert_select 'a[href=?]', url, :text => label
      end
    else
      assert_select 'ul#breadcrumbs li:last-of-type' do
        assert_select 'strong', :text => label
      end
    end
    if index
      assert_select "ul#breadcrumbs li:nth-of-type(" + index.to_s + ")" do
        assert_select 'a[href=?]', url, :text => label
      end
    end
  end
  
  
  def assert_breadcrumb_count(count)
    if !count
      assert_select 'ul#breadcrumbs li', :count => count
    end
  end
  
  def assert_action_count(count)
    if !count
      assert_select "#action_box" do
        assert_select ".button a", :count => count
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
        assert_select "#action_box" do
          if !index
            assert_select ".button a[href=?]" , url, :text => label
          else
            assert_select ".button:nth-of-type(" + index.to_s + ")" do
              assert_select 'a[href=?]' , url, :text => label
            end
          end
        end
      else
        assert false
      end
    end
  end
  
  def assert_tabs(count)
    assert_select 'div.tabs li', count
  end
  
  def assert_tab_rows(type, count)    
    assert_select "div##{type.downcase.pluralize}-tab tr[id*=#{type.downcase}_]", count
  end
  
end
