Feature: View class
  School members should be able to
  view classes
   
  @javascript
  Scenario: View class
  	Given I login with "gps@schoolarly.com"
  	When I follow "papers" of class "9 A"
 	Then I should see the following:
    		| English |
 		| Malayalam |
 		| Science |
 		| Social Science |
 		| Mathematics | 