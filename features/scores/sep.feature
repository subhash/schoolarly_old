Feature: SEP calculation
  Schoolarly should add up scores 
  To form SEP of students
  
  @javascript
  Scenario Outline: SEP calculation from scores
    Given "anju@schoolarly.com" logs in
    When I follow tab "papers"
      And I follow "Scores for FA1 - Malayalam"
      And I enter the following scores for "<student_email>":
      	| 9A_test1_FA1_malayalam | 15 |
      	| 9A_test2_FA1_malayalam | 18|
      	| 9A_reading1_FA1_malayalam | 9 |
      And I follow "9 A" within "#crumbs"
      And I follow tab "papers" 
      And I follow "Scores for FA2 - Malayalam"
      And I enter the following scores for "<student_email>":
        | 9A_test1_FA2_malayalam     | 15  |
      	| 9A_test2_FA2_malayalam     | 18  |
      	| 9A_test3_FA2_malayalam     | N   |
      	| 9A_listening1_FA2_malayalam| 9.5 |   
      And I follow "9 A" within "#crumbs"
      And I follow tab "papers" 
      And I follow "Scores for FA3 - Malayalam"
      And I enter the following scores for "<student_email>":
      	| 9A_test1_FA3_malayalam     | 15 | 
      	| 9A_reading1_FA3_malayalam  | 9  |
      	| 9A_reading2_FA3_malayalam  | 16 |
      	| 9A_reading3_FA3_malayalam  | A  | 
      And I follow "9 A" within "#crumbs"
      And I follow tab "papers" 
      And I follow "Scores for FA4 - Malayalam"
      And I enter the following scores for "<student_email>":
      	| 9A_test1_FA4_malayalam | 17 |  
      	| 9A_test2_FA4_malayalam  | A  |
      	| 9A_test3_FA4_malayalam  | 16 |      	      
      And I follow "9 A" within "#crumbs"
      And I follow "papers-tab-link" 
      And I follow "Scores for SA1 - Malayalam"
      And I enter the following scores for "<student_email>":
      	| 9A_exam1_SA1_malayalam | 75 | 
      And I follow "9 A" within "#crumbs"
      And I follow "papers-tab-link" 
      And I follow "Scores for SA2 - Malayalam"
      And I enter the following scores for "<student_email>":
      	| 9A_exam1_SA2_malayalam | 72 |    
      When "anju@schoolarly.com" logs out
    	   And "<student_email>" logs in
    	   And I follow tab "papers"
    Then I should see "18" within "table[title='Malayalam'] tr[title='FA1'] div[class='detail score']"
       And I should see "16.75" within "table[title='Malayalam'] tr[title='FA2'] div[class='detail score']"
       And I should see "15.3" within "table[title='Malayalam'] tr[title='FA3'] div[class='detail score']"
       And I should see "16.5" within "table[title='Malayalam'] tr[title='FA4'] div[class='detail score']"
       And I should see "75" within "table[title='Malayalam'] tr[title='SA1'] div[class='detail score']"
       And I should see "72" within "table[title='Malayalam'] tr[title='SA2'] div[class='detail score']"
       And I should see "88.025" within "table[title='Malayalam'] td.left div[class='detail score']"  
    Examples:
       | student_email        |
       | reshma@schoolarly.com |
      
   
