require 'integration_test_helper' 

class SchoolTest < ActionController::IntegrationTest
  
  def setup
    @school = schools(:stteresas)
  end
  
  def login(email, password)
    visit root_path
    click_link 'Login'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Login'
  end
  
  def valid_login
    login(@school.email, "password")
    assert_equal current_path, school_path(@school)
    assert_i_tabs do |t|
      t.assert_messages_tab 1
      t.assert_events_tab 2
      t.assert_klasses_tab 3
      t.assert_students_tab 4
      t.assert_teachers_tab 5
      t.assert_subjects_tab 6
      t.assert_details_tab 7
    end 
  end
  
  def test_invalid_login
    login(@school.email, "wrong_password")
    assert page.has_content?('There were problems with the following fields:')
  end
  
  def add_subjects
    click_link "Add Subjects to #{@school.name}"
    initialize_select('subject_ids')
    select 'Biology', :from => 'subject_ids'
    select 'English', :from => 'subject_ids'
    select 'Science' , :from => 'subject_ids'
    click_button 'Save'
    assert(within_table('school_subjects') {
      page.has_content?('Biology')
      page.has_content?('English')
      page.has_content?('Science')
      page.has_no_content?('Malayalam')
    })
  end
  
  def initialize_select(element_id)
    assert page.has_css?("##{element_id}.multiselect")
    page.execute_script("jQuery('##{element_id}').removeClass('multiselect');")
  end
  
  def add_class(level, division)
    click_link "Add Class"
    select level.name, :from => 'klass_level_id'
    fill_in 'Division', :with => division
    click_button 'Create'
    klass = Klass.find_by_level_id_and_division(level.id, division)
    assert_not_nil klass
    assert page.has_content?("Add subjects to #{klass.name}")
    initialize_select('school_subject_ids')
    select 'Biology', :from => 'school_subject_ids'
    select 'English', :from => 'school_subject_ids'
    click_button 'Save'
    assert(within_table('klasses') {
      page.has_link?(klass_path(klass))
      page.has_content?('Biology')
      page.has_content?('English')
      page.has_no_content?('Science')
    })
  end
  
  def test_school_setup
    valid_login
    add_subjects
    add_class(levels(:one), "A")
    add_class(levels(:two), "B")
  end
  
  
end
#  1. School setup/configuration
#  - a) add subjects
#  - b) add classes
#  - c) invite students
#  - d) invite teachers
#  - 
#  2) Class setup
#  - a) add subjects
#  - b) add students to class
#  - c) add students to subjects
#  - c) assign classteacher
#  - d) assign teachers to subjects
#
#  3) Edit profile details
#  4) Event management
#    - create event
#    - Adding participants to events
#    - edit event
#    - remove event
#  5) Messaging
#    - compose message to school users
#    - delete messages
