Feature: Manage school_subjects
  In order to manage classes
  School should be able to
  Create and manage subjects
  
  @javascript
  Scenario: Create new school_subjects
    Given I am logged in as school "stteresas"
    When I add the following subjects to "stteresas":
    | name |
    | English |
 	| Malayalam |
    Then I should see "English" within "#school_subjects"
    And I should see "Malayalam" within "#school_subjects"
    