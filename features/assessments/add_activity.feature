Feature: Add activities
  Teacher and School should be able to
  Create activities
  
  @javascript
  Scenario: Add an activity
    Given "gps@schoolarly.com" logs in
      And I wait until "Subjects"
    When I follow "papers" of class "9 A"
      And I follow "Add activity to FA1 - Social Science"
    Then I should see "New activity for FA1 - Social Science" 
	When I select "Group Project" from "assessment_tool_name"
	  And I press "Create Activity"
	Then I should see "Adjust calculations for FA1 - Social Science"
	When I press "Save changes"
	Then I should see link with title "Scores for FA1 Group Project 2 - Social Science"
	  And I should see link with title "Delete FA1 Group Project 2 - Social Science"