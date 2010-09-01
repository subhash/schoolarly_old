Given /^the following schools:$/ do |schools|
  Schools.create!(schools.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) schools$/ do |pos|
  visit schools_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following schools:$/ do |expected_schools_table|
  expected_schools_table.diff!(tableish('table tr', 'td,th'))
end

Given /school "(.+)" has klasses:$/ do |s, klasses|
  school = schools(s.to_sym)
  assert_not_nil school
  klasses.hashes.each do |k|
    klass = klasses("#{s}_#{k[:klass]}".to_sym)
    assert_not_nil klass
  end
end
