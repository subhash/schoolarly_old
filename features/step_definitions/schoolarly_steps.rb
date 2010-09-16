
Given /"(.*)" logs in$/ do |email|
  visit root_path
  click_link 'Login'
  fill_in 'Email', :with => email
  fill_in 'Password', :with => "password"
  click_button 'Login'
  wait_until(5) do
    page.has_link?("Logout, #{email}")
  end
end


Then /^I should see link with title "(.+)"$/ do |title|
  assert page.has_css? "a[title='#{title}']"
end

Then /^I should see link "(.+)"$/ do |link|
  assert page.has_link?(link)
end

When /^(?:|I )select the following from multiselect "(.+)":$/ do |element, table|
  initialize_select(element)
  table.raw.each do |selection|
    When %{I select "#{selection}" from "#{element}"}
  end
end

When /^(?:|I )select "(.+)" from multiselect "(.+)"$/ do |text, element|
  initialize_select(element)
    When %{I select "#{text}" from "#{element}"}
end

When /^(?:|I )follow tab "(.+)"$/ do |tab_name|
  click_tab(tab_name)
end

When /^(?:|I )wait until "(.+)"$/ do |content|
  page.wait_until do
    page.has_content?(content)
  end
end

When /"(.*)" logs out$/ do |email|
  page.evaluate_script('window.confirm = function() { return true; }')
  When %{I follow "Logout, #{email}"} 
end

When /^(?:|I )unselect "([^"]*)" from "([^"]*)"(?: within "([^"]*)")?$/ do |value, field, selector|
  with_scope(selector) do
    unselect(value, :from => field)
  end
end

Then /^(?:|I )should see the following(?: within "([^"]*)")?:$/ do |selector, table|
  with_scope(selector) do
    table.raw.each do |text|
      if page.respond_to? :should
        page.should have_content(text)
      else
        assert page.has_content?(text)
      end
    end
  end
end

Then /^(?:|I )should not see the following(?: within "([^"]*)")?:$/ do |selector, table|
  with_scope(selector) do
    table.raw.each do |text|
      if page.respond_to? :should
        page.should have_no_content(text)
      else
        assert page.has_no_content?(text)
      end
    end
  end
end

Then /^(?:|I )should see the following links(?: within "([^"]*)")?:$/ do |selector, table|
  with_scope(selector) do
    table.raw.each do |link|
      if page.respond_to? :should
        page.should have_link(link)
      else
        assert page.has_link?(link)
      end
    end
  end
end

Then /^(?:|I )should not see the following links(?: within "([^"]*)")?:$/ do |selector, table|
  with_scope(selector) do
    table.raw.each do |link|
      if page.respond_to? :should
        page.should have_no_link(link)
      else
        assert page.has_no_link?(link)
      end
    end
  end
end
