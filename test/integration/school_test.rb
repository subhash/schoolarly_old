require 'integration_test_helper' 

class SchoolTest < ActionController::IntegrationTest
  
  def setup
    @school = schools(:gps)
  end
  
  def login(email, password)
    visit root_path
    click_link 'Login'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Login'
  end
  
  def test_valid_login
    login(@school.email, "password")
    assert_equal current_path, school_path(@school)
  end
  
  def test_invalid_login
    login(@school.email, "wrong_password")
    assert page.has_content?('There were problems with the following fields:')
  end
  
end