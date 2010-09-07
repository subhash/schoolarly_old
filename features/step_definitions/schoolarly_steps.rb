Given /I am logged in as (school|student|teacher) "(.*)"$/ do |role, user|
  case role
    when 'school':
    person = schools(user.to_sym)
    path = school_path(person)
    when 'student':
    person = students(user.to_sym)
    path = student_path(person)
    when 'teacher':
    person = teachers(user.to_sym)
    path = teacher_path(person)
  end
  visit root_path
  click_link 'Login'
  fill_in 'Email', :with => person.email
  fill_in 'Password', :with => "password"
  click_button 'Login'
  assert_equal current_path, path
  #  assert_i_tabs do |t|
  #    t.assert_messages_tab 1
  #    t.assert_events_tab 2
  #    t.assert_klasses_tab 3
  #    t.assert_students_tab 4
  #    t.assert_teachers_tab 5
  #    t.assert_subjects_tab 6
  #    t.assert_details_tab 7
  #  end 
end

Given /I login with "(.*)"$/ do |email|
  visit root_path
  click_link 'Login'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => "password"
  click_button 'Login'
  #  assert_equal current_path, path
end

Given /I am on "(.+)" tab/ do |tab|
  click_tab tab
end


Then /^I should see link with title "(.+)"$/ do |title|
  assert page.has_css? "a[title='#{title}']"
end

When /^(?:|I )select the following from multiselect "(.+)":$/ do |element, selections|
  initialize_select(element)
  selections.hashes.each do |s|
    When %{I select "#{s[:name]}" from "#{element}"}
  end
end


Then /^(?:|I )should see(?: within "([^"]*)")? the following:$/ do |selector, elements|
  with_scope(selector) do
    elements.hashes.each do |h|
      text = h[:name]
      if page.respond_to? :should
        page.should have_content(text)
      else
        assert page.has_content?(text)
      end
    end
  end
end
