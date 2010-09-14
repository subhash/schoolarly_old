Feature: Add classes
  School should be able to
  Create classes
  
  @javascript
  Scenario: Add a class
    Given "gps@schoolarly.com" logs in
    When I follow "Add Class to Global Public School"
      And I select "1" from "klass_level_id"
      And I fill in "Division" with "D"
      And I press "Create"
      And I wait until "Add Subjects to 1 D"
      And I follow "Close window"
    Then I should see link with title "1 D"
    
  @javascript
  Scenario: Add a class with subjects
    Given "gps@schoolarly.com" logs in
    When I follow "Add Class to Global Public School"
      And I select "2" from "klass_level_id"
      And I fill in "Division" with "D"
      And I press "Create"
      And I wait until "Add Subjects to 2 D"
      And I select the following from multiselect "school_subject_ids":
    		| English |
 		| Malayalam |
 	  And I press "Save"
 	Then I should see link with title "2 D"
 	  And I follow "papers" of class "2 D"
 	  And I should see "English"
      And I should see "Malayalam"