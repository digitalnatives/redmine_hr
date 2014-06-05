Feature: Manage Employee children

  Background:
    Given I am logged in
      And There is a user

  Scenario: Add
     When I visit the new employee child page
      And I fill out the employee child form
      And I click on the create button
     Then I should see an employee child item

  Scenario: Delete
    Given The user has a child
     When I visit the employee profile page
      And I delete the child
     Then I should not see an employee child item

  Scenario: Edit
    Given The user has a child
     When I visit the employee profile page
      And I click on the edit child link
     Then I should be on the edit child page
     When I fill out the employee child form
      And I click on the save button
     Then I should be on the employee profile page
      And I should see an employee child item
