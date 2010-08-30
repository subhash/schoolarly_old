Given /^that I have logged in as "(.*)"$/ do |user|
  puts user.inspect
  school = schools(user.to_sym)
  visit root_path
  click_link 'Login'
  fill_in 'Email', :with => school.email
  fill_in 'Password', :with => "password"
  click_button 'Login'
  assert_equal current_path, school_path(school)
end