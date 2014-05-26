Feature: Edit Employee Profile

  Background:
    Given I am logged in

  Scenario: Add administrator privilege
    Given There is an administrator user
      And The profile should have administrator
     When I visit the edit employee profile page
      And I click on the administrator checkbox
      And I click on the save button
     Then I should be on the employee profile page
      And The profile should not have administrator

  Scenario: Remove administrator privilege
    Given There is a user
      And The profile should not have administrator
     When I visit the edit employee profile page
      And I click on the administrator checkbox
      And I click on the save button
     Then I should be on the employee profile page
      And The profile should have administrator
