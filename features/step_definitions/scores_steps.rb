When /^(?:|I )enter the following scores for "(.+)":$/ do |email, table|
  student = Student.find_by_id(User.find_by_email(email).person_id)
  params = {}
  table.rows_hash.each do |name, value|
    params[Fixtures.identify(name)] = value
  end
  params = params.to_json
  page.wait_until do
    page.has_link?(email)
  end
  page.execute_script("jQuery('#scores').editRow(#{student.id}, true);")
  page.execute_script("jQuery('#scores').saveRow(#{student.id}, function(){}, null, #{params});")
  page.execute_script("jQuery('#scores').trigger('reloadGrid');")
  page.wait_until do
    page.has_link?(email)
  end
end

