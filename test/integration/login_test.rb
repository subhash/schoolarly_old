require 'integration_test_helper' 

class LoginTest < ActionController::IntegrationTest
  
  def login(email, password)
    visit root_path
    click_link 'Login'
    fill_in 'Email', :with => email
    fill_in 'Password', :with => password
    click_button 'Login'
  end
  
  def test_valid_login
    login("stteresas@schoolarly.com", "password")
    assert page.has_content?('There were problems with the following fields:')
  end
  
  
  def test_invalid_login
    login("stteresas@schoolarly.com", "wrong_password")
    assert page.has_content?('There were problems with the following fields:')
  end
  
end