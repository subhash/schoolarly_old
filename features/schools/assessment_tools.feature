Feature: Manage assessment tools
  Schoolarly should be able to
  Create and manage assessment tools for its subjects

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
