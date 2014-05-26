Feature: Add Holiday Modifier

  Scenario: Add holiday modifier
    Given I am logged in
      And There is a user
     When I visit the employee profile page
      And I fill out the holiday modifier form
      And I click on the add button
     Then I should see a holiday modifier item
