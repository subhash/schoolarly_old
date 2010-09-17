Feature: Add scores
  School, ClassTeacher and Teacher should be able to
  Add scores of students
  
  @javascript
  Scenario Outline: Teacher adds and edits valid scores for his subjects
    Given "sudha@schoolarly.com" logs in
    When I follow "Subjects"
      And I follow "Scores for FA1 - Social Science"
      And I enter the following scores for "<student_email>":
      	| 9A_test1_FA1_social | 15 |
      	| 9A_test2_FA1_social | N |
      	| 9A_project1_FA1_social | A |
      And I follow "<student_email>"
    Then I should see "15/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 1']"
       And I should see "N" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 2']"
       And I should see "A" within "table[title='Social Science'] tr[title='FA1']  div[title='Group Project']"
    When "sudha@schoolarly.com" logs out
    	   And "<student_email>" logs in
    	Then I should see message with subject "Score in FA1 Class Test 1 - Social Science - 15.0/20.0" in "inbox"      
    Examples:
       | student_email        |
       | reeny@schoolarly.com |
       | annie@schoolarly.com |
   
  @javascript
  Scenario Outline: School adds and edits valid scores for its students
    Given "gps@schoolarly.com" logs in
    And I wait until "Classes"
    When I follow "papers" of class "9 A"
      And I follow "Scores for FA1 - Social Science"
      And I enter the following scores for "<student_email>":
      	| 9A_test1_FA1_social | 15 |
      	| 9A_test2_FA1_social | N |
      	| 9A_project1_FA1_social | 18 |
      When "gps@schoolarly.com" logs out
    	   And "<student_email>" logs in
    	   And I follow tab "papers"
    Then I should see "15/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 1']"
       And I should see "N" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 2']"
       And I should see "18/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Group Project']"
    	Examples:
       	| student_email        |
       	| reeny@schoolarly.com |
       	| annie@schoolarly.com |