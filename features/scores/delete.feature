Feature: Add scores
  School, ClassTeacher, School and Teacher should be able to
  Remove scores of students
  
  @javascript
  Scenario Outline: Teacher deletes scores for students for his subject
    Given "sudha@schoolarly.com" logs in
    When I follow tab "papers"
      And I follow "Scores for FA1 - Social Science"
      And I enter the following scores for "<student_email>":
      	| 9A_test1_FA1_social |  |
      	| 9A_test2_FA1_social |  |
      	| 9A_project1_FA1_social | 18 |
      And "sudha@schoolarly.com" logs out
    	  And "<student_email>" logs in
    	  And I follow tab "papers"
    Then I should not see /span[@class='score']/ within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 1']"
       And I should not see /span[@class='score']/ within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 2']"
       And I should see "18/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Group Project']"
       And I should not see /div[@class='detail score']/ within "table[title='Social Science'] tr[title='FA1']"
      
    Examples:
       | student_email        |
       | annie@schoolarly.com |
