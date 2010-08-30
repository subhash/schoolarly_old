Feature: Manage classes
  In order to manage students
  School should be able to
  Create and manage classes
  
  @javascript
  Scenario: Add a class
    Given that I have logged in as "stteresas"
    When I follow "Add Class"
    And I select "1" from "klass_level_id" within "#new_klass"
    And I fill in "Division" with "A"
    And I press "Create"
    Then I should see "Add subjects to 1 A"
    
    