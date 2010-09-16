Feature: Weightage settings for activities
  Teacher should be able to
  Adjust weightages of activities
  
  @javascript
  Scenario Outline: Validation for weightage changes by teacher
    Given "anju@schoolarly.com" logs in
    And I follow tab "papers"
      And I follow "Weightage" within "table[title='Malayalam'] tr[title='<assessment>']  span.weightage"
      And I fill in "<tool1>" with "<weightage1>"
      And I press "Save changes"
    Then I should see "Weightage should addup to 100%"
	When I fill in "<tool2>" with "<weightage2>"
	  And I press "Save changes"
	  And I follow "9 A"
	  And I follow tab "papers"
	  And I follow "Weightage" within "table[title='Malayalam'] tr[title='<assessment>']  span.weightage"
	Then I should see field "<tool1>" with "<weightage1>.00"
	  And I should see field "<tool2>" with "<weightage2>.00"

	Examples:
	| assessment | tool1      | tool2 | weightage1 | weightage2 |
	|  FA1       | Class Test | Reading Comprehension   | 60 | 40 | 
	|  FA2       | Class Test | Listening Comprehension | 80 | 20 | 
	|  FA3       | Class Test | Reading Comprehension   | 50 | 50 | 