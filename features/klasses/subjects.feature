Feature: Manage subjects
  School should be able to
  Create and manage its subjects
  	
  @javascript
  Scenario: Add subjects to school
    Given I login with "stteresas@schoolarly.com"
    When I follow "Add Subjects to St Teresas"
	    	And I select the following from multiselect "subject_ids":
	      | English |
	 	  | Malayalam |
	 	And I press "Save" 
    Then I should see "English" within "#school_subjects"
    		And I should see "Malayalam" within "#school_subjects"
   
    	
   Scenario: Edit profile
   Scenario: View school(check permissions)
   Scenario: Send message to school(by student, teachers)