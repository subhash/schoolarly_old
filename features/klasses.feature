Feature: Manage classes
  In order to manage students
  School should be able to
  Create and manage classes
  
  @javascript
  Scenario: Add a class
    Given I am logged in as school "stteresas"
    And the school "stteresas" has the following subjects:
      	| name |
      	| english |
      	| malayalam |
    When I follow "Add Class"
    And I select "1" from "klass_level_id" within "#new_klass"
    And I fill in "Division" with "A"
    And I press "Create"
    Then I should see "Add subjects to 1 A"
    When I add the following subjects to klass "1 A" of "stteresas":
    		| name |
    		| English |
 		| Malayalam |
 	Then I should see the following subjects for klass "1 A" of "stteresas":
       	| subject |
    		| English |
 		| Malayalam |
	  
  @javascript
  Scenario: View Class
  	Given I am logged in as school "gps"
  	And I am on "klasses" tab
  	And school "gps" has klasses:
  	 	|klass|
  	 	| 9A  |
  	And class "9A_gps" has 5 subjects
  	And class "9A_gps" has subjects:
    		| name |
    		| English |
 		| Malayalam |
 		| Science |
 		| Social Science |
 		| Mathematics | 
 	And I follow "1 A"
 	Then I should be on klass_path("gps_1A")
 	When I am on "subjects" tab
 	Then I should see the subjects:
    		| name |
    		| English |
 		| Malayalam |
 		| Science |
 		| Social Science |
 		| Mathematics | 