Feature: View schools
  Schoolarly users should be able to
  view their schools
   
  
  @javascript 
  Scenario: Login and view home page
    Given "gps@schoolarly.com" logs in
  	Then I should see the following links within "ul.tab-bar":
  	    | Messages |
  	    | Events   |
  	    | Classes  |
  	    | Students |
  	    | Teachers |
  	    | Subjects |
  	    | Details  |
  	And I should see the following links within "ul#right-bar":
  	    | Add Class |
  	    | Invite Student |
  	    | Invite Teacher |
  	    | Add Subjects |
  	    | Post Message to Global Public School Admin |
  	    | Post Message to Global Public School |
  
  @javascript  
  Scenario: Login and view a school by another school
  	Given "stteresas@schoolarly.com" logs in
  	And I go to school page "350903752"
  	Then I should see the following links within "ul.tab-bar":
  	    | Classes  |
  	    | Students |
  	    | Teachers |
  	    | Subjects |
  	    | Details  |
  	And I should not see the following links within "ul#right-bar":
  	    | Add Class |
  	    | Invite Student |
  	    | Invite Teacher |
  	    | Add Subjects |
  	    | Post Message to Global Public School Admin |
  	    | Post Message to Global Public School |
  	    
  @javascript  
  Scenario Outline: Login and view a school by its members
  	Given "<email>" logs in
  	And I follow "Global Public School" within "ul#crumbs"
  	Then I should see the following links within "ul.tab-bar":
  	    | Classes  |
  	    | Students |
  	    | Teachers |
  	    | Subjects |
  	    | Details  |
  	And I should see the following links within "ul#header":
  	    | Home      |
  	    | My Events |  	
  	And I should not see the following links within "ul#right-bar":
  	    | Add Class |
  	    | Invite Student |
  	    | Invite Teacher |
  	    | Add Subjects |
    And I should see the following links within "ul#right-bar":
  	    | Post Message to Global Public School Admin |
  	    | Post Message to Global Public School |  	
  	    
    Examples:
      | email |
      | teena@schoolarly.com |  
      | manju@schoolarly.com |    
      | helen@schoolarly.com |  