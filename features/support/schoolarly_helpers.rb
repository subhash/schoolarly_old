  def initialize_select(element_id)
    assert page.has_css?("##{element_id}.multiselect")
    page.execute_script("jQuery('##{element_id}').removeClass('multiselect');")
  end
  
  def click_tab(name)
    click_link "#{name}-tab-link"
  end
  
  def symbol(s, delimiter=nil)
    s.split(delimiter).first.downcase
  end
  
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

require 'selenium-webdriver'
#require 'capybara/xpath'

class Capybara::Driver::Selenium < Capybara::Driver::Base
  class Node < Capybara::Node
    def select(option)
      # option_node = node.find_element(:xpath, ".//option[normalize-space(text())=#{Capybara::XPath.escape(option)}]") || node.find_element(:xpath, ".//option[contains(.,#{Capybara::XPath.escape(option)})]")
      option_node = node.find_element(:xpath, ".//option[text()=#{Capybara::XPath.escape(option)}]")
      puts "option node = "+option_node.inspect
      option_node.select
    rescue 
      puts node.find_element(:xpath, ".//option[text()=#{option}]").inspect
      puts node.find_element(:xpath, ".//option[contains()=#{option}]").inspect
      options = node.find_elements(:xpath, "//option").map { |o| "'#{o.text}'" }.join(', ')
      raise Capybara::OptionNotFound, "No such option '#{option}' in this select box. Available options: #{options}"
  end
  
  def unselect(option)
#  if node['multiple'] != 'multiple'
#    raise Capybara::UnselectNotAllowed, "Cannot unselect option '#{option}' from single select box."
#  end
    begin
#    option_node = node.find_element(:xpath, ".//option[normalize-space(text())=#{Capybara::XPath.escape(option)}]") || node.find_element(:xpath, ".//option[contains(.,#{Capybara::XPath.escape(option)})]")
    option_node = node.find_element(:xpath, ".//option[text()=#{Capybara::XPath.escape(option)}]") || node.find_element(:xpath, ".//option[contains(.,#{Capybara::XPath.escape(option)})]")
    option_node.clear
    rescue
      options = node.find_elements(:xpath, "//option").map { |o| "'#{o.text}'" }.join(', ')
      raise Capybara::OptionNotFound, "No such option '#{option}' in this select box. Available options: #{options}"
    end
  end

  end
end

#class Capybara::XPath
#    def link(locator)
##      xpath = append("//a[@href][@id=#{s(locator)} or contains(.,#{s(locator)}) or contains(@title,#{s(locator)}) or img[contains(@alt,#{s(locator)})]]")
##      xpath.prepend("//a[@href][text()=#{s(locator)} or @title=#{s(locator)} or img[@alt=#{s(locator)}]]")
#      xpath = append("//a[@href][@title=#{s(locator)} or text()=#{s(locator)}]")
#      puts "xath = "+xpath.inspect
#      return xpath
##      xpath.prepend("//a[@href][text()=#{s(locator)} or @title=#{s(locator)} or img[@alt=#{s(locator)}]]")
#    end
#end