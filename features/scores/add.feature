Feature: Add scores
  School, ClassTeacher and Teacher should be able to
  Add scores of students
  
  @javascript
  Scenario: Teacher adds valid scores for his subjects
    Given I login with "sudha@schoolarly.com"
    When I follow "Subjects"
      And I follow "Scores for FA1 - Social Science"
      And I enter the following scores for "reeny@schoolarly.com":
      	| 9A_test1_FA1_social | 15 |
      	| 9A_test2_FA1_social | -2 |
      	| 9A_project1_FA1_social | 18 |
      And I follow "reeny@schoolarly.com"
    Then I should see "15/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 1']"
       And I should see "N" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 2']"
       And I should see "18/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Group Project']"
   
  @javascript
  Scenario: School adds valid scores for its students
    Given I login with "gps@schoolarly.com"
    When I follow "papers" of class "9 A"
      And I follow "Scores for FA1 - Social Science"
      And I enter the following scores for "reeny@schoolarly.com":
      	| 9A_test1_FA1_social | 15 |
      	| 9A_test2_FA1_social | -2 |
      	| 9A_project1_FA1_social | 18 |
      And I follow "reeny@schoolarly.com"
    Then I should see "15/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 1']"
       And I should see "N" within "table[title='Social Science'] tr[title='FA1']  div[title='Class Test 2']"
       And I should see "18/20" within "table[title='Social Science'] tr[title='FA1']  div[title='Group Project']"