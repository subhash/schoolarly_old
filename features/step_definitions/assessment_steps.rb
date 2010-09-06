When /^I follow "(.+)" of class "(.+)"$/ do |tab, klass|
  click_tab("klasses")
  click(klass)
  click_tab(tab)
end

Then /^I should see link "(.+)"$/ do |content|
  assert page.has_link? content
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

#Given /class "(.+)" has (\d+) subjects$/ do |k, count|
#  klass = klasses(k.to_sym)
#  assert_equal count, k.papers.size
#end
#
#Given /class "(.+)" has subjects:$/ do |k, s_hash|
#  school = "#{symbol(klasses(k.to_sym).school.email)}_#{k}_"
#  s_hash.hashes.each do |s|
#    subject = papers(symbol(s[:name]))
#    klass.subjects.include? s[:name]
#  end
#end