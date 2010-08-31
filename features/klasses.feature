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
    When I add the following subjects to klass "1 A":
    		| name |
    		| English |
 		| Malayalam |
 	Then I should see the following subjects within klass "1 A":
       	| subject |
    		| English |
 		| Malayalam |