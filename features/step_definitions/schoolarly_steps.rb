
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

When /^(?:|I )wait until "(.+)"$/ do |content|
  page.wait_until do
    page.has_content?(content)
  end
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
