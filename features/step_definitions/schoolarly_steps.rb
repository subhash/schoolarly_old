
Given /I login with "(.*)"$/ do |email|
  visit root_path
  click_link 'Login'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => "password"
  click_button 'Login'
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

When /^(?:|I )select "(.+)" from multiselect "(.+)"$/ do |text, element|
  initialize_select(element)
    When %{I select "#{text}" from "#{element}"}
end

When /^(?:|I )unselect "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    unselect(value, :from => field)
  end
end

Then /^(?:|I )should see the following(?: within "([^"]*)")?:$/ do |selector, elements|
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
