Feature: Manage Holiday Modifier

  Background:
    Given I am logged in
      And There is a user

  Scenario: Add
     When I visit the employee profile page
      And I fill out the holiday modifier form
      And I click on the add button
     Then I should see a holiday modifier item

  Scenario: Delete
    Given The user has a holiday modifier
     When I visit the employee profile page
      And I delete the holiday modifier
     Then I should not see a holiday modifier item

  Scenario: Edit
    Given The user has a holiday modifier
     When I visit the employee profile page
      And I click on the edit link
     Then I should be on the edit holiday modifier page
     When I fill out the holiday modifier form
      And I click on the save button
     Then I should be on the employee profile page
      And I should see a holiday modifier item
