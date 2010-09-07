#Given /^the following school_subjects:$/ do |school_subjects|
#  SchoolSubjects.create!(school_subjects.hashes)
#end
#
#When /^I delete the (\d+)(?:st|nd|rd|th) school_subjects$/ do |pos|
#  visit school_subjects_path
#  within("table tr:nth-child(#{pos.to_i+1})") do
#    click_link "Destroy"
#  end
#end
#
#Then /^I should see the following school_subjects:$/ do |expected_school_subjects_table|
#  expected_school_subjects_table.diff!(tableish('table tr', 'td,th'))
#end

When /^(?:|I )add the following subjects to "(.+)":$/ do |s, subjects|
  school = schools(s.to_sym)
  click_link "Add Subjects to #{school.name}"
  initialize_select('subject_ids')
  subjects.hashes.each do |sub|
    When %{I select "#{sub[:name]}" from "subject_ids"}
  end
  click_button 'Save'
end

Given /the school "(.+)" has the following subjects:$/ do |s, subjects|
  school = schools(s.to_sym)
  subjects.hashes.each do |sub|
    SchoolSubject.create(:school => school, :subject => subjects(sub[:name].to_sym))
  end
end
