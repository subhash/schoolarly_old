Feature: Manage schools
  Schoolarly should be able to
  Create and manage subjects
  
  Scenario: Add a school as schoolarly admin

  @javascript 
  Scenario: Login and view home page
    Given I login with "gps@schoolarly.com"
  	Then I should see the following links within "ul.tab-bar":
  	    | Messages |
  	    | Events   |
  	    | Classes  |
  	    | Students |
  	    | Teachers |
  	    | Subjects |
  	    | Details  |
  	And I should see the following links within "ul#right-bar":
  	    | Add Class |
  	    | Invite Student |
  	    | Invite Teacher |
  	    | Add Subjects |
  	    | Post Message to Global Public School Admin |
  	    | Post Message to Global Public School |
  
  @javascript  
  Scenario: Login and view another school
  	Given I login with "stteresas@schoolarly.com"
  	And I go to school page "350903752"
  	Then I should see the following links within "ul.tab-bar":
  	    | Classes  |
  	    | Students |
  	    | Teachers |
  	    | Subjects |
  	    | Details  |
  	And I should not see the following links within "ul#right-bar":
  	    | Add Class |
  	    | Invite Student |
  	    | Invite Teacher |
  	    | Add Subjects |
  	    | Post Message to Global Public School Admin |
  	    | Post Message to Global Public School |
  	
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
    
  @javascript  
  Scenario: Add assessment tools to school
    Given I login with "gps@schoolarly.com"
    When I follow "Subjects"
    And I follow "Add Assessment Tools" within "tr[title='French']"
    And I select the following from multiselect "tool_name_ids":
    	  |Recitation|
    	  |Class Test|
    And I unselect "Listening Comprehension" from "tool_name_ids"
    	And I fill in "Add new tool" with "Creativity"
    	And I press "Save changes"
    	Then I should see the following within "tr[title='French']":
    	  |Recitation|
    	  |Class Test|
      |Creativity|
    And I should not see "Listening Comprehension" within "tr[title='French']"
    When I follow "Add Assessment Tools" within "tr[title='Hindi']"
    And I select "Creativity" from multiselect "tool_name_ids"
    	And I press "Save changes"
    	Then I should see "Creativity" within "tr[title='Hindi']"
    	
   Scenario: Edit profile
   Scenario: View school(check permissions)
   Scenario: Send message to school(by student, teachers)