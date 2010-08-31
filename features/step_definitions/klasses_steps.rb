When /^(?:|I )add the following subjects to klass "(.+) (.+)":$/ do |level, division, subjects|
  klass = Klass.find_by_level_id_and_division(Level.find_by_name(level).id, division)
  initialize_select('school_subject_ids')
  subjects.hashes.each do |sub|
    When %{I select "#{sub[:name]}" from "school_subject_ids"}
  end
  click_button 'Save'
end

Then /^(?:|I )should see the following subjects within klass "(.+) (.+)":$/ do |level, division, subjects|
  klass = Klass.find_by_level_id_and_division(Level.find_by_name(level).id, division)
  assert(within_table('klasses') {
    page.has_link?(klass_path(klass))
#    assert(within('#klass_'+klass.id.to_s) {
      subjects.hashes.each do |s|
        page.has_content?(s[:subject])
      end
    })
#  })
end