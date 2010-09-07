Feature: Manage classes
  In order to manage students
  School should be able to
  Create and manage classes
  
  @javascript
  Scenario: Add a class
    Given I login with "gps@schoolarly.com"
    When I follow "Add Class"
    And I select "1" from "klass_level_id" within "#new_klass"
    And I fill in "Division" with "D"
    And I press "Create"
    Then I should see "Add subjects to 1 D"
    When I select the following from multiselect "school_subject_ids":
    		| name |
    		| English |
 		| Malayalam |
 	And I press "Save"
 	Then I should see link with title "1 D"
 	When I follow "papers" of class "1 D"
 	Then I should see "English"
    And I should see "Malayalam"
    
    
  @javascript
  Scenario: View Class
  	Given I login with "gps@schoolarly.com"
  	When I follow "papers" of class "9 A"
 	Then I should see the following:
    		| name |
    		| English |
 		| Malayalam |
 		| Science |
 		| Social Science |
 		| Mathematics | 