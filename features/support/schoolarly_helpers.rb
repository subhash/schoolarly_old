  def initialize_select(element_id)
    assert page.has_css?("##{element_id}.multiselect")
    page.execute_script("jQuery('##{element_id}').removeClass('multiselect');")
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
