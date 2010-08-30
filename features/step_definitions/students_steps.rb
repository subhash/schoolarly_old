Given /^the following students:$/ do |students|
  Students.create!(students.hashes)
end

When /^I delete the (\d+)(?:st|nd|rd|th) students$/ do |pos|
  visit students_path
  within("table tr:nth-child(#{pos.to_i+1})") do
    click_link "Destroy"
  end
end

Then /^I should see the following students:$/ do |expected_students_table|
  expected_students_table.diff!(tableish('table tr', 'td,th'))
end
