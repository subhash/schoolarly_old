Feature: Weightage settings for activities
  Teacher should be able to
  Adjust weightages of activities
  
  @javascript
  Scenario: Validation for weightage changes by teacher
    Given "anju@schoolarly.com" logs in
    When I follow "Subjects"
      And I follow "Weightage" within "table[title='Malayalam'] tr[title='FA1']  span.weightage"
      And I fill in "Class Test" with "60"
      And I press "Save changes"
    Then I should see "Weightage should addup to 100%"
	When I fill in "Reading Comprehension" with "40"
	  And I press "Save changes"
	  And I follow "9 A"
	  And I follow tab "papers"
	  And I follow "Weightage" within "table[title='Malayalam'] tr[title='FA1']  span.weightage"
	Then I should see field "Class Test" with "60.00"
	  And I should see field "Reading Comprehension" with "40.00"
 