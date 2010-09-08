Feature: Manage school_subjects
  School should be able to
  Create and manage subjects
  
  @javascript
  Scenario: Create new school_subjects
    Given I login with "stteresas@schoolarly.com"
    When I follow "Add Subjects to St Teresas"
    And I select the following from multiselect "subject_ids":
      | name |
      | English |
 	  | Malayalam |
 	And I press "Save" 
    Then I should see "English" within "#school_subjects"
    And I should see "Malayalam" within "#school_subjects"
    