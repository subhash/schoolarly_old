Then /^I should see message with subject "(.+)" in "(.+)"$/ do |subject, folder|
  %{I should see "#{subject}" within "#messages-tab-content ##{folder}-area .subject"}
end
