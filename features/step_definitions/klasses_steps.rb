When /^(?:|I )add the following subjects to klass "(.+) (.+)" of "(.+):$/ do |level, division, school, subjects|
  klass = Klass.find_by_school_id_level_id_and_division(schools(school.to_sym).id, Level.find_by_name(level).id, division)
  initialize_select('school_subject_ids')
  subjects.hashes.each do |sub|
    When %{I select "#{sub[:name]}" from "school_subject_ids"}
  end
  click_button 'Save'
end

Then /^(?:|I )should see the following subjects for klass "(.+) (.+)" of "(.+)":$/ do |level, division, school, subjects|  
klass = Klass.find_by_school_id_level_id_and_division(schools(school.to_sym).id, Level.find_by_name(level).id, division)
assert(within_table('klasses') {
  page.has_link?(klass_path(klass))
  within('#klass_'+klass.id.to_s) {
    subjects.hashes.each do |s|
      page.has_content?(s[:subject])
    end
  }
})
end

#Given /school "(.+)" has the following klasses:$/ do |school, klasses|
#  klasses.hashes.each do |k|
#    Klass.create(:school => schools(school.to_sym), :level => Level.find_by_name(k[:level]).id, :division => k[:division])
#  end
#end
#
#Given /school "(.+)" has the following papers:$/ do |school, papers|
#  papers.hashes.each do |paper|
#    klass = Klass.find_by_school_id_level_id_and_division(schools(school.to_sym).id, Level.find_by_name(paper[:level]).id, paper[:division])
#    subject = SchoolSubject.find_by_school_id_and_subject_id(schools(school.to_sym).id, Subject.find_by_name(paper[:subject]).id)
#    Paper.create(:klass => klass, :subject => paper[:subject])
#  end
#end

Given /class "(.+)" has (\d+) subjects$/ do |k, count|
  klass = klasses(k.to_sym)
  assert_equal count, k.papers.size
end

Given /class "(.+)" has subjects:$/ do |k, s_hash|
  school = "#{symbol(klasses(k.to_sym).school.email)}_#{k}_"
  s_hash.hashes.each do |s|
    subject = papers(symbol(s[:name]))
    klass.subjects.include? s[:name]
  end
end