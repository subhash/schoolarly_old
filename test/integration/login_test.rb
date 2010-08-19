require 'integration_test_helper' 

class LoginTest < ActionController::IntegrationTest
  
  def setup
    @school = schools(:st_teresas)
    @school2 = schools(:gps)
  end
  def login(email, password)
    visit root_path
    click_link 'Login'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Login'
  end
  
  def test_school_login
    login(@school.email, "password")
    assert_equal current_path, school_path(@school)
    save_and_open_page
  end
  
  def test_student_login
    
  end
  
  def test_teacher_login
    
  end
  
  def test schoolarly_admin_login
    
  end
  
  
  def test_invalid_login
    login(@school.email, "wrong_password")
    assert page.has_content?('There were problems with the following fields:')
  end
  
end