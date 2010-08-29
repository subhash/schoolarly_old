require "test_helper"
require "capybara/rails"
require "selenium-webdriver"
require 'selenium/webdriver/remote/http/curb'

include Selenium

module ActionController
  class IntegrationTest
    include Capybara
    self.fixture_path = "#{Rails.root}/test/fixtures/integration/"
    fixtures :all
    
    def assert_i_tabs
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
          assert page.has_css? "div.col div.tab##{id}-tab-section:nth-child(#{position})"
        else
          assert page.has_css? "div.col div.tab##{id}-tab-section"
        end
      end
    end
      yield tab_tester
  end
  
  end
end

Capybara.default_driver = :selenium
Capybara.javascript_driver = :selenium
Capybara.default_wait_time = 15
Selenium::WebDriver.for :firefox, :http_client => Selenium::WebDriver::Remote::Http::Curb 