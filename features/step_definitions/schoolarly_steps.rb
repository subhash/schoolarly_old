
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
