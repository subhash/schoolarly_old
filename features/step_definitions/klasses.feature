Feature: Manage classes
  In order to manage students
  As a school
  I want to create and manage classes
  
  @javascript
  Scenario: Creating a class
    Given I go to the home page 
    When I follow "Login"
    And I fill in "Email" with "stteresas@schoolarly.com"
    And I fill in "Password" with "password"
    And I press "Login"
    Then I should be on school_path("stteresas@schoolarly.com") page