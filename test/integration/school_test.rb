require 'integration_test_helper' 

class SchoolTest < ActionController::IntegrationTest
  
  def setup
    @school =  schools(:stteresas)
  end
  
  def login(email, password)
    visit root_path
    click_link 'Login'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Login'
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
  
  #  def test_invalid_login
  #    login(@school.email, "wrong_password")
  #    assert page.has_content?('There were problems with the following fields:')
  #  end
  
  def add_subjects_to_school(subjects, no_subjects)
    click_link "Add Subjects to #{@school.name}"
    initialize_select('subject_ids')
    subjects.each do |s|
      select s, :from => 'subject_ids'
    end
    click_button 'Save'
    assert(within_table('school_subjects') {
      subjects.each do |s|
        page.has_content?(s)
      end
      no_subjects.each do |s|
        page.has_no_content?(s)
      end
    })
  end
  
  def initialize_select(element_id)
    assert page.has_css?("##{element_id}.multiselect")
    page.execute_script("jQuery('##{element_id}').removeClass('multiselect');")
    @javascript
  end
  
  def add_class(level, division, subjects, no_subjects)
    click_link "Add Class"
    @javascript
    select level.name, :from => 'klass_level_id'
    fill_in 'Division', :with => division
    click_button 'Create'
    klass = Klass.find_by_level_id_and_division(level.id, division)
    assert_not_nil klass
    assert page.has_content?("Add subjects to #{klass.name}")
    add_subjects(subjects, 'school_subject_ids')
    assert(within_table('klasses') {
      page.has_link?(klass_path(klass))
      subjects.each do |s|
        page.has_content?(s)
      end
      no_subjects.each do |s|
        page.has_no_content?(s)
      end
    })
    return klass
  end
  
  def add_subjects(subjects, element_id)
    initialize_select(element_id)
    subjects.each do |s|
      wait_until{select s, :from => element_id}
    end
    click_button 'Save'
  end
  
  def invite_student(email, name, admission_no, klass, roll_no, subjects)
    click_link "Invite Student"
    assert page.has_content?("Invite Student")
    fill_in 'Email', :with => email
    fill_in 'Name', :with => name
    fill_in 'Admission number', :with => admission_no
    click_button 'Invite'
    assert page.has_content?("Assign class for #{name}")
    fill_in 'Roll number', :with => roll_no
    select klass, :from => 'student_klass_id'
    click_button 'Assign'
    assert page.has_content?("Subjects taken by #{name}")
    add_subjects(subjects, 'paper_ids')
    student = Student.find(User.find_by_email(email).person_id)
    assert_not_nil(student)
    assert(within_table('students') {
      page.has_link?(student_path(student))
      page.has_content?("Admission no: #{admission_no}")
      page.has_content?("Roll no: #{roll_no}")
      subjects.each do |s|
        page.has_content?(s)
      end
    })
  end
  
  def test_school_setup
    login(@school.email, "password")
    add_subjects_to_school ['Biology', 'English','Science'],['Malayalam']
    klass1 = add_class(levels(:one), "A", ['Biology', 'English'], ['Science'])
    klass2 = add_class(levels(:two), "B", ['English','Science'], ['Biology'])
#    invite_student('student1@schoolarly.com', 'Student1', 1 , '1 A', '', ['Biology', 'English'])
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
